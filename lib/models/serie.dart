class Serie {
  String objectCode;
  String code;
  String name;

  Serie();

  Serie.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      objectCode = jsonMap['ObjectCode'];
      code = jsonMap['Series'];
      name = jsonMap['SeriesName'];
    } catch (e) {
      objectCode = code = name = '';
      print('Error: ${e} ${jsonMap}');
    }
  }
}
