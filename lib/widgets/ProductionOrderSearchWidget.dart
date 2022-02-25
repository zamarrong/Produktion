import 'package:app/controllers/production_order_search_controller.dart';
import 'package:app/widgets/ProductionOrderCardWidget.dart';
import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../widgets/ProductionOrderCardWidget.dart';
import '../models/production_order.dart';

class ProductionOrderSearchWidget extends StatefulWidget {
  @override
  _ProductionOrderSearchWidgetState createState() => _ProductionOrderSearchWidgetState();
}

class _ProductionOrderSearchWidgetState extends StateMVC<ProductionOrderSearchWidget> {
  final SearchBarController<ProductionOrder> _searchBarController = SearchBarController();
  ProductionOrderSearchController _con;

  _ProductionOrderSearchWidgetState() : super(ProductionOrderSearchController()) {
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
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SearchBar<ProductionOrder>(
          searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
          headerPadding: EdgeInsets.symmetric(horizontal: 10),
          listPadding: EdgeInsets.symmetric(horizontal: 10),
          onSearch: _con.getProductionOrders,
          searchBarController: _searchBarController,
          cancellationWidget: Text("Cancelar"),
          emptyWidget: Text("Sin resultados"),
          header: Row(
            children: <Widget>[
              OutlineButton(
                child: Text("Ordenar"),
                onPressed: () {
                  _searchBarController.sortList((ProductionOrder a, ProductionOrder b) {
                    return a.ordersNumber.compareTo(b.ordersNumber);
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
          onItemFound: (ProductionOrder document, int index) {
            return ProductionOrderCardWidget(document: document);
          },
        ),
      ),
    );
  }
}