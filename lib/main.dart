import 'package:app/pages/home.dart';
import 'package:app/pages/login.dart';
import 'package:app/pages/production_orders.dart';
import 'package:app/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/helper.dart';
import 'models/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("configurations");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var user = await Helper.getAuthUser();
  runApp(
      ChangeNotifierProvider(
        create: (BuildContext context) => AuthProvider(),
        child: MyApp(user)
      )
  );
}

class MyApp extends StatelessWidget {
  User user;

  MyApp(User user) {
    this.user = user;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Produktion',
      debugShowCheckedModeBanner: false,
      home: (user != null) ? Auth() : CheckAuth(),
    );
  }
}

class CheckAuth extends StatefulWidget {

  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Consumer<AuthProvider>(
            builder: (context, auth, child) {
              switch (auth.isAuthenticated) {
                case true:
                  return Helper.authUser.admin ? MyHome() : ProductionOrdersPage();
                default:
                  return Login();
              }
            },
          )
      ),
    );
  }
}

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Consumer<AuthProvider>(
            builder: (context, auth, child) {
                return Helper.authUser.admin ? MyHome() : ProductionOrdersPage();
              }
          ),
      ),
    );
  }
}