import 'dart:convert';

import 'package:app/controllers/inventory_transfer_request_controller.dart';
import 'package:app/models/inventory_transfer_request_line.dart';
import 'package:app/models/item_serial_number.dart';
import 'package:app/repository/inventory_transfer_request_repository.dart';
import 'package:app/widgets/CircularLoadingWidget.dart';
import 'package:app/widgets/SerialNumbersAlertDialogWidget.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:intl/intl.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:app/models/item.dart';
import 'package:app/repository/item_repository.dart';
import 'package:app/pages/item.dart';
import 'package:http/http.dart' as http;

class InventoryTransferRequestPage extends StatefulWidget {
  final int docEntry;
  InventoryTransferRequestPage({Key key, this.docEntry}) : super(key: key);

  @override
  _InventoryTransferRequestPageState createState() => _InventoryTransferRequestPageState();
}

class _InventoryTransferRequestPageState extends StateMVC<InventoryTransferRequestPage> {
  InventoryTransferRequestController _con;
  FocusNode itemFocusNode;
  final itemController = TextEditingController();
  bool _validate = true;

  _InventoryTransferRequestPageState() : super(InventoryTransferRequestController()) {
    _con = controller;
  }

  Future<void> scanner(BuildContext context) async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver("#db322a", "Cancelar", true, ScanMode.BARCODE).listen((barcode) {
      _addItem(barcode);
    });
    String barcode = await FlutterBarcodeScanner.scanBarcode("#db322a", "Cancelar", true, ScanMode.BARCODE);
    barcode = (itemController.text.length > 0) ? itemController.text + barcode : barcode;
    _addItem(barcode);
  }

  void _addItem(String code) {
    setState(() {
      try {
        double quantity = 1.0;

        if (code.split('*').length > 1) {
          quantity = double.parse(code.split('*').first);
          code = code.split('*').last;
        }

        InventoryTransferRequestLine line = _con.document.lines.firstWhere((element) => element.itemCode == code || element.codeBars == code);

        if (line != null) {
          if (line.quantity + quantity <= line.constOpenQty) {
            line.quantity += quantity;
            line.openQty = line.constOpenQty - line.quantity;
            itemController.clear();
          } else {
            _showSnackBarQuantity();
          }
        }

        if (_con.document.lines.where((element) => element.quantity >= element.constOpenQty).length == _con.document.lines.length) {
          _showAlertDialog();
        }

        _validate = true;
      } catch (e) {
        _validate = false;
      } finally {
        FocusScope.of(context).requestFocus(itemFocusNode);
      }
    });
  }

  void _showSnackBarQuantity() {
    _con.scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('La cantidad no puede exceder la cantidad pendiente.', style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.red,
    ));
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (buildContext) {
        return AlertDialog(
          title: Text('Solicitud de traslado'),
          content: Text('Se completó la solicitud correctamente.'),
          actions: <Widget>[
            IconButton(
              color: Colors.green,
              icon: Icon(Icons.done),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
            )
          ],
        );
      }
    );
  }

  List<ItemSerialNumber> _getSerialNumbers() {
    List<ItemSerialNumber> serials = [];
    _con.document.lines.forEach((_line) {
      _line.serials.forEach((_serial) {
        serials.add(_serial);
      });
    });

    return serials;
  }

  void _showSerialNumbersDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (buildContext) {
          return SerialNumbersAlertDialogWidget(serialsNumbers: _getSerialNumbers());
        },
    );
  }

  void _showDoneAlertDialog() {
    showDialog(
      context: context,
      builder: (buildContext) {
        return AlertDialog(
          title: Text('Solicitud de traslado'),
          content: Text('¿Esta seguro de guardar este documento?'),
          actions: <Widget>[
            OutlineButton(
              child: Text(
                "Abrir definición de números de serie",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                _showSerialNumbersDialog();
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
                Navigator.of(context, rootNavigator: true).pop('dialog');
                toStockTransfer(_con.document).then((value) {
                  if (value is http.Response) {
                    setState(() {
                      if (value.statusCode == 201) {
                        _con.scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text("Operación realizada correctamente", style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.green,
                        ));
                      } else {
                        _con.scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(json.decode(value.body)['Message'], style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.red,
                        ));
                          _con.document.lines.where((element) => element.quantity > 0).forEach((element) {  _con.removeClosedLine(element.docEntry, element.lineNum); });
                      }
                    });
                  }
                });
              },
            )
          ],
        );
      }
    );
  }

  Future<void> openItem(BuildContext context, String code) async {
    final Stream<Item> stream = await searchItems(code);
    List<Item> items = [];
    await for(Item _item in stream) {
      items.add(_item);
    }
    if (items.length > 0) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ItemPage(item: items.first)));
    }
  }

  @override
  void initState() {
    _con.listenForDocument(docEntry: widget.docEntry);
    itemFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    itemFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        title: Text('Solicitud de traslado'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.done_all,
              color: Colors.white,
            ),
            onPressed: () {
              double serialElements = 0.0;
              _con.document.lines.where((element) => element.serials.length > 0).toList().forEach((element) { serialElements += element.quantity; });
              int selectedSerials = 0;
              _con.document.lines.where((element) => element.serials.length > 0).toList().forEach((element) {
                element.serials.where((element) => element.selected == true).toList().forEach((element) {
                  selectedSerials++;
                });
              });
              if (selectedSerials < serialElements || selectedSerials > serialElements) {
                _showSerialNumbersDialog();
              } else {
                _showDoneAlertDialog();
              }
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _con.refreshDocument,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _con.document.lines.isEmpty ? CircularLoadingWidget(height: 500) :
              Text(
                'Nº Documento: ' + _con.document.docNum.toString(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text('Fecha: ' + DateFormat('dd-MM-yyyy').format(_con.document.docDate)),
              Text(
                'Origen: ${_con.document.whsCode} | Destino: ${_con.document.toWhsCode}',
                style: TextStyle(color: Colors.blue),
              ),
              Text(_con.document.comments),
              TextField(
                controller: itemController,
                focusNode: itemFocusNode,
                decoration: InputDecoration(
                  hintText: 'Ingresa el número de artículo o código de barras',
                  errorText: _validate ? null : 'Artículo no encontrado',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.camera),
                    onPressed: () => scanner(context),
                  ),
                ),
                onSubmitted: (code) { _addItem(code); },
              ),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: <DataColumn>[
                      DataColumn(
                        label: Text(
                          'Cantidad',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Pendiente',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Stock',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Artículo',
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
                          'Origen',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Destino',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                    rows: _con.document.lines.map(
                      ((_line) =>
                        DataRow(
                          cells: <DataCell>[
                            DataCell(
                              TextField(
                                controller: TextEditingController()..text = _line.quantity.toStringAsFixed(4),
                                keyboardType: TextInputType.number,
                                onSubmitted: (value) {
                                  setState(() {
                                    if (double.parse(value) <= _line.constOpenQty) {
                                      _line.quantity = double.parse(value);
                                      _line.openQty = _line.constOpenQty - _line.quantity;
                                    } else {
                                      _showSnackBarQuantity();
                                    }
                                  });

                                  if (_con.document.lines.where((element) => element.quantity >= element.constOpenQty).length == _con.document.lines.length) {
                                    _showAlertDialog();
                                  }
                                },
                              ),
                            ),
                            DataCell(
                              Text(
                                _line.openQty.toStringAsFixed(4),
                                style: TextStyle(fontWeight: FontWeight.bold, color: ((_line.openQty <= 0) ? Colors.green : ((_line.openQty != _line.constOpenQty) ? Colors.red : Colors.blue))),
                              )
                            ),
                            DataCell(Text(_line.stock.toStringAsFixed(4))),
                            DataCell(
                              Text(_line.itemCode, style: TextStyle(fontWeight: FontWeight.bold)),
                              onTap: () => openItem(context, _line.itemCode),
                            ),
                            DataCell(Text(_line.dscription)),
                            DataCell(Text(_line.fromWhsCod)),
                            DataCell(Text(_line.whsCode)),
                          ],
                        )),
                    ).toList()
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}