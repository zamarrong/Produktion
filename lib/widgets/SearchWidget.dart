import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../widgets/ItemCardWidget.dart';
import '../models/item.dart';
import '../controllers/search_controller.dart';

class SearchWidget extends StatefulWidget {
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends StateMVC<SearchWidget> {
  final SearchBarController<Item> _searchBarController = SearchBarController();
  SearchController _con;

  _SearchWidgetState() : super(SearchController()) {
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
        child: SearchBar<Item>(
          searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
          headerPadding: EdgeInsets.symmetric(horizontal: 10),
          listPadding: EdgeInsets.symmetric(horizontal: 10),
          onSearch: _con.getItems,
          searchBarController: _searchBarController,
          cancellationWidget: Text("Cancelar"),
          emptyWidget: Text("Sin resultados"),
          header: Row(
            children: <Widget>[
              OutlineButton(
                child: Text("Ordenar"),
                onPressed: () {
                  _searchBarController.sortList((Item a, Item b) {
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
          onItemFound: (Item item, int index) {
            return ItemCardWidget(item: item);
          },
        ),
      ),
    );
  }
}