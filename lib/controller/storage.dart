import 'package:bfast/adapter/rest.dart';
import 'package:bfast/adapter/storage.dart';
import 'package:bfast/bfast_config.dart';
import 'package:bfast/controller/rest.dart';

class StorageController extends StorageAdapter {
  dynamic fileData;
  RestAdapter _restAdapter;
  String _appName;

  StorageController(RestAdapter restAdapter,
      {String appName = BFastConfig.DEFAULT_APP}) {
    this._restAdapter = restAdapter;
    this._appName = appName;
  }

  @override
  dynamic getData() {
    return this.fileData;
  }

  @override
  Future<SaveFileResponse> save(BFastFile file, [FileOptions options]) async {
    if (!(file != null && file.fileName != null && file.data != null)) {
      throw "file object to save required";
    }
    this.fileData = (file != null && file.data != null) ? file.data : null;
    var postHeader = <String,String>{};
    if (options != null && options.useMasterKey == true) {
      postHeader.addAll({
        'X-Parse-Master-Key': BFastConfig.getInstance()
            .getAppCredential(this._appName)
            .appPassword,
      });
    }
    if (options != null && options.sessionToken != null) {
      postHeader.addAll({'X-Parse-Session-Token': options?.sessionToken});
    }
    postHeader.addAll({
      'X-Parse-Application-Id': BFastConfig.getInstance()
          .getAppCredential(this._appName)
          .applicationId,
      'content-type': 'application/json'
    });
    var _source = StorageController.getSource(file.data.base64, file.fileType);
    Map dataToSave = {
      "base64": _source['base64'],
      "filename": file.fileName,
      "fileData": {
        "metadata": {},
        "tags": {},
      },
    };
    if (_source['type'] != null) {
      dataToSave["type"] = _source['type'];
    }
    RestResponse response = await this._restAdapter.post(
        BFastConfig.getInstance().databaseURL(this._appName, '/storage'),
        dataToSave,
        RestRequestConfig(headers: postHeader));
    String databaseUrl = BFastConfig.getInstance().databaseURL(this._appName);
    databaseUrl = databaseUrl.replaceAll('http://', '');
    databaseUrl = databaseUrl.replaceAll('https://', '');
    String url;
    if (options != null && options.forceSecure) {
      url = response.data["url"];
      url.replaceAll('http://', 'https://');
    } else {
      url = response.data["url"];
    }
    return SaveFileResponse(url.replaceAll('localhost:3000', databaseUrl));
  }

  static dynamic getSource(String base64, String type) {
    String _data;
    var _source;
    RegExp dataUriRegexp = new RegExp(
        '/^data:([a-zA-Z]+\/[-a-zA-Z0-9+.]+)(;charset=[a-zA-Z0-9\-\/]*)?;base64,/');
    int commaIndex = base64.indexOf(',');

    if (commaIndex != -1) {
      List matches = dataUriRegexp
          .allMatches(base64.substring(0, commaIndex + 1))
          .toList();
      // if data URI with type and charset, there will be 4 matches.
      _data = base64.substring(commaIndex + 1);
      _source = {
        "format": 'base64',
        "base64": _data,
        "type": matches != null && matches is List && matches.length > 0
            ? matches[1]
            : type
      };
    } else {
      _data = base64;
      _source = {"format": 'base64', "base64": _data, "type": type};
    }
    return _source;
  }
}
