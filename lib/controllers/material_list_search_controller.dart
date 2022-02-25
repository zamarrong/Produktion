import 'package:mvc_pattern/mvc_pattern.dart';

import '../models/material_list.dart';
import '../repository/material_list_repository.dart';
import '../repository/search_repository.dart';

class MaterialListSearchController extends ControllerMVC {
  List<MaterialList> materialLists = <MaterialList>[];

  MaterialListSearchController() {
    listenForMaterialLists();
  }

  String resultsCount(){
    return materialLists.length.toString() + " Resultado" + ((materialLists.length != 1) ? "s" : "");
  }

  void listenForMaterialLists({String search}) async {
    materialLists = <MaterialList>[];
    if (search == null) {
      search = await getRecentSearch();
    }
    if (search.length > 0) {
      final Stream<MaterialList> stream = await searchItems(search);
      stream.listen((MaterialList _item) {
        setState(() => materialLists.add(_item));
      }, onError: (a) {
        print(a);
      }, onDone: () {});
    }
  }

  Future<List<MaterialList>> getMaterialLists(String search) async {
    materialLists = <MaterialList>[];
    if (search == null) {
      search = await getRecentSearch();
    }
    if (search.length > 0) {
      final Stream<MaterialList> stream = await searchItems(search);
      await for(MaterialList _item in stream) {
        materialLists.add(_item);
      }
      saveSearch(search);
      return materialLists;
    }

    return materialLists;
  }

  Future<void> refreshSearch(search) async {
    setState(() {
      materialLists = <MaterialList>[];
    });
    listenForMaterialLists(search: search);
  }

  void saveSearch(String search) {
    setRecentSearch(search);
  }
}
