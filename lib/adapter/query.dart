

class CacheOptions {
  bool cacheEnable;
  int dtl;
  Function({String identifier, dynamic data}) freshDataCallback;

  CacheOptions(
      {bool cacheEnable,
      int dtl,
      Function({String identifier, dynamic data}) freshDataCallback}) {
    this.cacheEnable = cacheEnable;
    this.dtl = dtl;
    this.freshDataCallback = freshDataCallback;
  }
}

class FullTextOptions {
  String language;
  String caseSensitive;
  String diacriticSensitive;
}

class AggregationOptions {
  Map<String, dynamic> group;
  Map<String, dynamic> match;
  Map<String, dynamic> project;
  Map<String, int> sort;
  int limit;
  int skip;

  AggregationOptions({
    Map<String, dynamic> group,
    Map<String, dynamic> match,
    Map<String, dynamic> project,
    Map<String, int> sort,
    int limit,
    int skip,
  }) {
    this.group = group;
    this.match = match;
    this.project = project;
    this.sort = sort;
    this.limit = limit;
    this.skip = skip;
  }
}

class RequestOptions extends CacheOptions {
  bool useMasterKey;
  List<String> returnFields;

  RequestOptions({bool userMasterKey, List<String> returnFields}) {
    this.useMasterKey = userMasterKey;
    this.returnFields = returnFields;
  }
}
