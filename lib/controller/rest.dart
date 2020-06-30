import 'dart:convert';

import 'package:bfast/adapter/rest.dart';
import 'package:http/http.dart' as httpClient;

class DartHttpClientController extends RestAdapter {
  @override
  Future<RestResponse<T>> delete<T>(String url, [RestRequestConfig config]) async {
    var response = await httpClient.delete(
        this._encodeUrlQueryParams(url, config?.params),
        headers: config?.headers);
    if (response.statusCode.toString().startsWith('20')) {
      return RestResponse(data: jsonDecode(response.body));
    } else {
      throw response.reasonPhrase;
    }
  }

  @override
  Future<RestResponse<T>> get<T>(String url, [RestRequestConfig config]) async {
    var response = await httpClient.get(
        this._encodeUrlQueryParams(url, config?.params),
        headers: config?.headers);
    if (response.statusCode.toString().startsWith('20')) {
      return RestResponse(data: jsonDecode(response.body));
    } else {
      throw response.reasonPhrase;
    }
  }

  String _encodeUrlQueryParams(String url, Map params) {
    String urlWithParams = url;
    urlWithParams += '?';
    if (params == null) {
      params.forEach((key, value) {
        urlWithParams += '$key=${Uri.encodeQueryComponent(value)}&';
      });
    }
    return urlWithParams;
  }

  @override
  Future<RestResponse<T>> head<T>(String url, [RestRequestConfig config]) async {
    var response = await httpClient.head(
        this._encodeUrlQueryParams(url, config?.params),
        headers: config?.headers);
    if (response.statusCode.toString().startsWith('20')) {
      return RestResponse(data: jsonDecode(response.body));
    } else {
      throw response.reasonPhrase;
    }
  }

  @override
  Future<RestResponse<T>> options<T>(String url, [RestRequestConfig config]) async {
    var response = await httpClient.head(
        this._encodeUrlQueryParams(url, config?.params),
        headers: config?.headers);
    if (response.statusCode.toString().startsWith('20')) {
      return RestResponse(data: jsonDecode(response.body));
    } else {
      throw response.reasonPhrase;
    }
  }

  @override
  Future<RestResponse<T>> patch<T>(String url,
      [Map<dynamic, dynamic> data, RestRequestConfig config]) async {
    var response = await httpClient.patch(
        this._encodeUrlQueryParams(url, config?.params),
        body: data,
        headers: config?.headers);
    if (response.statusCode.toString().startsWith('20')) {
      return RestResponse(data: jsonDecode(response.body));
    } else {
      throw response.reasonPhrase;
    }
  }

  @override
  Future<RestResponse<T>> post<T>(String url,
      [Map<dynamic, dynamic> data, RestRequestConfig config]) async {
    var response = await httpClient.post(
        this._encodeUrlQueryParams(url, config?.params),
        body: data,
        headers: config?.headers);
    if (response.statusCode.toString().startsWith('20')) {
      return RestResponse(data: jsonDecode(response.body));
    } else {
      throw response.reasonPhrase;
    }
  }

  @override
  Future<RestResponse<T>> put<T>(String url,
      [Map<dynamic, dynamic> data, RestRequestConfig config]) async {
    var response = await httpClient.put(
        this._encodeUrlQueryParams(url, config?.params),
        body: data,
        headers: config?.headers);
    if (response.statusCode.toString().startsWith('20')) {
      return RestResponse(data: jsonDecode(response.body));
    } else {
      throw response.reasonPhrase;
    }
  }
}

class RestResponse<T> {
  T data;

  RestResponse({T data}) {
    this.data = data;
  }
}
