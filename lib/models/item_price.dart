class ItemPrice {
  String itemCode;
  int priceList;
  String currency;
  double price;

  ItemPrice();

  ItemPrice.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      itemCode = jsonMap['ItemCode'];
      priceList = int.parse(jsonMap['PriceList']);
      currency = jsonMap['Currency'];
      price = double.parse(jsonMap['Price']);
    } catch (e) {
      itemCode = '';
      priceList = 0;
      currency = '';
      price = 0.0;
      print(jsonMap);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['ItemCode'] = itemCode;
    map['PriceList'] = priceList;
    map['Currency'] = currency;
    map['Price'] = price;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.ItemCode == this.itemCode;
  }

  @override
  int get hashCode => this.itemCode.hashCode;
}
