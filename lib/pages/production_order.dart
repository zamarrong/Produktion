import 'dart:convert';

import 'package:app/controllers/production_order_controller.dart';
import 'package:app/helpers/helper.dart';
import 'package:app/models/inventory_transfer_request.dart';
import 'package:app/models/inventory_transfer_request_line.dart';
import 'package:app/models/production_item.dart';
import 'package:app/models/production_order_line.dart';
import 'package:app/models/stock_transfer.dart';
import 'package:app/models/stock_transfer_line.dart';
import 'package:app/models/user.dart';
import 'package:app/repository/production_order_repository.dart';
import 'package:app/repository/user_repository.dart';
import 'package:app/widgets/CircularLoadingWidget.dart';
import 'package:app/widgets/GenEntryAlertDialogWidget.dart';
import 'package:app/widgets/GenExitAlertDialogWidget.dart';
import 'package:app/widgets/StockTransferAlertDialogWidget.dart';
import 'package:app/widgets/InventoryTransferRequestAlertDialogWidget.dart';
import 'package:app/widgets/TerminationReportAlertDialogWidget.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:intl/intl.dart';
import 'package:app/models/item.dart';
import 'package:app/repository/item_repository.dart';
import 'package:app/pages/item.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:http/http.dart' as http;

class ProductionOrderPage extends StatefulWidget {
  final int docEntry;

  ProductionOrderPage({Key key, this.docEntry}) : super(key: key);

  @override
  _ProductionOrderPageState createState() => _ProductionOrderPageState();
}

class _ProductionOrderPageState extends StateMVC<ProductionOrderPage> {
  ProductionOrderController _con;
  FocusNode itemFocusNode;
  final itemController = TextEditingController();
  bool _validate = true;

  _ProductionOrderPageState() : super(ProductionOrderController()) {
    _con = controller;
  }

  void _showAlertDialog() {
    showDialog(
        context: context,
        builder: (buildContext) {
          return AlertDialog(
            title: Text('Orden de producción'),
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
        });
  }

  void _showDoneAlertDialog() {
    showDialog(
        context: context,
        builder: (buildContext) {
          return AlertDialog(
            title: Text('Orden de producción'),
            content: Text('¿Esta seguro de guardar este documento?'),
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
                  updateDocument(_con.document).then((value) {
                    if (value is http.Response) {
                      setState(() {
                        if (value.statusCode == 200) {
                          _con.scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text("Operación realizada correctamente",
                                style: TextStyle(color: Colors.white)),
                            backgroundColor: Colors.green,
                          ));
                          _con.refreshDocument();
                        } else {
                          _con.scaffoldKey.currentState.showSnackBar(SnackBar(
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

  Future<void> getUser() async {
    final Stream<User> stream = await authUser();
      stream.listen((User _user) async {
      Helper.authUser = _user;
    });
  }

  Future<void> openItem(BuildContext context, String code) async {
    final Stream<Item> stream = await searchItems(code);
    List<Item> items = [];
    await for (Item _item in stream) {
      items.add(_item);
    }
    if (items.length > 0) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ItemPage(item: items.first)));
    }
  }

  Future<void> _showTerminationReportDialog() async {
    List<ProductionItem> productionItems = new List<ProductionItem>();

    for (var i = 0; i < _con.document.ordersNumber; i++) {
      ProductionItem productionItem = new ProductionItem();

      DateTime now = DateTime.now();
      String formattedDate = DateFormat('ddMMyy').format(now);

      productionItem.docEntry = _con.document.docEntry;
      productionItem.itemCode = _con.document.itemCode;
      productionItem.prodName = _con.document.prodName;
      productionItem.warehouse = _con.document.warehouse;
      productionItem.plannedQty = _con.document.plannedQty;
      productionItem.completedQty = _con.document.completedQty;
      productionItem.quantity = 0;
      //productionItem.batchNum = '${formattedDate}001${productionItem.itemCode.substring(productionItem.itemCode.length - 2)}';
      productionItem.selected = false;

      final Stream<Item> stream = await searchItems(_con.document.itemCode);
      await for (Item _item in stream) {
        productionItem.item = _item;
        productionItem.stock = _item.stock;
      }

      productionItems.add(productionItem);
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (buildContext) {
        return TerminationReportAlertDialogWidget(locCode: _con.document.locCode, lines: productionItems);
      },
    ).whenComplete(() => _con.refreshDocument());

   /* showBarModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: TerminationReportAlertDialogWidget(lines: productionItems),
      ),
    ).whenComplete(() => _con.refreshDocument());*/
  }

  Future<void> _showGenEntryReportDialog() async {
    List<ProductionOrderLine> lines =
        _con.document.lines.where((element) => element.plannedQty < 0 && element.sequence.stageId == _con.currentStageId).toList();
    List<ProductionItem> productionItems = new List<ProductionItem>();

    lines.forEach((element) {
      ProductionItem productionItem = new ProductionItem();

      productionItem.docEntry = element.docEntry;
      productionItem.baseLine = element.lineNum;
      productionItem.itemCode = element.itemCode;
      productionItem.prodName = element.item.name;
      productionItem.warehouse = element.warehouse;
      productionItem.plannedQty = element.plannedQty;
      productionItem.completedQty = 0;
      productionItem.quantity = 0;
      productionItem.selected = false;
      productionItem.item = element.item;
      productionItem.stock = element.stock;

      productionItems.add(productionItem);
    });

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (buildContext) {
        return GenEntryAlertDialogWidget(lines: productionItems);
      },
    ).whenComplete(() => _con.refreshDocument());

    /*showBarModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: GenEntryAlertDialogWidget(lines: productionItems),
      ),
    ).whenComplete(() => _con.refreshDocument());*/
  }

  Future<void> _showGenExitReportDialog() async {
    List<ProductionOrderLine> lines =
        _con.document.lines.where((element) => element.plannedQty > 0 && element.sequence.stageId == _con.currentStageId).toList();
    List<ProductionItem> productionItems = new List<ProductionItem>();

    lines.forEach((element) {
      ProductionItem productionItem = new ProductionItem();

      productionItem.docEntry = element.docEntry;
      productionItem.baseLine = element.lineNum;
      productionItem.itemCode = element.itemCode;
      productionItem.prodName = element.item.name;
      productionItem.warehouse = element.warehouse;
      productionItem.locCode = element.locCode;
      productionItem.plannedQty = element.plannedQty;
      productionItem.completedQty = 0;
      productionItem.quantity = 0;
      productionItem.selected = false;
      productionItem.item = element.item;
      productionItem.stock = element.stock;

      productionItems.add(productionItem);
    });

    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (buildContext) {
          return GenExitAlertDialogWidget(lines: productionItems);
      },
    ).whenComplete(() => _con.refreshDocument());

    /*showBarModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: GenExitAlertDialogWidget(lines: productionItems),
      ),
    ).whenComplete(() => _con.refreshDocument());*/
  }

  Future<void> _showInventoryTransferRequestDialog() async {
    InventoryTransferRequest document = new InventoryTransferRequest();

    document.whsCode = _con.document.lines.first.fromWhs;
    document.toWhsCode = _con.document.warehouse;
    document.comments =
        'Producktion basado en orden de producción: ${_con.document.docNum}';

    _con.document.lines.where((element) => element.sequence.stageId == _con.currentStageId).forEach((_line) {
      if (_line.item.inventoriable) {
        InventoryTransferRequestLine line = new InventoryTransferRequestLine();

        line.itemCode = _line.itemCode;
        line.dscription = _line.item.name;
        line.codeBars = _line.item.codeBars;
        line.fromWhsCod = _line.fromWhs;
        line.whsCode = _line.warehouse;
        line.quantity = 0;
        line.stock = _line.stock;
        line.selected = false;
        line.serials = [];

        document.lines.add(line);
      }
    });

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (buildContext) {
        return InventoryTransferRequestAlertDialogWidget(document: document, warehouses: _con.warehouses);
      },
    );

    /*await showBarModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: InventoryTransferRequestAlertDialogWidget(
            document: document, warehouses: _con.warehouses),
      ),
    );*/
  }

  Future<void> _showStockTransferDialog() async {
    StockTransfer document = new StockTransfer();

    document.whsCode = _con.document.lines.first.fromWhs;
    document.toWhsCode = _con.document.warehouse;
    document.comments =
        'Producktion basado en orden de producción: ${_con.document.docNum}';

    _con.document.lines.where((element) => element.sequence.stageId == _con.currentStageId).forEach((_line) {
      if (_line.item.inventoriable) {
        StockTransferLine line = new StockTransferLine();

        line.item = _line.item;
        line.baseEntry = _con.document.docEntry;
        line.itemCode = _line.itemCode;
        line.dscription = _line.item.name;
        line.codeBars = _line.item.codeBars;
        line.fromWhsCod = _line.fromWhs;
        line.whsCode = _line.warehouse;
        line.locCode = _line.locCode;
        line.quantity = 0;
        line.stock = _line.stock;
        line.selected = false;
        line.serials = [];

        document.lines.add(line);
      }
    });

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (buildContext) {
        return StockTransferAlertDialogWidget(
            document: document, warehouses: _con.warehouses);
      },
    );

    /*await showBarModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: StockTransferAlertDialogWidget(
            document: document, warehouses: _con.warehouses),
      ),
    );*/
  }

  @override
  void initState() {
    getUser();
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Orden de producción'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.done,
              color: Colors.white,
            ),
            onPressed: () {
              _showDoneAlertDialog();
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
              (_con.loading || Helper.authUser == null)
                  ? CircularLoadingWidget(height: 500)
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${_con.document.getStatus()}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: (_con.document.status == 'P')
                                        ? Colors.blue
                                        : Colors.green),
                              ),
                              Text(
                                'Nº Producto ${_con.document.itemCode}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Descripción ${_con.document.prodName}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  'Ctd. planeada ${_con.document.plannedQty.toStringAsFixed(3)}'),
                              Text(
                                  'Ctd. completada ${_con.document.completedQty.toStringAsFixed(3)}'),
                              Text('Almacén ${_con.document.warehouse}'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  'Nº ${_con.document.serie.name} ${_con.document.docNum.toString()}'),
                              Text(
                                  'Fecha orden ${DateFormat('dd-MM-yyyy').format(_con.document.postDate)}'),
                              Text(
                                  'Fecha inicio ${DateFormat('dd-MM-yyyy').format(_con.document.startDate)}'),
                              Text(
                                  'Finalización ${DateFormat('dd-MM-yyyy').format(_con.document.dueDate)}'),
                              Text('Norma reparto ${_con.document.ocrCode}'),
                            ],
                          ),
                        ),
                      ],
                    ),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    DropdownButton(
                        value: _con.document.status,
                        items: [
                          DropdownMenuItem(
                            child: Text("Cancelado"),
                            value: "C",
                          ),
                          DropdownMenuItem(
                            child: Text("Cerrado"),
                            value: "L",
                          ),
                          DropdownMenuItem(
                            child: Text("Planeado"),
                            value: "P",
                          ),
                          DropdownMenuItem(
                            child: Text("Liberado"),
                            value: "R",
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _con.document
                                .status = value;
                          });
                        }),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                        initialValue: _con.document.ordersNumber.toString(),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Número de lotes a recibir',
                            hintText: 'Ingresa el número de lotes.'),
                        onFieldSubmitted: (value) {
                          setState(() {
                            _con.document.ordersNumber = int.parse(value);
                          });
                        }),
                  ],
                ),
              ),
              ]),
              TextFormField(
                  initialValue: _con.document.comments,
                  decoration: InputDecoration(
                      labelText: 'Comentario',
                      hintText: 'Ingresar comentarios generales.'),
                  onFieldSubmitted: (value) {
                    setState(() {
                      _con.document.comments = value;
                    });
                  }),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    Visibility(
                      visible: Helper.authUser.terminationReport,
                      child: RaisedButton(
                        color: Colors.green,
                        child: Text(
                          "Reporte de terminación",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          _showTerminationReportDialog();
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Visibility(
                      visible: Helper.authUser.genEntry,
                      child: RaisedButton(
                        color: Colors.black87,
                        child: Text(
                          "Entrega componentes",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          _showGenExitReportDialog();
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Visibility(
                      visible: Helper.authUser.stockTransferRequest,
                      child: RaisedButton(
                        color: Colors.black54,
                        child: Text(
                          "Solicitud de transferencia",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          _showInventoryTransferRequestDialog();
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Visibility(
                      visible: Helper.authUser.stockTransfer,
                      child: RaisedButton(
                        color: Colors.black45,
                        child: Text(
                          "Transferencia de componentes",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          _showStockTransferDialog();
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Visibility(
                      visible: Helper.authUser.genExit,
                      child: RaisedButton(
                        color: Colors.black38,
                        child: Text(
                          "Entrada subproductos",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          _showGenEntryReportDialog();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              _con.currentStageId != 0
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        DropdownButton(
                            value: _con.currentStageId,
                            items:
                              _con.document.sequences.map((e) =>
                                DropdownMenuItem(
                                  child: Text('Etapa ${e.name}', style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.bold)),
                                  value: e.stageId,
                                )).toList(),
                            onChanged: (value) {
                              setState(() {
                                _con.currentStageId = value;
                              });
                            }),
                        SizedBox(width: 10),
                        DropdownButton(
                            value: _con.document.sequences
                                .firstWhere((element) =>
                                    element.stageId == _con.currentStageId)
                                .status,
                            items: [
                              DropdownMenuItem(
                                child: Text("Pendiente"),
                                value: "P",
                              ),
                              DropdownMenuItem(
                                child: Text("Iniciado"),
                                value: "S",
                              ),
                              DropdownMenuItem(
                                child: Text("Finalizado"),
                                value: "F",
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _con.document.sequences
                                    .firstWhere((element) =>
                                        element.stageId == _con.currentStageId)
                                    .status = value;
                              });
                            }),
                        Text(
                          '${_con.getSequencesComments()}',
                          softWrap: true,
                        ),
                        TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Comentarios de la etapa',
                                hintText:
                                    'Ingresar comentarios de la etapa actual.'),
                            onFieldSubmitted: (value) {
                              setState(() {
                                _con.document.sequences
                                    .firstWhere((element) =>
                                        element.stageId == _con.currentStageId)
                                    .comments = value;
                              });
                            }),
                      ],
                    )
                  : Text(
                      'Se finalizaron todas las etapas.',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
              (!_con.loading && _con.currentStageId != 0)
                  ? Column(
                      children: <Widget>[
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                                columns: <DataColumn>[
                                  DataColumn(
                                    label: Text(
                                      'Etapa',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Nº',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Descripción',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Ctd. base',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Ctd. requerida',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Ctd. consumida',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Ctd. adicional',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Almacén',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Stock',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ],
                                rows: _con.document.lines.where((l) => l.sequence.stageId == _con.currentStageId)
                                    .map(
                                      ((_line) => DataRow(
                                            cells: <DataCell>[
                                              DataCell(
                                                Text(_line.sequence.name,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                              DataCell(
                                                Text(_line.itemCode,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.blue)),
                                                onTap: () => openItem(
                                                    context, _line.itemCode),
                                              ),
                                              DataCell(
                                                Text(_line.item.name,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                              DataCell(Text(_line.baseQty
                                                  .toStringAsFixed(4))),
                                              DataCell(
                                                Text(
                                                    _line.plannedQty
                                                        .toStringAsFixed(4),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                              DataCell(
                                                Text(
                                                    _line.issuedQty
                                                        .toStringAsFixed(4),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.blue)),
                                              ),
                                              DataCell(
                                                TextField(
                                                  controller:
                                                      TextEditingController()
                                                        ..text = _line
                                                            .additionalQty
                                                            .toStringAsFixed(4),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  onSubmitted: (value) {
                                                    setState(() {
                                                      _line.additionalQty =
                                                          double.parse(value);
                                                    });
                                                  },
                                                ),
                                              ),
                                              DataCell(Text(_line.warehouse)),
                                              DataCell(Text(_line.stock
                                                  .toStringAsFixed(4))),
                                            ],
                                          )),
                                    )
                                    .toList()),
                          ),
                        )
                      ],
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
