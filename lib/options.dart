import 'package:bfast/util.dart';

const DEFAULT_APP = 'DEFAULT';
const AUTH_CACHE_NAME = '_current_user_';
const AUTH_CACHE_DEFAULT_VALUE = '_empty_';
const String DEFAULT_DOMAINS_CACHE_DB_NAME = '__domain';
const String DEFAULT_CACHE_DB_NAME = '__cache';
const String DEFAULT_CACHE_TTL_COLLECTION_NAME = '__cache_ttl';
const String DEFAULT_AUTH_CACHE_DB_NAME = '__auth';

Map<String, String> getInitialHeaders() =>
    <String, String>{'Content-Type': 'application/json'};

var _isStartWithHttp = compose([
  (y) => y.startsWith('http'),
  ifDoElse((x) => x is String, (f1) => f1, (f2) => '')
]);
var _functionURLOrEmpty = ifDoElse((t) => t is App && t.functionsURL != null,
    (t) => t.functionsURL, (t) => '');
var _hasFunctionsURLAndStartWithHttp =
    compose([_isStartWithHttp, _functionURLOrEmpty]);
var _getFUrl = (app) => (path) => '${app.functionsURL}$path';

_getFaasUrl(app) => ifDoElse(
      (_) => app is App,
      (path) => 'https://${app.projectId}-faas.bfast.fahamutech.com$path',
      (path) => 'https://null-faas.bfast.fahamutech.com',
    );
// (path) => 'https://${app.projectId}-faas.bfast.fahamutech.com$path';

_getDaasUrl(app) => ifDoElse(
      (_) => app is App,
      (x) =>
          'https://${app?.projectId}-daas.bfast.fahamutech.com/v2${_itOrEmpty(x)}',
      (x) => 'https://null-daas.bfast.fahamutech.com/v2${_itOrEmpty(x)}',
    );
var _databaseURLOrEmpty = ifDoElse(
    (t) => t is App && t.databaseURL != null, (t) => t.databaseURL, (t) => '');
var _hasDatabaseURLAndStartWithHttp =
    compose([_isStartWithHttp, _databaseURLOrEmpty]);

var _itOrEmpty = ifDoElse((x) => x is String, (y) => '$y', (_) => '');

Function(dynamic path) functionsURL(app) => ifDoElse(
      _isStartWithHttp,
      map((x) => x),
      ifDoElse(
        (_) => _hasFunctionsURLAndStartWithHttp(app),
        _getFUrl(app),
        _getFaasUrl(app),
      ),
    );

Function(dynamic suffix) databaseURL(app) => ifDoElse(
      (_) => _hasDatabaseURLAndStartWithHttp(app),
      (x) => '${app?.databaseURL}${_itOrEmpty(x)}',
      _getDaasUrl(app),
    );

var _projectIdOrCacheDefaultName =
    ifDoElse((app) => app is App, (app) => app?.projectId, (app) => 'cache');

cacheDatabaseName(app) {
  var dbName = _projectIdOrCacheDefaultName(app);
  return ifDoElse(
    (name) => name is String && name.isNotEmpty,
    (name) => '/bfast/$dbName/$name',
    (name) => '/bfast/$dbName',
  );
}

class App {
  final String applicationId;
  final String projectId;
  final String? functionsURL;
  final String? databaseURL;
  final String? appPassword;

  App({
    required this.applicationId,
    required this.projectId,
    this.functionsURL,
    this.databaseURL,
    this.appPassword,
  });
}
