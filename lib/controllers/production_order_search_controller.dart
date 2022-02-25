import 'package:app/helpers/helper.dart';
import 'package:app/repository/production_order_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../models/production_order.dart';
import '../repository/search_repository.dart';

class ProductionOrderSearchController extends ControllerMVC {
  List<ProductionOrder> documents = <ProductionOrder>[];

  ProductionOrderSearchController() {
    listenForProductionOrders();
  }

  String resultsCount(){
    return documents.length.toString() + " Resultado" + ((documents.length != 1) ? "s" : "");
  }

  void listenForProductionOrders({String search}) async {
    documents = <ProductionOrder>[];
    String token = await Helper.getToken();

    final Stream<ProductionOrder> stream = await searchDocuments(search, token, byStatus: true);
      stream.listen((ProductionOrder _document) {
        setState(() => documents.add(_document));
      });
  }

  Future<List<ProductionOrder>> getProductionOrders(String search) async {
    if (search == null) {
      search = await getRecentSearch();
    }

    if (search.length > 0) {
      if (!isNumeric(search)) {
        return documents;
      }
      saveSearch(search);
      return documents.where((element) => element.docNum == int.parse(search)).toList();
    }

    return documents;
  }


  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  Future<void> refreshSearch(search) async {
    setState(() {
      documents = <ProductionOrder>[];
    });
    listenForProductionOrders(search: search);
  }

  void saveSearch(String search) {
    setRecentSearch(search);
  }
}