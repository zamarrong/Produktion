import 'package:app/models/production_order_line.dart';
import 'package:app/models/production_order_line_sequence.dart';
import 'package:flutter/material.dart';

import 'Serie.dart';

class ProductionOrder {
  int docEntry;
  int docNum;
  String itemCode;
  String prodName;
  String cardCode;
  String type;
  String status;
  String priority;
  int series;
  int ordersNumber;
  Serie serie;
  String ocrCode;
  String project;
  DateTime postDate;
  DateTime startDate;
  DateTime dueDate;
  DateTime closeDate;
  DateTime releaseDate;
  String warehouse;
  String comments;
  String pickRemark;
  int locCode;
  double plannedQty;
  double completedQty;
  double rejectedQty;

  List<ProductionOrderLine> lines;
  List<ProductionOrderLineSequence> sequences;

  ProductionOrder() {
    docEntry = docNum = 0;
    postDate = startDate = dueDate = closeDate = releaseDate = new DateTime.now();
    itemCode = prodName = cardCode = comments = '';
    lines = [];
  }

  ProductionOrder.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      docEntry = jsonMap['DocEntry'];
      docNum = int.parse(jsonMap['DocNum']);
      itemCode = jsonMap['ItemCode'];
      prodName = jsonMap['ProdName'];
      cardCode = jsonMap['CardCode'] ?? '';
      type = jsonMap['Type'];
      status = jsonMap['Status'];
      priority = jsonMap['Priority'];
      series = int.parse(jsonMap['Series']);
      ordersNumber = int.parse(jsonMap['U_OrdersNumber'].toString() ?? '1');
      serie = Serie.fromJSON(jsonMap['serie']);
      ocrCode = jsonMap['OcrCode'];
      project = jsonMap['Project'];
      postDate = DateTime.parse(jsonMap['PostDate']);
      startDate = DateTime.parse(jsonMap['StartDate']);
      dueDate = DateTime.parse(jsonMap['DueDate']);
      closeDate = jsonMap['CloseDate'] != null ? DateTime.parse(jsonMap['CloseDate']) : new DateTime.now();
      releaseDate = jsonMap['RlsDate'] != null ? DateTime.parse(jsonMap['RlsDate']) : new DateTime.now();
      warehouse = jsonMap['Warehouse'];
      comments = jsonMap['Comments'] ?? '';
      pickRemark = jsonMap['PickRmrk'] ?? '';
      locCode = int.parse(jsonMap['U_LocCode'] ?? '0');
      plannedQty = double.parse(jsonMap['PlannedQty'] ?? '0');
      completedQty = double.parse(jsonMap['CmpltQty'] ?? '0');
      rejectedQty = double.parse(jsonMap['RjctQty'] ?? '0');
      if (jsonMap['lines'] != null) {
        lines = (jsonMap['lines'] as List).length > 0
            ? List.from(jsonMap['lines']).map((element) =>
            ProductionOrderLine.fromJSON(element)).toSet().toList()
            : [];
      } else {
        lines = [];
      }
      if (jsonMap['sequences'] != null) {
        sequences = (jsonMap['sequences'] as List).length > 0
            ? List.from(jsonMap['sequences']).map((element) =>
            ProductionOrderLineSequence.fromJSON(element)).toSet().toList()
            : [];
      } else {
        lines = [];
      }
    } catch (e) {
      docEntry = 0;
      docNum = 0;
      status  = 'P';
      postDate = startDate = dueDate = closeDate = releaseDate = new DateTime.now();
      itemCode = prodName = cardCode = comments = '';
      lines = [];
      sequences = [];
      print('Error: ${e} ProductionOrder: ${jsonMap}');
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['DocEntry'] = docEntry;
    map['DocNum'] = docNum;
    map['ItemCode'] = itemCode;
    map['ProdName'] = prodName;
    map['CardCode'] = cardCode;
    map['Type'] = type;
    map['Status'] = status;
    map['Priority'] = priority;
    map['OrdersNumber'] = ordersNumber;
    map['Series'] = series;
    map['OcrCode'] = ocrCode;
    map['Project'] = project;
    map['PostDate'] = postDate.toIso8601String();
    map['StartDate'] = startDate.toIso8601String();
    map['DueDate'] = dueDate.toIso8601String();
    map['CloseDate'] = closeDate.toIso8601String();
    map['ReleaseDate'] = releaseDate.toIso8601String();
    map['Warehouse'] = warehouse;
    map['Comments'] = comments;
    map['PickRemark'] = pickRemark;
    map['LocCode'] = locCode;
    map['PlannedQty'] = plannedQty;
    map['CompletedQty'] = completedQty;
    map['RejectedQty'] = rejectedQty;
    map['Sequences'] = sequences?.map((element) => element.toMap())?.toList();
    return map;
  }

  String getStatus()
  {
    try {
      switch (status) {
        case 'C':
          return "Cancelado";
        case 'L':
          return "Cerrado";
        case 'P':
          return "Planeado";
        case 'R':
          return "Liberado";
        default:
          return "Nuevo";
      }
    } catch (e) {
      return "Error";
    }
  }

  @override
  bool operator == (dynamic other) {
    return other.docEntry == this.docEntry;
  }

  @override
  int get hashCode => this.docEntry.hashCode;
}