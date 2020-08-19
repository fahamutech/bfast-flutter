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

  Map<dynamic, dynamic> toMap() {
    var map = <dynamic, dynamic>{};
    if (this.update != null) {
      map['update'] = this.update;
    }
    if (this.returnFields != null) {
      map['return'] = this.returnFields;
    }
    if (this.last != null) {
      map['last'] = this.last;
    }
    if (this.first != null) {
      map['first'] = this.first;
    }
    if (this.count != null) {
      map['count'] = this.count;
    }
    if (this.size != null) {
      map['size'] = this.size;
    }
    if (this.id != null) {
      map['id'] = this.id;
    }
    if (this.filter != null) {
      map['filter'] = this.filter;
    }
    if (this.orderBy != null) {
      map['orderBy'] = this.orderBy;
    }
    if (this.skip != null) {
      map['skip'] = this.skip;
    }

    return map;
  }
}
