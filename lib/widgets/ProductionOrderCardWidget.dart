import 'package:app/models/production_order.dart';
import 'package:app/pages/production_order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductionOrderCardWidget extends StatelessWidget {
  final ProductionOrder document;
  const ProductionOrderCardWidget({Key key, this.document}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProductionOrderPage(docEntry: document.docEntry)));
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                radius: 30.0,
                child: Text(
                  document.docNum.toString(),
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                backgroundColor: document.status == 'P' ? Colors.blue : Colors.green,
              ),
              title: Text(
                  '${document.docNum.toString()} (${document.getStatus()})',
              ),
              subtitle: Text('Fecha: ${DateFormat('dd-MM-yyyy').format(document.startDate)}\nAlmacén: ${document.warehouse}\nProducto: ${document.itemCode} - ${document.prodName}\nComentario: ${document.comments}'),
              isThreeLine: true,
              trailing: IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProductionOrderPage(docEntry: document.docEntry)));
                },
                color: Colors.blue,
                icon: Icon(Icons.chevron_right),
              ),
            ),
          ],
        ),
      ),
    );
  }
}