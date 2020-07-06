import 'dart:convert';

import 'package:bfast/adapter/rest.dart';
import 'package:http/http.dart' as http;

class BFastHttpClientController extends RestAdapter {
  http.Client _httpClient;

  BFastHttpClientController({http.Client httpClient}) {
    if (httpClient != null) {
      this._httpClient = httpClient;
    } else {
      this._httpClient = http.Client();
    }
  }

  @override
  Future<RestResponse<R>> delete<T, R>(String url,
      [RestRequestConfig config]) async {
    var response = await this._httpClient.delete(
        this._encodeUrlQueryParams(url, config?.params),
        headers: config?.headers);
    if (response.statusCode.toString().startsWith('20')) {
      return RestResponse(
          data: response.body.startsWith('{')
              ? jsonDecode(response.body)
              : response.body);
    } else {
      throw {
        "message": response.body,
        "reason": response.reasonPhrase,
        "statusCode": response.statusCode
      };
    }
  }

  @override
  Future<RestResponse<R>> get<T, R>(String url,
      [RestRequestConfig config]) async {
    var response = await this._httpClient.get(
        this._encodeUrlQueryParams(url, config?.params),
        headers: config?.headers);
    if (response.statusCode.toString().startsWith('20')) {
      return RestResponse(
          data: response.body.startsWith('{')
              ? jsonDecode(response.body)
              : response.body);
    } else {
      throw {
        "message": response.body,
        "reason": response.reasonPhrase,
        "statusCode": response.statusCode
      };
    }
  }

  String _encodeUrlQueryParams(String url, Map params) {
    String urlWithParams = url;
    urlWithParams += '?';
    if (params != null) {
      params.forEach((key, value) {
        urlWithParams +=
            '${key.toString()}=${Uri.encodeQueryComponent(value.toString())}&';
      });
    }
    return urlWithParams;
  }

  @override
  Future<RestResponse<R>> head<T, R>(String url,
      [RestRequestConfig config]) async {
    var response = await this._httpClient.head(
        this._encodeUrlQueryParams(url, config?.params),
        headers: config?.headers);
    if (response.statusCode.toString().startsWith('20')) {
      return RestResponse(
          data: response.body.startsWith('{')
              ? jsonDecode(response.body)
              : response.body);
    } else {
      throw {
        "message": response.body,
        "reason": response.reasonPhrase,
        "statusCode": response.statusCode
      };
    }
  }

  @override
  Future<RestResponse<R>> options<T, R>(String url,
      [RestRequestConfig config]) async {
    var response = await this._httpClient.head(
        this._encodeUrlQueryParams(url, config?.params),
        headers: config?.headers);
    if (response.statusCode.toString().startsWith('20')) {
      return RestResponse(
          data: response.body.startsWith('{')
              ? jsonDecode(response.body)
              : response.body);
    } else {
      throw {
        "message": response.body,
        "reason": response.reasonPhrase,
        "statusCode": response.statusCode
      };
    }
  }

  @override
  Future<RestResponse<R>> patch<T, R>(String url,
      [T data, RestRequestConfig config]) async {
    var response = await this._httpClient.patch(
        this._encodeUrlQueryParams(url, config?.params),
        body: data,
        headers: config?.headers);
    if (response.statusCode.toString().startsWith('20')) {
      return RestResponse(
          data: response.body.startsWith('{')
              ? jsonDecode(response.body)
              : response.body);
    } else {
      throw {
        "message": response.body,
        "reason": response.reasonPhrase,
        "statusCode": response.statusCode
      };
    }
  }

  @override
  Future<RestResponse<R>> post<T, R>(String url,
      [T data, RestRequestConfig config]) async {
    var response = await this._httpClient.post(
        this._encodeUrlQueryParams(url, config?.params),
        body: (data != null && data is Map) ? jsonEncode(data) : data,
        headers: config?.headers);
    if (response.statusCode.toString().startsWith('20')) {
      return RestResponse(
          data: response.body.startsWith('{')
              ? jsonDecode(response.body)
              : response.body);
    } else {
      throw {
        "message": response.body,
        "reason": response.reasonPhrase,
        "statusCode": response.statusCode
      };
    }
  }

  @override
  Future<RestResponse<R>> put<T, R>(String url,
      [T data, RestRequestConfig config]) async {
    var response = await this._httpClient.put(
        this._encodeUrlQueryParams(url, config?.params),
        body: jsonEncode(data),
        headers: config?.headers);
    if (response.statusCode.toString().startsWith('20')) {
      return RestResponse(
          data: response.body.startsWith('{')
              ? jsonDecode(response.body)
              : response.body);
    } else {
      throw {
        "message": response.body,
        "reason": response.reasonPhrase,
        "statusCode": response.statusCode
      };
    }
  }
}

class RestResponse<T> {
  T data;

  RestResponse({T data}) {
    this.data = data;
  }
}
