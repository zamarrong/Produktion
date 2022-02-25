import 'dart:convert';

import 'package:http/http.dart' as http;
import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/material_list.dart';

Future<Stream<MaterialList>> searchItems(String search) async {
  Uri uri = Helper.getUri('api/production/material-lists');
  Map<String, dynamic> _queryParams = {};
  _queryParams['search'] = search;
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).expand((data) => (data as List)).map((data) {
      return MaterialList.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new MaterialList.fromJSON({}));
  }
}