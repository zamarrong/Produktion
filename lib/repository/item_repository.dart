import 'dart:convert';

import 'package:app/models/item_batch_number.dart';
import 'package:http/http.dart' as http;
import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/item.dart';

Future<Stream<Item>> searchItems(String search) async {
    Uri uri = Helper.getUri('api/items');
    Map<String, dynamic> _queryParams = {};
    _queryParams['search'] = search;
    uri = uri.replace(queryParameters: _queryParams);
    try {
      final client = new http.Client();
      final streamedRest = await client.send(http.Request('get', uri));

      return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).expand((data) => (data as List)).map((data) {
        return Item.fromJSON(data);
      });
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
      return new Stream.value(new Item.fromJSON({}));
  }
}

Future<Stream<ItemBatchNumber>> getBatchNumbers(String itemCode, String whsCode, int locCode) async {
  Uri uri = Helper.getUri('api/items/$itemCode/batch-numbers');
  Map<String, dynamic> _queryParams = {};
  _queryParams['whsCode'] = whsCode;
  _queryParams['locCode'] = locCode.toString();
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).expand((data) => (data as List)).map((data) {
      return ItemBatchNumber.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new ItemBatchNumber.fromJSON({}));
  }
}