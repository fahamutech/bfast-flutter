import 'dart:html' as html;
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:bfast/adapter/auth.dart';
import 'package:bfast/adapter/query.dart';
import 'package:bfast/adapter/rest.dart';
import 'package:bfast/adapter/storage.dart';
import 'package:bfast/bfast_config.dart';
import 'package:bfast/controller/rest.dart';
import 'package:bfast/controller/rules.dart';
import 'package:bfast/model/FileQueryModel.dart';
import 'package:flutter/foundation.dart';

class StorageController {
  RestAdapter _restAdapter;
  AuthAdapter _authAdapter;
  RulesController _rulesController;
  String _appName;

  StorageController(this._restAdapter, this._authAdapter, this._rulesController,
      this._appName);

  Future<dynamic> save(
      dynamic file, void Function(dynamic progress) uploadProgress,
      [RequestOptions options]) {
    if (file is File) {
      return this._handleFileUploadInNode(file, uploadProgress,
          BFastConfig.getInstance().getAppCredential(this._appName), options);
    } else if (kIsWeb == true && file is html.File) {
      return this._handleFileUploadInWeb(file, uploadProgress,
          BFastConfig.getInstance().getAppCredential(this._appName), options);
    } else {
      throw Exception('file object to save required');
    }
  }

  Future<List<dynamic>> list(
      [FileQueryModel query, RequestOptions options]) async {
    var filesRule = await this._rulesController.storage("list", query,
        BFastConfig.getInstance().getAppCredential(this._appName), options);
    return this._handleFileRuleRequest(filesRule, 'list');
  }

  Future<dynamic> delete(String filename, [RequestOptions options]) async {
    var filesRule = await this._rulesController.storage(
        "delete",
        {"filename": filename},
        BFastConfig.getInstance().getAppCredential(this._appName),
        options);
    return this._handleFileRuleRequest(filesRule, 'delete');
  }

  Future<dynamic> _handleFileRuleRequest(
      dynamic storageRule, String action) async {
    RestResponse response = await this._restAdapter.post(
        BFastConfig.getInstance().databaseURL(this._appName), storageRule);
    var data = response.data;
    if (data != null &&
        data['files'] != null &&
        data['files']['list'] != null &&
        data['files']['list'] is List) {
      return data['files']['list'];
    } else {
      var errors = data['errors'];
      throw errors != null && errors['files.$action'] != null
          ? errors['files.$action']
          : {"message": 'Fails to process your request', "errors": errors};
    }
  }

  Future<String> _handleFileUploadInNode(
      ByteBuffer readStream,
      void Function(dynamic progress) uploadProgress,
      AppCredentials appCredentials,
      [RequestOptions options]) async {
    const headers = {};
    if (options != null && options.useMasterKey == true) {
      headers.addAll({
        'masterKey': appCredentials.appPassword,
      });
    }
    var token = await this._authAdapter.getToken();
    headers.addAll({'Authorization': 'Bearer $token'});

    http.MultipartFile.fromBytes('k', readStream.asUint32List());
    const formData = new FormDataNode();
    formData.append('file_stream', readStream);

    RestResponse response = await this._restAdapter.post(
        BFastConfig.getInstance().databaseURL(
            this._appName, '/storage/' + appCredentials.applicationId),
        formData,
        RestRequestConfig(headers: headers, uploadProgress: uploadProgress));
    var databaseUrl = BFastConfig.getInstance().databaseURL(this._appName);
    return databaseUrl + response.data['urls'][0];
  }

  Future<String> _handleFileUploadInWeb(
      html.File file,
      void Function(dynamic progress) uploadProgress,
      AppCredentials appCredentials,
      [RequestOptions options]) async {
    const headers = {};
    if (options != null && options.useMasterKey == true) {
      headers.addAll({
        'masterKey': appCredentials.appPassword,
      });
    }
    var token = await this._authAdapter.getToken();
    headers.addAll({'Authorization': 'Bearer $token'});
    html.FormData formData = new html.FormData();
    formData.appendBlob('file', file);
    RestResponse response = await this._restAdapter.post(
        BFastConfig.getInstance().databaseURL(
            this._appName, '/storage/' + appCredentials.applicationId),
        formData,
        RestRequestConfig(headers: headers, uploadProgress: uploadProgress));
    var databaseUrl = BFastConfig.getInstance().databaseURL(this._appName);
    return databaseUrl + response.data['urls'][0];
  }
}
