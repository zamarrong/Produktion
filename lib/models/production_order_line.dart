import 'package:app/models/production_order_line_sequence.dart';

import 'item.dart';

class ProductionOrderLine {
  int docEntry;
  int lineNum;
  String issueType;
  String itemCode;
  String ocrCode;
  String project;
  String warehouse;
  String uomCode;
  String wipAcctCode;
  double baseQty;
  double plannedQty;
  double issuedQty;
  double additionalQty;
  double pickQty;
  int pickIdNo;
  double releaseQty;
  double stock;
  int locCode;
  String fromWhs;
  Item item;
  ProductionOrderLineSequence sequence;
  bool selected;

  ProductionOrderLine();

  ProductionOrderLine.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      selected = false;
      docEntry = int.parse(jsonMap['DocEntry'].toString());
      lineNum = int.parse(jsonMap['LineNum']);
      issueType = jsonMap['IssueType'];
      itemCode = jsonMap['ItemCode'];
      ocrCode = jsonMap['OcrCode'] ?? '';
      project = jsonMap['Project'] ?? '';
      warehouse = jsonMap['wareHouse'];
      uomCode = jsonMap['UomCode'];
      wipAcctCode = jsonMap['WipAcctCode'];
      baseQty = double.parse(jsonMap['BaseQty']);
      plannedQty = double.parse(jsonMap['PlannedQty']);
      issuedQty = double.parse(jsonMap['IssuedQty']);
      additionalQty = double.parse(jsonMap['AdditQty']);
      pickQty = double.parse(jsonMap['PickQty']);
      pickIdNo = jsonMap['PickIdNo'] != null ? int.parse(jsonMap['PickIdNo'] ?? '0') : 0;
      releaseQty = double.parse(jsonMap['ReleaseQty']);
      stock = double.parse(jsonMap['Stock'].toString());
      locCode = int.parse(jsonMap['U_LocCode'] ?? '0');
      fromWhs = jsonMap['U_FromWhs'] ?? '';
      item = jsonMap['item'] != null ? Item.fromJSON(jsonMap['item']) : new Item();
      sequence = jsonMap['sequence'] != null ? ProductionOrderLineSequence.fromJSON(jsonMap['sequence']) : new ProductionOrderLineSequence();
    } catch (e) {
      warehouse = '';
      sequence = new ProductionOrderLineSequence();
      print('Error: ${e} ProductionOrderLine: ${jsonMap}');
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['ItemCode'] = itemCode;
    return map;
  }
}