import 'package:app/models/item_serial_number.dart';

class InventoryTransferRequestLine {
  int docEntry;
  int lineNum;
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
  int visOrder;
  double stock;
  bool selected;

  List<ItemSerialNumber> serials;

  InventoryTransferRequestLine();

  InventoryTransferRequestLine.fromJSON(Map<String, dynamic> jsonMap) {
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
    } catch (e) {
      docEntry = 0;
      lineNum = 0;
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
      print(jsonMap);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['DocEntry'] = docEntry;
    map['LineNum'] = lineNum;
    map['ItemCode'] = itemCode;
    map['Quantity'] = quantity;
    map['FromWhsCod'] = fromWhsCod;
    map['WhsCode'] = whsCode;
    map['Serials'] = serials?.where((element) => element.selected)?.toList()?.map((element) => element.toMap())?.toList();
    return map;
  }
}