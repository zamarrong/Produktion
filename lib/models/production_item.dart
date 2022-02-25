import 'package:app/models/item_batch_number.dart';

import 'item.dart';

class ProductionItem {
  int lineNum;
  int docEntry;
  int baseLine;
  String itemCode;
  String prodName;
  String warehouse;
  int locCode;
  double plannedQty;
  double completedQty;
  double quantity;
  String batchNum;
  double stock;
  Item item;
  bool selected;
  List<ItemBatchNumber> batches;

  ProductionItem() {
    batchNum = '';
    batches = [];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['DocEntry'] = docEntry;
    map['BaseLine'] = baseLine;
    map['ItemCode'] = itemCode;
    map['Warehouse'] = warehouse;
    map['LocCode'] = locCode;
    map['Quantity'] = quantity;
    map['BatchNumber'] = batchNum;
    map['Batches'] = batches?.where((element) => element.selected)?.toList()?.map((element) => element.toMap())?.toList();
    return map;
  }
}