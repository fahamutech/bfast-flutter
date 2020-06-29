import 'dart:async';

import 'package:bfast/adapter/function.dart';
import 'package:bfast/adapter/rest.dart';

class FunctionController<T> implements FunctionAdapter<T> {
  @override
  Future delete([RestRequestConfig config]) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<T> get([RestRequestConfig config]) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<T> post([Map<dynamic, dynamic> data, RestRequestConfig config]) {
    // TODO: implement post
    throw UnimplementedError();
  }

  @override
  Future<T> put([Map<dynamic, dynamic> data, RestRequestConfig config]) {
    // TODO: implement put
    throw UnimplementedError();
  }
}
