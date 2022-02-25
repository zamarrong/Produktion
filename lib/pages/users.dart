import 'package:app/controllers/user_controller.dart';
import 'package:app/pages/user.dart';
import 'package:app/widgets/UserCardWidget.dart';
import 'package:app/widgets/CircularLoadingWidget.dart';
import 'package:app/widgets/DrawerWidget.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class UsersPage extends StatefulWidget {
  UsersPage({Key key}) : super(key: key);

  @override
  _UsersPage createState() => _UsersPage();
}

class _UsersPage extends StateMVC<UsersPage> {
  UserController _con;

  _UsersPage() : super(UserController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        title: Text("Usuarios"),
        centerTitle: true,
      ),
      drawer: DrawerWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => UserPage(id: 0)));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      body: RefreshIndicator(
        onRefresh: _con.refreshUsers,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _con.users.isEmpty ? CircularLoadingWidget(height: 500) :
              ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemCount: _con.users.length,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10);
                },
                itemBuilder: (context, index) {
                  return UserCardWidget(
                    user: _con.users.elementAt(index),
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
