import 'package:app/models/item.dart';
import 'package:app/models/material_list_line.dart';

class MaterialList {
  String code;
  String name;
  String warehouse;
  int priceList;
  double quantity;
  double plannedAvgQuantity;
  Item item;
  List<MaterialListLine> lines;

  MaterialList();

  MaterialList.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      code = jsonMap['Code'];
      name = jsonMap['Name'];
      warehouse = jsonMap['ToWH'];
      priceList = int.parse(jsonMap['PriceList']);
      quantity = double.parse(jsonMap['Qauntity']);
      plannedAvgQuantity = double.parse(jsonMap['PlAvgSize']);
      item = jsonMap['item'] != null ? Item.fromJSON(jsonMap['item']) : new Item();
      lines = jsonMap['lines'] != null && (jsonMap['lines'] as List).length > 0
          ? List.from(jsonMap['lines']).map((element) => MaterialListLine.fromJSON(element)).toSet().toList()
          : [];
    } catch (e) {
      code = '';
      name = '';
      warehouse = '';
      priceList = 1;
      quantity = 1.0;
      plannedAvgQuantity = 1.0;
      item = new Item();
      lines = [];
      print(jsonMap);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['ItemCode'] = code;
    map['ItemName'] = name;
    return map;
  }

  @override
  bool operator == (dynamic other) {
    return other.code == this.code;
  }

  @override
  int get hashCode => this.code.hashCode;
}