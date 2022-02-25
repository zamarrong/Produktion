import 'package:app/widgets/MaterialListCardWidget.dart';
import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../widgets/MaterialListCardWidget.dart';
import '../models/material_list.dart';
import '../controllers/material_list_search_controller.dart';

class MaterialListSearchWidget extends StatefulWidget {
  @override
  _MaterialListSearchWidgetState createState() => _MaterialListSearchWidgetState();
}

class _MaterialListSearchWidgetState extends StateMVC<MaterialListSearchWidget> {
  final SearchBarController<MaterialList> _searchBarController = SearchBarController();
  MaterialListSearchController _con;

  _MaterialListSearchWidgetState() : super(MaterialListSearchController()) {
    _con = controller;
  }

  bool isReplay = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SearchBar<MaterialList>(
          searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
          headerPadding: EdgeInsets.symmetric(horizontal: 10),
          listPadding: EdgeInsets.symmetric(horizontal: 10),
          onSearch: _con.getMaterialLists,
          searchBarController: _searchBarController,
          cancellationWidget: Text("Cancelar"),
          emptyWidget: Text("Sin resultados"),
          header: Row(
            children: <Widget>[
              OutlineButton(
                child: Text("Ordenar"),
                onPressed: () {
                  _searchBarController.sortList((MaterialList a, MaterialList b) {
                    return a.name.compareTo(b.name);
                  });
                },
              ),
              OutlineButton(
                child: Text("Desordenar"),
                onPressed: () {
                  _searchBarController.removeSort();
                },
              ),
            ],
          ),
          onCancelled: () {
            //
          },
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          crossAxisCount: 1,
          onItemFound: (MaterialList materialList, int index) {
            return MaterialListCardWidget(materialList: materialList);
          },
        ),
      ),
    );
  }
}