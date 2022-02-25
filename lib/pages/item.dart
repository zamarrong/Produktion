import 'package:flutter/material.dart';
import 'package:app/models/item.dart';
import 'package:flutter/rendering.dart';
import 'package:app/helpers/helper.dart';

class ItemPage extends StatelessWidget {
  final Item item;
  ItemPage({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Container(
                  width: 150,
                  height: 150,
                  child: ClipOval(
                    child: FadeInImage(
                      //image: NetworkImage(Helper.getUri('img/items/' + item.picture).toString()),
                      image: AssetImage('assets/img/logo.png'),
                      placeholder: AssetImage('assets/img/logo.png')
                    ),
                  ),
                ),
              ),
              Text(
                item.code,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
              ),
              Text(
                item.name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              Text(
                  item.codeBars
              ),
              Text(
                '${item.group.name} | ${item.manufacturer.name}'
              ),
              Text(
                '${item.price.currency} ${item.price.price.toStringAsFixed(4)}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              Text(
                'Stock: ${item.stock.toStringAsFixed(4)}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'UdM: ${item.salUnitMsr}',
                style: TextStyle(color: Colors.black54),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: <DataColumn>[
                        DataColumn(
                          label: Text(
                            'Almacén',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'En Stock',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Comprometido',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Pedido',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                      rows: item.inventory.map(
                        ((_inventory) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(_inventory.whsCode, style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(_inventory.onHand.toStringAsFixed(4), style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(_inventory.isCommited.toStringAsFixed(4), style: TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(_inventory.onOrder.toStringAsFixed(4), style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                        )),
                      ).toList()
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}