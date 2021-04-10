import 'dart:convert';
import 'dart:typed_data';

import 'package:bfast/adapter/rest.dart';
import 'package:http/http.dart' as http;

class BFastHttpClientController extends RestAdapter {
  http.Client httpClient;

  BFastHttpClientController({this.httpClient}) {
    if (this.httpClient == null) {
      this.httpClient = http.Client();
    }
  }

  @override
  Future<RestResponse<R>> delete<T, R>(String url,
      {RestRequestConfig config}) async {
    var response = await this.httpClient.delete(
        this._encodeUrlQueryParams(url, config?.params),
        headers: config?.headers);
    if (response.statusCode.toString().startsWith('20') == true) {
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
      {RestRequestConfig config}) async {
    var response = await this.httpClient.get(
        this._encodeUrlQueryParams(url, config?.params),
        headers: config?.headers);
    if (response.statusCode.toString().startsWith('20') == true) {
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

  Uri _encodeUrlQueryParams(String url, Map params) {
    String urlWithParams = url;
    urlWithParams += '?';
    if (params != null) {
      params.forEach((key, value) {
        urlWithParams +=
            '${key.toString()}=${Uri.encodeQueryComponent(value.toString())}&';
      });
    }
    return Uri.parse(urlWithParams);
  }

  @override
  Future<RestResponse<R>> head<T, R>(String url,
      {RestRequestConfig config}) async {
    var response = await this.httpClient.head(
        this._encodeUrlQueryParams(url, config?.params),
        headers: config?.headers);
    if (response.statusCode.toString().startsWith('20') == true) {
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
      {RestRequestConfig config}) async {
    var response = await this.httpClient.head(
        this._encodeUrlQueryParams(url, config?.params),
        headers: config?.headers);
    if (response.statusCode.toString().startsWith('20') == true) {
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
      {T data, RestRequestConfig config}) async {
    var response = await this.httpClient.patch(
        this._encodeUrlQueryParams(url, config?.params),
        body: data,
        headers: config?.headers);
    if (response.statusCode.toString().startsWith('20') == true) {
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
      {T data,
      RestRequestConfig config,
      http.MultipartRequest multipartRequest}) async {
    var response = await this.httpClient.post(
        this._encodeUrlQueryParams(url, config?.params),
        body: (data != null && data is Map) ? jsonEncode(data) : data,
        headers: config != null && config.headers != null
            ? config.headers
            : {"content-type": "application/json"});
    if (response.statusCode.toString().startsWith('20') == true) {
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
  Future<RestResponse> multiPartRequest(String url, ByteBuffer data,
      {http.MultipartRequest multipartRequest,
      String method = 'POST',
      RestRequestConfig config}) async {
    var uri = Uri.parse(url);
    http.MultipartRequest request;
    if (multipartRequest == null) {
      request = http.MultipartRequest(method, uri);
    }
    request
      ..files.add(http.MultipartFile.fromBytes('file', data.asUint32List()));
    var response = await request.send();
    if (response.statusCode.toString().startsWith('20') == true) {
      return RestResponse(data: response.reasonPhrase);
    } else {
      throw {
        "message": response.reasonPhrase,
        "reason": response.reasonPhrase,
        "statusCode": response.statusCode
      };
    }
  }

  @override
  Future<RestResponse<R>> put<T, R>(String url,
      {T data, RestRequestConfig config}) async {
    var response = await this.httpClient.put(
        this._encodeUrlQueryParams(url, config?.params),
        body: jsonEncode(data),
        headers: config?.headers);
    if (response.statusCode.toString().startsWith('20') == true) {
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

  RestResponse({this.data});
}
