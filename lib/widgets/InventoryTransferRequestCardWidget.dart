import 'package:app/models/inventory_transfer_request.dart';
import 'package:app/pages/inventory_transfer_request.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InventoryTransferRequestCardWidget extends StatelessWidget {
  final InventoryTransferRequest document;
  const InventoryTransferRequestCardWidget({Key key, this.document}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => InventoryTransferRequestPage(docEntry: document.docEntry)));
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
                backgroundColor: document.docStatus == 'O' ? Colors.green : Colors.redAccent,
              ),
              title: Text(
                  DateFormat('dd-MM-yyyy').format(document.docDate),
              ),
              subtitle: Text('Origen: ' + document.whsCode + ' | Destino: ' + document.toWhsCode + '\n' + document.comments),
              isThreeLine: true,
              trailing: IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => InventoryTransferRequestPage(docEntry: document.docEntry)));
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