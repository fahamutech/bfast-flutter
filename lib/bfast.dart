library bfast;

import 'package:bfast/adapter/auth.dart';
import 'package:bfast/adapter/cache.dart';
import 'package:bfast/adapter/storage.dart';
import 'package:bfast/bfast_functions.dart';
import 'package:bfast/bfast_config.dart';
import 'package:bfast/controller/auth.dart';
import 'package:bfast/controller/cache.dart';
import 'package:bfast/controller/rest.dart';
import 'package:bfast/controller/storage.dart';

import 'bfast_database.dart';

class BFast {
  static init(AppCredentials options,
      [String appName = BFastConfig.DEFAULT_APP]) {
    options.cache = CacheConfigOptions(false);
    return BFastConfig.getInstance(options, appName).getAppCredential(appName);
  }

  static BFastConfig getConfig() {
    return BFastConfig.getInstance();
  }

  static const utils = {"USER_DOMAIN_NAME": '_User'};

  static BFastDatabase database([String appName = BFastConfig.DEFAULT_APP]) {
    return BFastDatabase(appName: appName);
  }

  static BFastFunctions functions([String appName = BFastConfig.DEFAULT_APP]) {
    return BFastFunctions(appName: appName);
  }

  static StorageAdapter storage([String appName = BFastConfig.DEFAULT_APP]) {
    return StorageController(BFastHttpClientController(), appName: appName);
  }

  static AuthAdapter auth([String appName = BFastConfig.DEFAULT_APP]) {
    return new AuthController(
        BFastHttpClientController(),
        CacheController(
            appName,
            BFastConfig.getInstance().getCacheDatabaseName(
                BFastConfig.getInstance().DEFAULT_AUTH_CACHE_DB_NAME, appName),
            BFastConfig.getInstance().getCacheCollectionName('cache', appName)),
        appName);
  }

  static CacheAdapter cache(CacheOptions options,
      [String appName = BFastConfig.DEFAULT_APP]) {
    return CacheController(
      appName,
      (options != null && options.database != null)
          ? BFastConfig.getInstance()
              .getCacheDatabaseName(options.database, appName)
          : BFastConfig.getInstance().getCacheDatabaseName(
              BFastConfig.getInstance().DEFAULT_CACHE_DB_NAME, appName),
      (options != null && options.database != null)
          ? BFastConfig.getInstance()
              .getCacheCollectionName(options.collection, appName)
          : BFastConfig.getInstance().getCacheCollectionName('cache', appName),
    );
  }
}
