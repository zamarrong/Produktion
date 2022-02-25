import 'dart:convert';
import 'dart:io';

import 'package:app/models/stock_transfer.dart';
import 'package:http/http.dart' as http;
import '../helpers/helper.dart';

Future<http.Response> addDocument(StockTransfer document) async {
  Uri uri = Helper.getSAPUri('stock-transfer');
  final client = new http.Client();
  Map params = document.toMap();
  final response = await client.post(
    uri,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(params),
  );
  return response;
}