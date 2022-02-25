class ItemInventory {
  String itemCode;
  String whsCode;
  double onHand;
  double isCommited;
  double onOrder;
  double consig;
  double minStock;
  double maxStock;
  double minOrder;

  ItemInventory();

  ItemInventory.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      itemCode = jsonMap['ItemCode'];
      whsCode = jsonMap['WhsCode'];
      onHand = double.parse(jsonMap['OnHand']) ?? 0.0;
      isCommited = double.parse(jsonMap['IsCommited']) ?? 0.0;
      onOrder = double.parse(jsonMap['OnOrder']) ?? 0.0;
      consig = double.parse(jsonMap['Consig']) ?? 0.0;
      minStock = double.parse(jsonMap['MinStock']) ?? 0.0;
      maxStock = double.parse(jsonMap['MaxStock']) ?? 0.0;
      minOrder = double.parse(jsonMap['MinOrder']) ?? 0.0;
    } catch (e) {
      itemCode = '';
      whsCode = '';
      onHand = 0.0;
      isCommited = 0.0;
      onOrder = 0.0;
      consig = 0.0;
      minStock = 0.0;
      maxStock = 0.0;
      minOrder = 0.0;
      print(jsonMap);
    }
  }
}
