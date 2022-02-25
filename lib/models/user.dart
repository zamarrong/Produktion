class User {
  int id;
  String name;
  String email;
  String password;
  bool admin;
  bool terminationReport;
  bool genEntry;
  bool genExit;
  bool stockTransfer;
  bool stockTransferRequest;
  bool materialList;

  User() {
    id = 0;
    name = email = password = '';
    admin = terminationReport = genEntry = genExit = stockTransfer = stockTransferRequest = false;
  }

  User.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'];
      name = jsonMap['name'];
      email = jsonMap['email'];
      admin = jsonMap['admin'].toString() == '1';
      terminationReport = jsonMap['termination_report'].toString() == '1';
      genEntry = jsonMap['gen_entry'].toString() == '1';
      genExit = jsonMap['gen_exit'].toString() == '1';
      stockTransfer = jsonMap['stock_transfer'].toString() == '1';
      stockTransferRequest = jsonMap['stock_transfer_request'].toString() == '1';
      materialList = jsonMap['material_list'].toString() == '1';
    } catch (e) {
      id = 0;
      name = email = password = '';
      admin = terminationReport = genEntry = genExit = stockTransfer = stockTransferRequest = false;
      print('Error: ${e} ${jsonMap}');
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['password'] = password;
    map['admin'] = admin;
    map['termination_report'] = terminationReport;
    map['gen_entry'] = genEntry;
    map['gen_exit'] = genExit;
    map['stock_transfer'] = stockTransfer;
    map['stock_transfer_request'] = stockTransferRequest;
    map['material_list'] = materialList;
    return map;
  }

  @override
  bool operator == (dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}