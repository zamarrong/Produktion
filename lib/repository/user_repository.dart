import 'dart:convert';

import 'package:app/models/user.dart';
import 'package:http/http.dart' as http;
import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';

Future<Stream<User>> getUsers() async {
  Uri uri = Helper.getUri('api/users');
  String token = await Helper.getToken();
  try {
    final client = new http.Client();
    final request = new http.Request('get', uri);
    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });
    final streamedRest = await client.send(request);
    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).expand((data) => (data as List)).map((data) {
      return User.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new User.fromJSON({}));
  }
}
Future<Stream<User>> authUser() async {
  Uri uri = Helper.getUri('api/user');
  String token = await Helper.getToken();

  try {
    final client = new http.Client();
    final request = new http.Request('get', uri);
    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });
    final streamedRest = await client.send(request);
    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) {
      return User.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new User.fromJSON({}));
  }
}

Future<Stream<User>> getUser(int id) async {
  Uri uri = Helper.getUri('api/users/$id');
  String token = await Helper.getToken();

  try {
    final client = new http.Client();
    final request = new http.Request('get', uri);
    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });
    final streamedRest = await client.send(request);
    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) {
      return User.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new User.fromJSON({}));
  }
}

Future<http.Response> addOrUpdateUser(User user) async {
  Uri uri = Helper.getUri((user.id == 0) ? 'api/users' : 'api/users/${user.id}');
  String token = await Helper.getToken();

  final client = new http.Client();
  Map params = user.toMap();
  final response = await ((user.id == 0) ? client.post(
    uri,
    headers: {
      'content-type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode(params),
  ) : client.patch(
    uri,
    headers: {
    'content-type': 'application/json',
    'Authorization': 'Bearer $token',
    },
    body: json.encode(params),
  ));

  return response;
}