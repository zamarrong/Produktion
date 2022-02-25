import 'package:app/models/stock_transfer_line.dart';

class StockTransfer {
  int docEntry;
  int series;
  int docNum;
  String docType;
  String canceled;
  String printed;
  String docStatus;
  String invntSttus;
  int objType;
  DateTime docDate;
  DateTime docDueDate;
  String cardCode;
  String cardName;
  String whsCode;
  String toWhsCode;
  String docCur;
  double docRate;
  double docTotal;
  String comments;
  List<StockTransferLine> lines;

  StockTransfer() {
    docEntry = 0;
    docNum = 0;
    docType = 'I';
    canceled = 'N';
    printed = 'N';
    docStatus = 'O';
    invntSttus = 'O';
    objType = 67;
    docDate = new DateTime.now();
    docDueDate = new DateTime.now();
    cardCode = '';
    cardName = '';
    whsCode = '';
    toWhsCode = '';
    docCur = 'MXP';
    docRate = 0.0;
    docTotal = 0.0;
    comments = '';
    lines = [];
  }

  StockTransfer.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      docEntry = jsonMap['DocEntry'];
      series = int.parse(jsonMap['Series']);
      docNum = int.parse(jsonMap['DocNum']);
      docType = jsonMap['DocType'];
      canceled = jsonMap['CANCELED'];
      printed = jsonMap['Printed'];
      docStatus = jsonMap['DocStatus'];
      invntSttus = jsonMap['InvntSttus'];
      objType = int.parse(jsonMap['ObjType']);
      docDate =  DateTime.parse(jsonMap['DocDate']);
      docDueDate = DateTime.parse(jsonMap['DocDueDate']);
      cardCode = jsonMap['CardCode'] ?? '';
      cardName = jsonMap['CardName'] ?? '';
      whsCode = jsonMap['Filler'];
      toWhsCode = jsonMap['ToWhsCode'];
      docCur = jsonMap['DocCur'];
      docRate = double.parse(jsonMap['DocRate']);
      docTotal = double.parse(jsonMap['DocTotal']);
      comments = jsonMap['Comments'] ?? '';
      lines = jsonMap['lines'] != null && (jsonMap['lines'] as List).length > 0
          ? List.from(jsonMap['lines']).map((element) => StockTransferLine.fromJSON(element)).toSet().toList()
          : [];
    } catch (e) {
      docEntry = 0;
      docNum = 0;
      docType = 'I';
      canceled = 'N';
      printed = 'N';
      docStatus = 'O';
      invntSttus = 'O';
      objType = 1250000001;
      docDate = new DateTime.now();
      docDueDate = new DateTime.now();
      cardCode = '';
      cardName = '';
      whsCode = '';
      toWhsCode = '';
      docCur = 'MXP';
      docRate = 0.0;
      docTotal = 0.0;
      comments = '';
      lines = [];
      print(jsonMap);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['DocEntry'] = docEntry;
    map['ObjType'] = objType;
    map['Filler'] = whsCode;
    map['ToWhsCode'] = toWhsCode;
    map['Comments'] = comments;
    map['Lines'] = lines?.where((element) => element.selected)?.map((element) => element.toMap())?.toList();
    return map;
  }

  String getStatus()
  {
    return docStatus == 'O' ? 'Abierto' : 'Cerrado';
  }

  @override
  bool operator ==(dynamic other) {
    return other.docEntry == this.docEntry;
  }

  @override
  int get hashCode => this.docEntry.hashCode;
}
