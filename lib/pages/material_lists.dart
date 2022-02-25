import 'package:app/widgets/DrawerWidget.dart';
import 'package:app/widgets/MaterialListSearchWidget.dart';
import 'package:flutter/material.dart';

class MaterialListsPage extends StatelessWidget {

  static const String routeName = '/material-lists';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Listas de materiales"),
      ),
      drawer: DrawerWidget(),
      body: SafeArea(
        child: MaterialListSearchWidget(),
      ),
    );
  }
}