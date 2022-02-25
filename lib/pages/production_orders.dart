import 'package:app/controllers/production_order_controller.dart';
import 'package:app/widgets/InventoryTransferRequestCardWidget.dart';
import 'package:app/widgets/CircularLoadingWidget.dart';
import 'package:app/widgets/DrawerWidget.dart';
import 'package:app/widgets/ProductionOrderCardWidget.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';


class ProductionOrdersPage extends StatefulWidget {
  ProductionOrdersPage({Key key}) : super(key: key);

  @override
  _ProductionOrdersPageState createState() => _ProductionOrdersPageState();
}

class _ProductionOrdersPageState extends StateMVC<ProductionOrdersPage> {
  ProductionOrderController _con;

  _ProductionOrdersPageState() : super(ProductionOrderController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForDocuments(status: 'R');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        title: Text("Órdenes de producción"),
        centerTitle: true,
      ),
      drawer: DrawerWidget(),
      body: RefreshIndicator(
        onRefresh: _con.refreshDocuments,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _con.documents.isEmpty ? CircularLoadingWidget(height: 500) :
              ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemCount: _con.documents.length,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10);
                },
                itemBuilder: (context, index) {
                  return ProductionOrderCardWidget(
                    document: _con.documents.elementAt(index),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
