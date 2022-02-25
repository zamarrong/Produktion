class Location {
  int absEntry;
  String binCode;
  String whsCode;
  String sysBin;

  Location();

  Location.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      absEntry = jsonMap['AbsEntry'];
      binCode = jsonMap['BinCode'];
      whsCode = jsonMap['WhsCode'];
      sysBin = jsonMap['SysBin'];
    } catch (e) {
      absEntry = 0;
      binCode = whsCode = sysBin = '';
      print(jsonMap);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['AbsEntry'] = absEntry;
    map['BinCode'] = binCode;
    map['WhsCode'] = whsCode;
    map['SysBin'] = sysBin;
    return map;
  }

  @override
  bool operator == (dynamic other) {
    return other.absEntry == this.absEntry;
  }

  @override
  int get hashCode => this.absEntry.hashCode;
}
