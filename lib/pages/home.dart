import 'package:app/widgets/DrawerWidget.dart';
import 'package:app/widgets/SearchWidget.dart';
import 'package:flutter/material.dart';
import '../widgets/SearchWidget.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../pages/item.dart';
import '../models/item.dart';
import '../repository/item_repository.dart';

class MyHome extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyHome> {
  static const String _title = 'Produktion';

  Future<void> scanner(BuildContext context) async {
    String barcode = await FlutterBarcodeScanner.scanBarcode("#db322a", "Cancelar", true, ScanMode.BARCODE);
    final Stream<Item> stream = await searchItems(barcode);
    List<Item> items = [];
    await for(Item _item in stream) {
      items.add(_item);
    }
    if (items.length > 0) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ItemPage(item: items.first)));
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('No se encontraron resultados')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(_title),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.camera,
                color: Colors.white,
              ),
              onPressed: () {
                scanner(context);
              },
            )
          ],
        ),
        body: Home(),
        drawer: DrawerWidget(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SearchWidget(),
      ),
    );
  }
}