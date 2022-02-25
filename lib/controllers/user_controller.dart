import 'package:app/models/user.dart';
import 'package:app/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class UserController extends ControllerMVC {
  List<User> users = <User>[];
  User user;
  bool loading = false;
  GlobalKey<ScaffoldState> scaffoldKey;

  UserController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForUsers({String message}) async {
    users.clear();
    final Stream<User> stream = await getUsers();
    stream.listen((User _user) {
      setState(() {
        users.add(_user);
      });
    }, onError: (a) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Verifica tu conexión a internet"),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForUser({int id, String message}) async {
    loading = true;
    user = new User();
    if (id != 0) {
      final Stream<User> stream = await getUser(id);
      stream.listen((User _user) {
        setState(() {
          user = _user;
        });
      }, onError: (a) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Verifica tu conexión a internet"),
        ));
      }, onDone: () {
        if (message != null) {
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(message),
          ));
        }
      });
    }
    loading = false;
  }

  Future<void> refreshUsers() async {
    listenForUsers(message: 'Se actualizó la lista correctamente');
  }

  Future<void> refreshUser() async {
    if (user != null) {
      listenForUser(id: user.id, message: 'Se actualizó el usuario correctamente');
    }
  }
}