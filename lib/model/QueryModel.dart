class QueryModel{
  int skip;
  int size;
  List<String> orderBy;
  Map<dynamic, dynamic> filter;
  List<String> keys;
  String id;
  QueryModel({
    int skip,
    int size,
    List<String> orderBy,
    Map<dynamic, dynamic> filter,
    List<String> keys,
    String id,
}){
    this.size = size;
    this.skip = skip;
    this.orderBy = orderBy;
    this.filter = filter;
    this.keys = keys;
    this.id = id;
}
}
