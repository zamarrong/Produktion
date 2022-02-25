import 'package:app/models/sequence.dart';

class MaterialListLine {
  String father;
  String code;
  String name;
  String warehouse;
  int priceList;
  double quantity;
  Sequence sequence;

  MaterialListLine();

  MaterialListLine.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      father = jsonMap['Father'];
      code = jsonMap['Code'];
      name = jsonMap['Name'];
      warehouse = jsonMap['Warehouse'];
      priceList = jsonMap['PriceList'] != null ? int.parse(jsonMap['PriceList']) : 1;
      quantity = double.parse(jsonMap['Quantity']);
      sequence = jsonMap['sequence'] != null ? Sequence.fromJSON(jsonMap['sequence']) : new Sequence();
    } catch (e) {
      father = '';
      code = '';
      name = '';
      warehouse = '';
      priceList = 1;
      quantity = 1.0;
      sequence = new Sequence();
      print(jsonMap);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['ItemCode'] = code;
    map['ItemName'] = name;
    return map;
  }
}