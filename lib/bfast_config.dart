import 'package:http/http.dart' as http;

class BFastConfig {
  static String serverUrl;
  static String apiKey;
  static http.Client client;

  static const DEFAULT_APP = 'DEFAULT';
  String _DEFAULT_DOMAINS_CACHE_DB_NAME = '__domain';

  get DEFAULT_DOMAINS_CACHE_DB_NAME {
    return this._DEFAULT_DOMAINS_CACHE_DB_NAME;
  }

  String _DEFAULT_CACHE_DB_NAME = '__cache';

  get DEFAULT_CACHE_DB_NAME {
    return this._DEFAULT_CACHE_DB_NAME;
  }

  String _DEFAULT_CACHE_TTL_COLLECTION_NAME = '__cache_ttl';

  get DEFAULT_CACHE_TTL_COLLECTION_NAME {
    return this._DEFAULT_CACHE_TTL_COLLECTION_NAME;
  }

  String _DEFAULT_AUTH_CACHE_DB_NAME = '__auth';

  get DEFAULT_AUTH_CACHE_DB_NAME {
    return this._DEFAULT_AUTH_CACHE_DB_NAME;
  }

  Map<String, AppCredentials> credentials = {};

  BFastConfig._();

  static BFastConfig _instance;

  static BFastConfig getInstance(
      [AppCredentials config, String appName = BFastConfig.DEFAULT_APP]) {
    if (BFastConfig._instance == null) {
      BFastConfig._instance = new BFastConfig._();
    }
    if (config != null) {
      BFastConfig._instance.credentials[appName] = config;
    }
    return BFastConfig._instance;
  }

  AppCredentials getAppCredential([String appName = BFastConfig.DEFAULT_APP]) {
    if (this.credentials[appName] == null) {
      throw 'The app -> $appName is not initialized';
    }
    return this.credentials[appName];
  }

  Map<String, dynamic> getHeaders(String appName) {
    return <String, String>{
      'Content-Type': 'application/json',
      'X-Parse-Application-Id': this.credentials[appName].applicationId
    };
  }

  Map<String, dynamic> getMasterHeaders(String appName) {
    return <String, String>{
      'Content-Type': 'application/json',
      'X-Parse-Application-Id': this.credentials[appName].applicationId,
      'X-Parse-Master-Key': this.credentials[appName].appPassword,
    };
  }

  String functionsURL(String path, String appName) {
    if (path.startsWith('http')) {
      return path;
    }
    if (this.credentials[appName].functionsURL != null &&
        this.credentials[appName].functionsURL.startsWith('http')) {
      return this.credentials[appName].functionsURL;
    }
    return 'https://${this.credentials[appName].projectId}-faas.bfast.fahamutech.com$path';
  }

  String databaseURL(String appName, [String suffix]) {
    if (this.credentials[appName].databaseURL != null &&
        this.credentials[appName].databaseURL.startsWith('http')) {
      if (suffix != null) {
        return this.credentials[appName].databaseURL + suffix;
      } else {
        return this.credentials[appName].databaseURL;
      }
    }
    if (suffix != null) {
      return 'https://${this.getAppCredential(appName).projectId}-daas.bfast.fahamutech.com$suffix';
    } else {
      return 'https://${this.getAppCredential(appName).projectId}-daas.bfast.fahamutech.com';
    }
  }

  String getCacheDatabaseName(String name, String appName) {
    if (name != null && name.isNotEmpty) {
      return '/bfast/${this.getAppCredential(appName).projectId}/$appName/$name';
    } else {
      return '/bfast/${this.getAppCredential(appName).projectId}/$appName';
    }
  }

  String getCacheCollectionName(String name, String appName) {
    if (name != null && name != '') {
      return '$name/$appName';
    } else {
      return 'cache/$appName';
    }
  }
}

class AppCredentials {
  String applicationId;
  String projectId;
  String functionsURL;
  String databaseURL;
  String appPassword;
  CacheConfigOptions cache;

  AppCredentials(
    String applicationId,
    String projectId, {
    String functionsURL,
    String databaseURL,
    String appPassword,
    CacheConfigOptions cache,
  }) {
    this.applicationId = applicationId;
    this.projectId = projectId;
    this.functionsURL = functionsURL;
    this.databaseURL = databaseURL;
    this.appPassword = appPassword;
    this.cache = cache;
  }
}

class CacheConfigOptions {
  bool enable;
  String collection;
  String ttlCollection;

  CacheConfigOptions(bool enable, {String collection, String ttlCollection}) {
    this.enable = enable;
    this.collection = collection;
    this.ttlCollection = ttlCollection;
  }
}
