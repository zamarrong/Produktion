class ItemGroup {
  int code;
  String name;

  ItemGroup();

  ItemGroup.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      code = int.parse(jsonMap['ItmsGrpCod']);
      name = jsonMap['ItmsGrpNam'];
    } catch (e) {
      code = 0;
      name = '';
      print(jsonMap);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['ItmsGrpCod'] = code;
    map['ItmsGrpNam'] = name;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.code == this.code;
  }

  @override
  int get hashCode => this.code.hashCode;
}
