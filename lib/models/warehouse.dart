import 'package:app/models/location.dart';

class Warehouse {
  String code;
  String name;
  List<Location> locations;

  Warehouse();

  Warehouse.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      code = jsonMap['WhsCode'];
      name = jsonMap['WhsName'];
      locations = jsonMap['locations'] != null && (jsonMap['locations'] as List).length > 0
          ? List.from(jsonMap['locations']).map((element) => Location.fromJSON(element)).toSet().toList()
          : [];
    } catch (e) {
      code = '';
      name = '';
      locations = [];
      print(jsonMap);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['WhsCode'] = code;
    map['WhsName'] = name;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.code == this.code;
  }

  @override
  int get hashCode => this.code.hashCode;
}
