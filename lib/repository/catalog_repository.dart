import 'dart:convert';

import 'package:http/http.dart' as http;
import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import 'package:app/models/warehouse.dart';

Future<Stream<Warehouse>> getWarehouses() async {
  Uri uri = Helper.getUri('api/catalogs/warehouses');
  Map<String, dynamic> _queryParams = {};
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).expand((data) => (data as List)).map((data) {
      return Warehouse.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Warehouse.fromJSON({}));
  }
}