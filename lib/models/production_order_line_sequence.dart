class ProductionOrderLineSequence {
  String docEntry;
  int stageId;
  int seqNum;
  int stgEntry;
  String name;
  String status;
  String comments;

  ProductionOrderLineSequence();

  ProductionOrderLineSequence.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      docEntry = jsonMap['DocEntry'];
      stageId = int.parse(jsonMap['StageId']);
      seqNum = int.parse(jsonMap['SeqNum']);
      stgEntry = int.parse(jsonMap['StgEntry']);
      name = jsonMap['Name'];
      status = jsonMap['U_Status'];
      comments = jsonMap['U_Comments'] ?? '';
    } catch (e) {
      docEntry = '';
      stageId = 0;
      seqNum = 0;
      stgEntry = 0;
      name = status = comments = '';
      print('Error: ${e} ${jsonMap}');
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['DocEntry'] = docEntry;
    map['StageId'] = stageId;
    map['SeqNum'] = seqNum;
    map['StgEntry'] = stgEntry;
    map['Name'] = name;
    map['Status'] = status;
    map['Comments'] = comments;
    return map;
  }
}
