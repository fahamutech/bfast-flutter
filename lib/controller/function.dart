import 'dart:async';

import 'package:bfast/adapter/rest.dart';
import 'package:bfast/bfast_config.dart';
import 'package:bfast/controller/rest.dart';

class FunctionController<T> {
  String functionPath;
  String appName;
  RestAdapter restAdapter;

  FunctionController(String functionPath, RestAdapter restAdapter,
      {String appName = BFastConfig.DEFAULT_APP}) {
    this.functionPath = functionPath;
    this.restAdapter = restAdapter;
    this.appName = appName;
  }

  Future delete([RestRequestConfig config]) async {
    RestRequestConfig deleteConfig = RestRequestConfig();
    if (config != null && config.headers != null) {
      deleteConfig = config;
    } else {
      deleteConfig.headers = BFastConfig.getInstance().getHeaders(this.appName);
      deleteConfig.params = config?.params;
      deleteConfig.url = config?.url;
      deleteConfig.method = config?.method;
      deleteConfig.baseURL = config?.baseURL;
    }
    RestResponse response = await this.restAdapter.delete(
        BFastConfig.getInstance().functionsURL(this.functionPath, this.appName),
        config: deleteConfig);
    return response.data;
  }

  Future<T> get([RestRequestConfig config]) async {
    RestRequestConfig getConfig = RestRequestConfig();
    if (config != null && config.headers != null) {
      getConfig = config;
    } else {
      getConfig.headers = BFastConfig.getInstance().getHeaders(this.appName);
      getConfig.params = config?.params;
      getConfig.url = config?.url;
      getConfig.method = config?.method;
      getConfig.baseURL = config?.baseURL;
    }
    RestResponse response = await this.restAdapter.get(
        BFastConfig.getInstance().functionsURL(this.functionPath, this.appName),
        config: getConfig);
    return response.data;
  }

  Future<T> post([Map<dynamic, dynamic> data, RestRequestConfig config]) async {
    if (this.functionPath != null && this.functionPath != '') {
      RestRequestConfig postConfig = RestRequestConfig();
      if (config != null && config.headers != null) {
        postConfig = config;
      } else {
        postConfig.headers = BFastConfig.getInstance().getHeaders(this.appName);
        postConfig.params = config?.params;
        postConfig.url = config?.url;
        postConfig.method = config?.method;
        postConfig.baseURL = config?.baseURL;
      }
      RestResponse value = await this.restAdapter.post(
          BFastConfig.getInstance()
              .functionsURL(this.functionPath, this.appName),
          data: data != null ? data : {},
          config: postConfig);
      return value.data;
    } else {
      throw {"code": -1, "message": 'Please provide function path'};
    }
  }

  Future<T> put([Map<dynamic, dynamic> data, RestRequestConfig config]) async {
    RestRequestConfig putConfig = RestRequestConfig();
    if (config != null && config.headers != null) {
      putConfig = config;
    } else {
      putConfig.headers = BFastConfig.getInstance().getHeaders(this.appName);
      putConfig.params = config?.params;
      putConfig.url = config?.url;
      putConfig.method = config?.method;
      putConfig.baseURL = config?.baseURL;
    }
    RestResponse response = await this.restAdapter.put(
        BFastConfig.getInstance().functionsURL(this.functionPath, this.appName),
        data: data != null ? data : {},
        config: putConfig);
    return response.data;
  }
}
