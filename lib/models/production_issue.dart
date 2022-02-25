import 'package:app/models/production_item.dart';

class ProductionIssue {
  DateTime date;
  int locCode;
  List<ProductionItem> lines;

  ProductionIssue() {
    lines = [];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['Date'] = date.toIso8601String();
    map['LocCode'] = locCode;
    map['Lines'] = lines?.where((element) => element.selected)?.map((element) => element.toMap())?.toList();
    return map;
  }
}
