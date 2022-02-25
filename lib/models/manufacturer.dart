class Manufacturer {
  int code;
  String name;

  Manufacturer();

  Manufacturer.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      code = jsonMap['FirmCode'];
      name = jsonMap['FirmName'];
    } catch (e) {
      code = -1;
      name = '';
      print(jsonMap);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['FirmCode'] = code;
    map['FirmName'] = name;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.code == this.code;
  }

  @override
  int get hashCode => this.code.hashCode;
}
