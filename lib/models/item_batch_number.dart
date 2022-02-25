class ItemBatchNumber {
  String itemCode;
  int sysBatch;
  String batchNum;
  String whsCode;
  double whsQuantity;
  int sysBin;
  String binCode;
  double binQuantity;
  double quantity;
  bool selected;

  ItemBatchNumber();

  ItemBatchNumber.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      itemCode = jsonMap['ItemCode'];
      sysBatch = int.parse(jsonMap['SysNumber']);
      batchNum = jsonMap['BatchNum'];
      whsCode = jsonMap['WhsCode'];
      whsQuantity = double.parse(jsonMap['Quantity']);
      sysBin = int.parse(jsonMap['SysBin'] ?? '0');
      binCode = jsonMap['BinCode'] ?? '';
      binQuantity = double.parse(jsonMap['OnHandQty'] ?? '0');
      quantity = 0;
      selected = false;
    } catch (e) {
      itemCode = '';
      sysBatch = 0;
      batchNum = '';
      whsCode = '';
      whsQuantity = 0;
      sysBin = 0;
      binCode = '';
      binQuantity = 0;
      quantity = 0;
      selected = false;
      print(jsonMap);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['ItemCode'] = itemCode;
    map['WhsCode'] = whsCode;
    map['SysBin'] = sysBin;
    map['BinCode'] = binCode;
    map['BatchNumber'] = batchNum;
    map['SysBatch'] = sysBatch;
    map['Quantity'] = quantity;
    return map;
  }
}
