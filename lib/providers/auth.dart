import 'dart:convert';

import 'package:app/helpers/helper.dart';
import 'package:app/models/user.dart';
import 'package:app/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:device_info/device_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String email, String password) async {
    final response = await http.post(Helper.getUri('api/token'), body: {
      'email': email,
      'password': password,
      'device_name': await getDeviceId(),
    }, headers: {
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      String token = response.body;
      await saveToken(token);
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }

    if (response.statusCode == 422) {
      return false;
    }

    return false;
  }

  getDeviceId() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        return build.androidId;
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        return data.identifierForVendor;
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
  }

  saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      final Stream<User> stream = await authUser();
      stream.listen((User _user) async {
        String jsonUser = json.encode(_user.toMap());
        Helper.authUser = _user;
        await prefs.setString('user', jsonUser);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  logout() async {
    _isAuthenticated = false;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}