import 'package:app/models/production_order.dart';
import 'package:app/models/production_order_line.dart';
import 'package:app/models/stage.dart';
import 'package:app/models/warehouse.dart';
import 'package:app/repository/catalog_repository.dart';
import 'package:app/repository/production_order_repository.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';


class ProductionOrderController extends ControllerMVC {
  List<ProductionOrder> documents = <ProductionOrder>[];
  List<Warehouse> warehouses = <Warehouse>[];
  ProductionOrder document;
  GlobalKey<ScaffoldState> scaffoldKey;
  int currentStageId = 0;
  bool loading = false;

  ProductionOrderController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForDocuments({String status, String message}) async {
    loading = true;
    documents.clear();
    final Stream<ProductionOrder> stream = await getDocumentsByStatus(status);
    stream.listen((ProductionOrder _document) {
      setState(() {
        documents.add(_document);
      });
    }, onError: (a) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Verifica tu conexión a internet"),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
    loading = false;
  }

  void listenForWarehouses() async {
    warehouses.clear();
    final Stream<Warehouse> stream = await getWarehouses();
    stream.listen((Warehouse _warehouse) {
      setState(() {
        warehouses.add(_warehouse);
      });
    });
  }

  void listenForDocument({int docEntry, String message}) async {
    loading = true;
    document = new ProductionOrder();
    final Stream<ProductionOrder> stream = await getDocumentByDocEntry(docEntry);
    stream.listen((ProductionOrder _document) {
      setState(() {
        document = _document;
        listenForWarehouses();
        try {
          currentStageId = _document.sequences
              .firstWhere((element) => element.status != "F")
              .stageId;
        } catch (e) {
          print(e);
        }
      });
    }, onError: (a) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Verifica tu conexión a internet"),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
    loading = false;
  }

  void removeClosedLine(int docEntry, int lineNum) async {
    ProductionOrderLine line = new ProductionOrderLine();
    final Stream<ProductionOrderLine> stream = await getDocumentLine(docEntry, lineNum);
    stream.listen((ProductionOrderLine _line) {
      setState(() {
        line = _line;
      });
    }, onError: (a) {
      print(line.toString());
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(a.toString(), style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ));
    }, onDone: () {
      //
    });
  }

  Future<void> refreshDocuments() async {
    listenForDocuments(status: 'R', message: 'Se actualizó la lista correctamente');
  }

  Future<void> refreshDocument() async {
    if (document != null) {
      listenForDocument(docEntry: document.docEntry, message: 'Se actualizó el documento correctamente');
    }
  }

  String getSequencesComments() {
    String comments = '';
    document.sequences.where((element) => element.comments.length > 0).map((sequence) =>
      comments += '${sequence.name}: ${sequence.comments} \n'
    ).toList();
    return comments;
  }
}