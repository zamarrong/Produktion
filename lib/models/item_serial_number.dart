class ItemSerialNumber {
  String itemCode;
  String whsCode;
  String serial;
  int sysSerial;
  bool selected;

  ItemSerialNumber();

  ItemSerialNumber.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      itemCode = jsonMap['ItemCode'];
      whsCode = jsonMap['WhsCode'];
      serial = jsonMap['IntrSerial'];
      sysSerial = int.parse(jsonMap['SysSerial']);
      selected = false;
    } catch (e) {
      itemCode = '';
      whsCode = '';
      serial = '';
      sysSerial = 0;
      selected = false;
      print(jsonMap);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['ItemCode'] = itemCode;
    map['WhsCode'] = whsCode;
    map['SerialNumber'] = serial;
    map['SysSerial'] = sysSerial;
    return map;
  }
}
