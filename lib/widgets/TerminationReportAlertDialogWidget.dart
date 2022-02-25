import 'dart:convert';

import 'package:app/models/production_item.dart';
import 'package:app/repository/production_order_repository.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:http/http.dart' as http;

import 'CircularLoadingWidget.dart';

class TerminationReportAlertDialogWidget extends StatefulWidget {
  final List<ProductionItem> lines;
  final int locCode;

  TerminationReportAlertDialogWidget({Key key,this.locCode, this.lines}) : super(key: key);

  @override
  _TerminationReportAlertDialogWidgetState createState() =>
      _TerminationReportAlertDialogWidgetState();
}

class _TerminationReportAlertDialogWidgetState extends StateMVC<TerminationReportAlertDialogWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime selectedDate = DateTime.now();

  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  void _showDoneAlertDialog() {
    showDialog(
        context: context,
        builder: (buildContext) {
          return AlertDialog(
            title: Text('Reporte de terminación'),
            content: Text('¿Esta seguro de generar este reporte de terminación?'),
            actions: <Widget>[
              IconButton(
                color: Colors.red,
                icon: Icon(Icons.cancel),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                },
              ),
              IconButton(
                color: Colors.green,
                icon: Icon(Icons.done_all),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                  setState(() {
                    loading = true;
                  });
                  produce(selectedDate, widget.locCode, widget.lines).then((value) {
                    if (value is http.Response) {
                      setState(() {
                        loading = true;
                        if (value.statusCode == 200) {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text("Operación realizada correctamente ${value.body}",
                                style: TextStyle(color: Colors.white)),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 5),
                          )).closed.then((_) {
                            Navigator.of(context).pop('dialog');
                          });
                        } else {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text(json.decode(value.body)['Message'],
                                style: TextStyle(color: Colors.white)),
                            backgroundColor: Colors.red,
                          ));
                        }
                      });
                    }
                  });
                },
              )
            ],
          );
        });
  }

  Future<Null> _selectDate() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().add(Duration(days: -7)),
        lastDate: DateTime.now().add(Duration(days: 7))
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(key: _scaffoldKey,
        resizeToAvoidBottomInset: false, body: SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: (loading) ? CircularLoadingWidget(height: 500) : Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
          'Reporte de terminación',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
          ),
          ElevatedButton(
            onPressed: () => _selectDate(),
            child: Text("Fecha seleccionada: " + "${selectedDate.toLocal()}".split(' ')[0]),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
                  columns: <DataColumn>[
                    DataColumn(
                      label: Text(
                        'Selección',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Nº',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Descripción',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Cantidad',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Lote',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Planeado',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Almacén',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Stock',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                  rows: widget.lines
                      .map((_line) => DataRow(
                    cells: <DataCell>[
                      DataCell(Checkbox(
                        activeColor: Colors.blue,
                        onChanged: (bool checked) {
                          setState(() {
                            _line.selected = checked;
                            if (!_line.selected) {
                              _line.quantity = 0;
                            }
                          });
                        },
                        value: _line.selected,
                      )),
                      DataCell(Text(_line.itemCode)),
                      DataCell(Text(_line.prodName)),
                      DataCell(
                        TextField(
                          controller: TextEditingController()..text = (_line.quantity > 0) ? _line.quantity.toStringAsFixed(4) : null,
                          decoration: InputDecoration(
                              //hintText: ((_line.plannedQty) - (_line.completedQty)).toStringAsFixed(4),
                              border: InputBorder.none,
                              fillColor: Colors.grey,
                              filled: !_line.selected
                          ),
                          keyboardType: TextInputType.number,
                          onSubmitted: (value) {
                            setState(() {
                              _line.quantity = double.parse(value);
                              _line.selected = (_line.quantity > 0) ? true : false;
                            });
                          },
                        ),
                      ),
                      DataCell(
                        TextField(
                          controller: TextEditingController()..text = _line.batchNum,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.grey,
                            filled: _line.batchNum.length < 0,
                          ),
                          keyboardType: TextInputType.number,
                          onSubmitted: (value) {
                            setState(() {
                              _line.batchNum = value;
                            });
                          },
                        ),
                      ),
                      DataCell(Text(_line.plannedQty.toStringAsFixed(4))),
                      DataCell(Text(_line.warehouse)),
                      DataCell(Text(_line.stock.toStringAsFixed(4))),
                    ],
                  )) .toList(),
                ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                color: Colors.red,
                icon: Icon(Icons.cancel),
                onPressed: () {
                  Navigator.of(context).pop('dialog');
                },
              ),
              IconButton(
                color: Colors.green,
                icon: Icon(Icons.done),
                onPressed: () {
                  _showDoneAlertDialog();
                },
              )
            ],
          ),
        ],
      ),
    )));
  }
}
