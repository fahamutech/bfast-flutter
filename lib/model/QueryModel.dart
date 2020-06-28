class QueryModel{
  int skip;
  int size;
  List<Map<String, dynamic>> orderBy;
  Map<dynamic, dynamic> filter;
  List<String> keys;
  String id;
  QueryModel({
    int skip,
    int size,
    List<Map<String, dynamic>> orderBy,
    Map<dynamic, dynamic> filter,
    List<String> keys,
    String id,
}){
    this.size = size;
    this.skip = skip;
}
}
