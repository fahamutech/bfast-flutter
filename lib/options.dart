const DEFAULT_APP = 'DEFAULT';
const AUTH_CACHE_NAME = '_current_user_';
const AUTH_CACHE_DEFAULT_VALUE = '_empty_';
const String DEFAULT_DOMAINS_CACHE_DB_NAME = '__domain';
const String DEFAULT_CACHE_DB_NAME = '__cache';
const String DEFAULT_CACHE_TTL_COLLECTION_NAME = '__cache_ttl';
const String DEFAULT_AUTH_CACHE_DB_NAME = '__auth';

Map<String, String> getInitialHeaders() =>
    <String, String>{
      'Content-Type': 'application/json'
    };

String functionsURL({required String path, required App options}) {
  if (path.startsWith('http') == true) {
    return path;
  }
  if (options.functionsURL != null &&
      options.functionsURL?.startsWith('http') == true) {
    return options.functionsURL ?? '' + path;
  }
  return 'https://${options.projectId}-faas.bfast.fahamutech.com$path';
}

String databaseURL({suffix = '', required App options}) {
  if (options.databaseURL != null &&
      options.databaseURL?.startsWith('http') == true) {
    if (suffix != null) {
      return '${options.databaseURL}$suffix';
    } else {
      return options.databaseURL ?? '';
    }
  }
  if (suffix != null) {
    return 'https://${options.projectId}-daas.bfast.fahamutech.com/v2$suffix';
  } else {
    return 'https://${options.projectId}-daas.bfast.fahamutech.com/v2';
  }
}

String getCacheDatabaseName({
  required String name,
  required App options,
}) {
  return (name.isNotEmpty == true)
      ? 'bfast/${options.projectId}/$name'
      : 'bfast/${options.projectId}';
}

String getCacheCollectionName({required String name}) =>
    (name != '') ? name : 'cache';

class App {
  final String applicationId;
  final String projectId;
  final String? functionsURL;
  final String? databaseURL;
  final String? appPassword;

  App({
    required this.applicationId,
    required this.projectId,
    required this.functionsURL,
    required this.databaseURL,
    required this.appPassword,
  });
}
