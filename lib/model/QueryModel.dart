import 'package:bfast/model/UpdateModel.dart';

class QueryModel {
  int skip;
  int size;
  List<Map<String, int>> orderBy;
  Map<dynamic, dynamic> filter;
  List<String> returnFields;
  bool count;
  int last;
  int first;
  String id;
  UpdateModel update;

  QueryModel(
      {this.update,
      this.returnFields,
      this.last,
      this.first,
      this.count,
      this.size,
      this.id,
      this.filter,
      this.orderBy,
      this.skip});
}
