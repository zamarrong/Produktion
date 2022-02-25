class Stage {
  int id;
  String code;
  String name;

  Stage();

  Stage.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['AbsEntry'];
      code = jsonMap['Code'];
      name = jsonMap['Desc'];
    } catch (e) {
      id = 0;
      code = '';
      name = '';
      print('Error: ${e} ${jsonMap}');
    }
  }
}