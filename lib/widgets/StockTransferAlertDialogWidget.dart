import 'dart:convert';

import 'package:app/models/item_batch_number.dart';
import 'package:app/models/stock_transfer.dart';
import 'package:app/models/warehouse.dart';
import 'package:app/repository/item_repository.dart';
import 'package:app/repository/stock_transfer_repository.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:http/http.dart' as http;

import 'BatchNumbersAlertDialogWidget.dart';

class StockTransferAlertDialogWidget extends StatefulWidget {
  final StockTransfer document;
  final List<Warehouse> warehouses;

  StockTransferAlertDialogWidget({Key key, this.document, this.warehouses}) : super(key: key);

  @override
  _StockTransferAlertDialogWidgetState createState() =>
      _StockTransferAlertDialogWidgetState();
}

class _StockTransferAlertDialogWidgetState extends StateMVC<StockTransferAlertDialogWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  Future<List<ItemBatchNumber>> _getBatchNumbers(String itemCode, String whsCode, int locCode) async{
    List<ItemBatchNumber> batchNumbers = [];

    final Stream<ItemBatchNumber> stream = await getBatchNumbers(itemCode, whsCode, locCode);
    stream.listen((ItemBatchNumber _batchNumber) {
        batchNumbers.add(_batchNumber);
    });

    return batchNumbers;
  }

  Future<void> _showBatchNumbersDialog() async {
    widget.document.lines.forEach((_line) async {
      if (_line.item.manageBatch) {
        List<ItemBatchNumber> batchNumbers = await _getBatchNumbers(_line.item.code, _line.fromWhsCod, _line.locCode);
        _line.batches = batchNumbers;
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (buildContext) {
            return BatchNumbersAlertDialogWidget(item: _line.item, quantity: _line.quantity, batchsNumbers: _line.batches);
          },
        );
      }
    });
  }

  void _showDoneAlertDialog() {
    showDialog(
        context: context,
        builder: (buildContext) {
          return AlertDialog(
            title: Text('Transferencia de componentes'),
            content: Text('¿Esta seguro de guardar este documento?'),
            actions: <Widget>[
              OutlineButton(
                child: Text(
                  "Seleccionar lotes",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  _showBatchNumbersDialog();
                },
              ),
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
                  addDocument(widget.document).then((value) {
                    if (value is http.Response) {
                      setState(() {
                        if (value.statusCode == 201) {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text("Operación realizada correctamente",
                                style: TextStyle(color: Colors.white)),
                            backgroundColor: Colors.green,
                          ));
                          Navigator.of(context).pop('dialog');
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
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(key: _scaffoldKey, body: SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              'Transferencia de componentes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
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
                    'Almacén origen',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Almacén destino',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Stock almacen destino',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
              rows: widget.document.lines.map((_line) => DataRow(
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
                  DataCell(Text(_line.dscription)),
                  DataCell(
                    TextField(
                      controller: TextEditingController()..text = (_line.quantity > 0) ? _line.quantity.toStringAsFixed(4) : null,
                      decoration: InputDecoration(
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
                    DropdownSearch<Warehouse>(
                        mode: Mode.MENU,
                        items: widget.warehouses,
                        hint: "Selecciona el almacén de origen",
                        itemAsString: (Warehouse w) => w.code,
                        onChanged: (Warehouse data) => _line.fromWhsCod = data.code,
                        selectedItem: (_line.fromWhsCod != '') ? widget.warehouses.firstWhere((element) => element.code == _line.fromWhsCod) : null
                    ),
                  ),
                  DataCell(
                    DropdownSearch<Warehouse>(
                        mode: Mode.MENU,
                        items: widget.warehouses,
                        hint: "Selecciona el almacén de destino",
                        itemAsString: (Warehouse w) => w.code,
                        onChanged: (Warehouse data) => _line.whsCode = data.code,
                        selectedItem: widget.warehouses.firstWhere((element) => element.code == _line.whsCode)
                    ),
                  ),
                  DataCell(Text(_line.stock.toStringAsFixed(4))),
                ],
              ))
                  .toList(),
            ),
          ),
          TextFormField(
              controller: TextEditingController()..text = widget.document.comments,
              decoration: InputDecoration(
                  labelText: 'Comentarios',
                  hintText: 'Comentarios.'
              ),
              onFieldSubmitted: (value) {
                setState(() {
                  widget.document.comments = value;
                });
              }
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