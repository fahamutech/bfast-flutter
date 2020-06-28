import 'package:bfast/adapter/rest.dart';

abstract class FunctionAdapter<T> {
  Future<T> post([Map<dynamic, dynamic> data, RestRequestConfig config]);
  Future<T> get([RestRequestConfig config]);
  Future<dynamic> delete([RestRequestConfig config]);
  Future<T> put([Map<dynamic, dynamic> data, RestRequestConfig config]);
}
