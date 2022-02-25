import 'dart:convert';
import 'dart:io';

import 'package:app/models/inventory_transfer_request.dart';
import 'package:app/models/inventory_transfer_request_line.dart';
import 'package:http/http.dart' as http;
import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';

Future<Stream<InventoryTransferRequest>> getDocumentsByStatus(String status) async {
  Uri uri = Helper.getUri('api/inventory-transfer-requests');
  Map<String, dynamic> _queryParams = {};
  _queryParams['status'] = status;
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).expand((data) => (data as List)).map((data) {
      return InventoryTransferRequest.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new InventoryTransferRequest.fromJSON({}));
  }
}

Future<Stream<InventoryTransferRequest>> getDocumentByDocEntry(int docEntry) async {
  Uri uri = Helper.getUri('api/inventory-transfer-requests/$docEntry');
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) {
      return InventoryTransferRequest.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new InventoryTransferRequest.fromJSON({}));
  }
}

Future<Stream<InventoryTransferRequestLine>> getDocumentLine(int docEntry, int lineNum) async {
  Uri uri = Helper.getUri('api/inventory-transfer-request-line');
  Map<String, dynamic> _queryParams = {};
  _queryParams['DocEntry'] = docEntry.toString();
  _queryParams['LineNum'] = lineNum.toString();
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) {
      return InventoryTransferRequestLine.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new InventoryTransferRequestLine.fromJSON({}));
  }
}

Future<http.Response> addDocument(InventoryTransferRequest document) async {
  Uri uri = Helper.getSAPUri('inventory-transfer-request');
  final client = new http.Client();
  Map params = document.toMap();
  final response = await client.post(
    uri,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(params),
  );
  return response;
}

Future<http.Response> toStockTransfer(InventoryTransferRequest document) async {
  final String url = 'http://10.10.1.6:45455/api/stock-transfer';
  final client = new http.Client();
  Map params = document.toMap();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(params),
  );
  return response;
}