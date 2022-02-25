import 'package:mvc_pattern/mvc_pattern.dart';

import '../models/item.dart';
import '../repository/item_repository.dart';
import '../repository/search_repository.dart';

class SearchController extends ControllerMVC {
  List<Item> items = <Item>[];

  SearchController() {
    listenForItems();
  }

  String resultsCount(){
    return items.length.toString() + " Resultado" + ((items.length != 1) ? "s" : "");
  }

  void listenForItems({String search}) async {
    items = <Item>[];
    if (search == null) {
      search = await getRecentSearch();
    }
    if (search.length > 0) {
      final Stream<Item> stream = await searchItems(search);
      stream.listen((Item _item) {
        setState(() => items.add(_item));
      }, onError: (a) {
        print(a);
      }, onDone: () {});
    }
  }

  Future<List<Item>> getItems(String search) async {
    items = <Item>[];
    if (search == null) {
      search = await getRecentSearch();
    }
    if (search.length > 0) {
      final Stream<Item> stream = await searchItems(search);
      await for(Item _item in stream) {
        items.add(_item);
      }
      saveSearch(search);
      return items;
    }

    return items;
  }

  Future<void> refreshSearch(search) async {
    setState(() {
      items = <Item>[];
    });
    listenForItems(search: search);
  }

  void saveSearch(String search) {
    setRecentSearch(search);
  }
}
