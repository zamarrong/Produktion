import 'package:app/models/item_group.dart';
import 'package:app/models/item_inventory.dart';
import 'package:app/models/item_price.dart';
import 'package:app/models/manufacturer.dart';

class Item {
  String code;
  String name;
  String frgnName;
  String codeBars;
  int groupCode;
  int firmCode;
  String salUnitMsr;
  double stock;
  String picture;
  ItemGroup group;
  Manufacturer manufacturer;
  ItemPrice price;
  bool manageBatch;
  bool manageSerial;
  bool inventoriable;
  bool sellable;
  bool purchasable;
  List<ItemInventory> inventory;

  Item();

  Item.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      code = jsonMap['ItemCode'];
      name = jsonMap['ItemName'];
      frgnName = jsonMap['FrgnName'] ?? '';
      codeBars = jsonMap['CodeBars'] ?? '';
      groupCode = int.parse(jsonMap['ItmsGrpCod']);
      firmCode = int.parse(jsonMap['FirmCode']);
      salUnitMsr = jsonMap['SalUnitMsr'];
      stock = double.parse(jsonMap['OnHand']);
      picture = jsonMap['PicturName'] ?? '';
      group = jsonMap['group'] != null ? ItemGroup.fromJSON(jsonMap['group']) : new ItemGroup();
      manufacturer = jsonMap['manufacturer'] != null ? Manufacturer.fromJSON(jsonMap['manufacturer']) : new ItemGroup();
      price = jsonMap['price'] != null ? ItemPrice.fromJSON(jsonMap['price']) : new ItemPrice();
      manageBatch = jsonMap['ManBtchNum'] == 'Y' ? true : false;
      manageSerial = jsonMap['ManSerNum'] == 'Y' ? true : false;
      inventoriable = jsonMap['InvntItem'] == 'Y' ? true : false;
      sellable = jsonMap['SellItem'] == 'Y' ? true : false;
      purchasable = jsonMap['PrchseItem'] == 'Y' ? true : false;
      inventory = jsonMap['inventory'] != null && (jsonMap['inventory'] as List).length > 0
          ? List.from(jsonMap['inventory']).map((element) => ItemInventory.fromJSON(element)).toSet().toList()
          : [];
    } catch (e) {
      code = '';
      name = '';
      frgnName = '';
      codeBars = '';
      groupCode = 0;
      salUnitMsr = '';
      stock = 0.0;
      picture = '';
      group = new ItemGroup();
      manufacturer = new Manufacturer();
      price = new ItemPrice();
      inventoriable = sellable = purchasable = true;
      inventory = [];
      print(jsonMap);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['ItemCode'] = code;
    map['ItemName'] = name;
    map['CodeBars'] = codeBars;
    map['ItmsGrpCod'] = groupCode;
    map['OnHand'] = stock;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.code == this.code;
  }

  @override
  int get hashCode => this.code.hashCode;
}
