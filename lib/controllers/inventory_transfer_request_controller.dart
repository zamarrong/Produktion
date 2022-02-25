import 'package:app/models/inventory_transfer_request.dart';
import 'package:app/models/inventory_transfer_request_line.dart';
import 'package:app/repository/inventory_transfer_request_repository.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';


class InventoryTransferRequestController extends ControllerMVC {
  List<InventoryTransferRequest> documents = <InventoryTransferRequest>[];
  InventoryTransferRequest document;
  GlobalKey<ScaffoldState> scaffoldKey;

  InventoryTransferRequestController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForDocuments({String status, String message}) async {
    documents.clear();
    final Stream<InventoryTransferRequest> stream = await getDocumentsByStatus(status);
    stream.listen((InventoryTransferRequest _document) {
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
  }

  void listenForDocument({int docEntry, String message}) async {
    document = new InventoryTransferRequest();
    final Stream<InventoryTransferRequest> stream = await getDocumentByDocEntry(docEntry);
    stream.listen((InventoryTransferRequest _document) {
      setState(() {
        document = _document;
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
      clearQuantity();
    });
  }

  void removeClosedLine(int docEntry, int lineNum) async {
    InventoryTransferRequestLine line = new InventoryTransferRequestLine();
    final Stream<InventoryTransferRequestLine> stream = await getDocumentLine(docEntry, lineNum);
    stream.listen((InventoryTransferRequestLine _line) {
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
      if (line.lineStatus == 'C') {
        setState(() {
          document.lines.removeWhere((element) => element.lineNum == line.lineNum);
        });
      }
    });
  }

  void clearQuantity() {
    if (document != null) {
      document.lines.forEach((element) {
        setState(() {
          element.quantity = 0;
        });
      });
    }
  }

  Future<void> refreshDocuments() async {
    listenForDocuments(status: 'O', message: 'Se actualizó la lista correctamente');
  }

  Future<void> refreshDocument() async {
    if (document != null) {
      listenForDocument(docEntry: document.docEntry, message: 'Se actualizó el documento correctamente');
    }
  }
}