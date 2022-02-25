import 'package:app/models/user.dart';
import 'package:app/pages/user.dart';
import 'package:flutter/material.dart';

class UserCardWidget extends StatelessWidget {
  final User user;
  const UserCardWidget({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              radius: 30.0,
              child: Text(
                user.name.substring(0, 1),
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
              backgroundColor: user.admin ? Colors.green : Colors.blue,
            ),
            title: Text(user.name),
            subtitle: Text(user.email),
            trailing: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserPage(id: user.id)));
              },
              color: Colors.blue,
              icon: Icon(Icons.chevron_right),
            ),
          ),
        ],
      ),
    );
  }
}