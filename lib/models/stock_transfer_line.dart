import 'package:app/models/item_batch_number.dart';
import 'package:app/models/item_serial_number.dart';

import 'item.dart';

class StockTransferLine {
  int docEntry;
  int lineNum;
  int baseEntry;
  int baseLine;
  String lineStatus;
  String itemCode;
  String codeBars;
  String dscription;
  double quantity;
  DateTime shipDate;
  double openQty;
  double constOpenQty;
  double price;
  String currency;
  double rate;
  double lineTotal;
  String fromWhsCod;
  String whsCode;
  int locCode;
  int visOrder;
  double stock;
  Item item;
  bool selected;

  List<ItemSerialNumber> serials;
  List<ItemBatchNumber> batches;

  StockTransferLine() {
    batches = [];
  }

  StockTransferLine.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      docEntry = jsonMap['DocEntry'];
      lineNum = int.parse(jsonMap['LineNum']);
      lineStatus = jsonMap['LineStatus'];
      itemCode = jsonMap['ItemCode'];
      codeBars = jsonMap['CodeBars'];
      dscription = jsonMap['Dscription'];
      quantity = double.parse(jsonMap['Quantity']);
      shipDate = DateTime.parse(jsonMap['ShipDate']);
      constOpenQty = openQty = double.parse(jsonMap['OpenQty']);
      price = double.parse(jsonMap['Price']);
      currency = jsonMap['Currency'];
      rate = double.parse(jsonMap['Rate']);
      lineTotal = double.parse(jsonMap['LineTotal']);
      fromWhsCod = jsonMap['FromWhsCod'];
      whsCode = jsonMap['WhsCode'];
      visOrder = int.parse(jsonMap['VisOrder']);
      stock = double.parse(jsonMap['Stock'].toString());
      selected = false;
      serials = jsonMap['serials'] != null && (jsonMap['serials'] as List).length > 0
          ? List.from(jsonMap['serials']).map((element) => ItemSerialNumber.fromJSON(element)).toSet().toList()
          : [];
      batches = [];
    } catch (e) {
      docEntry = lineNum = baseEntry = baseLine = 0;
      lineStatus = 'O';
      itemCode = '';
      codeBars = '';
      dscription = '';
      quantity = 1;
      shipDate = DateTime.now();
      constOpenQty = openQty = 1;
      price = 0.0;
      currency = 'MXP';
      rate = 1.0;
      lineTotal = 0.0;
      fromWhsCod = '';
      whsCode = '';
      visOrder = 0;
      stock = 0.0;
      selected = false;
      serials = [];
      batches = [];
      print(jsonMap);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['DocEntry'] = docEntry;
    map['LineNum'] = lineNum;
    map['BaseEntry'] = baseEntry;
    map['BaseLine'] = baseLine;
    map['ItemCode'] = itemCode;
    map['Quantity'] = quantity;
    map['FromWhsCod'] = fromWhsCod;
    map['WhsCode'] = whsCode;
    map['LocCode'] = locCode;
    map['Serials'] = serials?.where((element) => element.selected)?.toList()?.map((element) => element.toMap())?.toList();
    map['Batches'] = batches?.where((element) => element.selected)?.toList()?.map((element) => element.toMap())?.toList();
    return map;
  }
}