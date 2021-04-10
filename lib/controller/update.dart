import 'package:bfast/adapter/query.dart';
import 'package:bfast/adapter/rest.dart';
import 'package:bfast/bfast_config.dart';
import 'package:bfast/controller/database.dart';
import 'package:bfast/controller/rest.dart';
import 'package:bfast/controller/rules.dart';
import 'package:bfast/model/QueryModel.dart';
import 'package:bfast/model/UpdateModel.dart';

class UpdateController {
  UpdateModel _query = UpdateModel($set: {});
  String _domain;
  String _appName;
  RestAdapter _restAdapter;
  RulesController _rulesController;
  QueryModel _queryModel;

  UpdateController(this._domain, this._queryModel, this._appName,
      this._restAdapter, this._rulesController);

  UpdateController set(String field, dynamic value) {
    this._query.$set.addAll({
      [field]: value
    });
    return this;
  }

  UpdateController increment(String field, [int amount = 1]) {
    this._query.$inc.addAll({
      [field]: amount
    });
    return this;
  }

  UpdateController decrement(String field, [int amount = 1]) {
    return this.increment(field, -amount);
  }

  UpdateController currentDate(String field) {
    this._query.$currentDate.addAll({
      [field]: true
    });
    return this;
  }

  UpdateController minimum(String field, dynamic value) {
    this._query.$min.addAll({
      [field]: value
    });
    return this;
  }

  UpdateController maximum(String field, dynamic value) {
    this._query.$max.addAll({
      [field]: value
    });
    return this;
  }

  UpdateController multiply(String field, int quantity) {
    this._query.$mul.addAll({
      [field]: quantity
    });
    return this;
  }

  UpdateController renameField(String field, String value) {
    this._query.$rename.addAll({
      [field]: value
    });
    return this;
  }

  UpdateController removeField(String field) {
    this._query.$unset.addAll({
      [field]: ''
    });
    return this;
  }

  UpdateModel _build() {
    return this._query;
  }

  Future<dynamic> update([RequestOptions options]) async {
    var updateRule = await this._rulesController.updateRule(
        this._domain,
        this._queryModel,
        this._build(),
        BFastConfig.getInstance().getAppCredential(this._appName),
        options);
    RestResponse response = await this._restAdapter.post(
        BFastConfig.getInstance().databaseURL(this._appName),
        data: updateRule);
    return DatabaseController.extractResultFromServer(
        response.data, 'update', this._domain);
  }
}
