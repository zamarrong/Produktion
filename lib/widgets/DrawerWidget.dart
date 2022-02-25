import 'package:app/helpers/helper.dart';
import 'package:app/pages/business_partners.dart';
import 'package:app/pages/inventory_transfer_requests.dart';
import 'package:app/pages/items.dart';
import 'package:app/pages/material_lists.dart';
import 'package:app/pages/production_orders.dart';
import 'package:app/pages/users.dart';
import 'package:app/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: Image.asset(
              "assets/img/logo.png",
            ),
            accountName: Text(
                '${Helper.authUser.name}',
                style: TextStyle(color: Colors.blue),
            ),
            accountEmail: Text(
              '${Helper.authUser.email}',
              style: TextStyle(color: Colors.blue),
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
          ),
          ListTile(
            trailing: Icon(Icons.home),
            title: Text('Inicio'),
            onTap: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
          Divider(),
          ListTile(
            trailing: Icon(Icons.chevron_right),
            title: Text('Artículos'),
            onTap: () {
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => new ItemsPage())
              );
            },
          ),
          Divider(),
          ListTile(
            trailing: Icon(Icons.chevron_right),
            title: Text('Solicitudes de traslado'),
            onTap: () {
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => new InventoryTransferRequetsPage())
              );
            },
          ),
          Divider(),
          Visibility(
            visible: Helper.authUser.materialList,
            child: ListTile(
              trailing: Icon(Icons.chevron_right),
              title: Text('Listas de materiales'),
              onTap: () {
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context) => new MaterialListsPage())
                );
              })
          ),
          Divider(),
          ListTile(
            trailing: Icon(Icons.chevron_right),
            title: Text('Ordenes de producción'),
            onTap: () {
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => new ProductionOrdersPage())
              );
            },
          ),
          Divider(),
          ListTile(
            trailing: Icon(Icons.people),
            title: Text('Usuarios'),
            onTap: () {
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => new UsersPage())
              );
            },
          ),
          Divider(),
          ListTile(
            trailing: Icon(Icons.logout),
            title: Text('Cerrar sesión'),
            onTap: () {
              AuthProvider().logout();
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
          ),
        ],
      ),
    );
  }
}