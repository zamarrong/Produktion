class Sequence {
  String father;
  int stageId;
  int seqNum;
  int stgEntry;
  String name;

  Sequence();

  Sequence.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      father = jsonMap['Father'];
      stageId = int.parse(jsonMap['StageId']);
      seqNum = int.parse(jsonMap['SeqNum']);
      stgEntry = int.parse(jsonMap['StgEntry']);
      name = jsonMap['Name'];
    } catch (e) {
      father = '';
      stageId = 0;
      seqNum = 0;
      stgEntry = 0;
      name = '';
      print('Error: ${e} ${jsonMap}');
    }
  }
}
