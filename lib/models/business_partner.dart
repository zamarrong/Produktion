class BusinessPartner {
  String code;
  String name;
  String cardType;
  int groupCode;
  String licTradNum;
  double creditLine;
  double balance;
  int listNum;
  String currency;
  int slpCode;
  String phone;
  String phone2;
  String cellular;
  String email;

  BusinessPartner();

  BusinessPartner.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      code = jsonMap['CardCode'];
      name = jsonMap['CardName'];
      cardType = jsonMap['CardType'];
      groupCode = int.parse(jsonMap['GroupCode']);
      licTradNum = jsonMap['LicTradNum'];
      creditLine = double.parse(jsonMap['CreditLine']);
      balance = double.parse(jsonMap['Balance']);
      listNum = int.parse(jsonMap['ListNum']);
      currency = jsonMap['Currency'];
      slpCode = int.parse(jsonMap['SlpCode']);
      phone = jsonMap['Phone'] ?? '';
      phone2 = jsonMap['Phone2'] ?? '';
      cellular = jsonMap['Cellular'] ?? '';
      email = jsonMap['E_Mail'] ?? '';
    } catch (e) {
      code = '';
      name = '';
      cardType = 'C';
      groupCode = 100;
      licTradNum = 'XAXX010101000';
      creditLine = 0.0;
      balance = 0.0;
      listNum = 1;
      currency = 'MXP';
      slpCode = -1;
      phone = '';
      phone2 = '';
      cellular = '';
      email = '';
      print(jsonMap);
    }
  }

  @override
  bool operator ==(dynamic other) {
    return other.code == this.code;
  }

  @override
  int get hashCode => this.code.hashCode;
}
