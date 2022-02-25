import 'dart:convert';
import 'dart:io';

import 'package:app/models/production_issue.dart';
import 'package:app/models/production_item.dart';
import 'package:app/models/production_order.dart';
import 'package:app/models/production_order_line.dart';
import 'package:http/http.dart' as http;
import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';

Future<Stream<ProductionOrder>> searchDocuments(String search, String token, {bool byStatus = false}) async {
  Uri uri = Helper.getUri('api/production/orders');

  Map<String, dynamic> _queryParams = {};
  if (byStatus) {
    _queryParams['status'] = 'R';
  } else {
    _queryParams['search'] = search;
  }
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final request = new http.Request('get', uri);
    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });
    final streamedRest = await client.send(request);
    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).expand((data) => (data as List)).map((data) {
      return ProductionOrder.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new ProductionOrder.fromJSON({}));
  }
}

Future<Stream<ProductionOrder>> getDocumentsByStatus(String status) async {
  Uri uri = Helper.getUri('api/production/orders');
  String token = await Helper.getToken();

  Map<String, dynamic> _queryParams = {};
  _queryParams['status'] = status;
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final request = new http.Request('get', uri);
    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });
    final streamedRest = await client.send(request);
    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).expand((data) => (data as List)).map((data) {
      return ProductionOrder.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new ProductionOrder.fromJSON({}));
  }
}

Future<Stream<ProductionOrder>> getDocumentByDocEntry(int docEntry) async {
  Uri uri = Helper.getUri('api/production/orders/$docEntry');
  String token = await Helper.getToken();

  try {
    final client = new http.Client();
    final request = new http.Request('get', uri);
    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });
    final streamedRest = await client.send(request);
    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) {
      return ProductionOrder.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new ProductionOrder.fromJSON({}));
  }
}

Future<Stream<ProductionOrderLine>> getDocumentLine(int docEntry, int lineNum) async {
  Uri uri = Helper.getUri('api/production/order-line');
  String token = await Helper.getToken();

  Map<String, dynamic> _queryParams = {};
  _queryParams['DocEntry'] = docEntry.toString();
  _queryParams['LineNum'] = lineNum.toString();
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final request = new http.Request('get', uri);
    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });
    final streamedRest = await client.send(request);
    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) {
      return ProductionOrderLine.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new ProductionOrderLine.fromJSON({}));
  }
}

Future<http.Response> updateDocument(ProductionOrder document) async {
  Uri uri = Helper.getSAPUri('production-order/${document.docEntry}/update');
  final client = new http.Client();
  Map params = document.toMap();
  final response = await client.post(
    uri,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(params),
  );
  return response;
}

Future<http.Response> produce(DateTime date, int locCode, List<ProductionItem> items) async {
  Uri uri = Helper.getSAPUri('production-order/${items.first.docEntry}/produce');
  final client = new http.Client();
  ProductionIssue productionIssue = new ProductionIssue();
  productionIssue.date = date;
  productionIssue.locCode = locCode;
  productionIssue.lines = items;
  Map params = productionIssue.toMap();
  final response = await client.post(
    uri,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(params),
  );
  return response;
}

Future<http.Response> issue(DateTime date, List<ProductionItem> items) async {
  Uri uri = Helper.getSAPUri('production-order/${items.first.docEntry}/issue');
  final client = new http.Client();
  ProductionIssue productionIssue = new ProductionIssue();
  productionIssue.date = date;
  productionIssue.locCode = 0;
  productionIssue.lines = items;
  Map params = productionIssue.toMap();
  final response = await client.post(
    uri,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(params),
  );
  return response;
}

Future<http.Response> sub(List<ProductionItem> items) async {
  Uri uri = Helper.getSAPUri('production-order/${items.first.docEntry}/sub');
  final client = new http.Client();
  ProductionIssue productionIssue = new ProductionIssue();
  productionIssue.lines = items;
  Map params = productionIssue.toMap();
  final response = await client.post(
    uri,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(params),
  );
  return response;
}