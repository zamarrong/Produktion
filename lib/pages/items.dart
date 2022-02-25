import 'package:app/widgets/DrawerWidget.dart';
import 'package:app/widgets/SearchWidget.dart';
import 'package:flutter/material.dart';

class ItemsPage extends StatelessWidget {

  static const String routeName = '/items';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Artículos"),
        ),
        drawer: DrawerWidget(),
        body: SafeArea(
          child: SearchWidget(),
        ),
    );
  }
}