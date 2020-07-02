library bfast;

import 'package:bfast/adapter/auth.dart';
import 'package:bfast/adapter/cache.dart';
import 'package:bfast/adapter/storage.dart';
import 'package:bfast/bfast_functions.dart';
import 'package:bfast/configuration.dart';
import 'package:bfast/controller/auth.dart';
import 'package:bfast/controller/cache.dart';
import 'package:bfast/controller/rest.dart';
import 'package:bfast/controller/storage.dart';

class BFast {
  static int(AppCredentials options,
      [String appName = BFastConfig.DEFAULT_APP]) {
    options.cache = CacheConfigOptions(false);
    return BFastConfig.getInstance(options, appName).getAppCredential(appName);
  }

  static BFastConfig getConfig() {
    return BFastConfig.getInstance();
  }

  static const utils = {"USER_DOMAIN_NAME": '_User'};

  static BFastFunctions functions([String appName = BFastConfig.DEFAULT_APP]) {
    return BFastFunctions(appName: appName);
  }

  static StorageAdapter storage([String appName = BFastConfig.DEFAULT_APP]) {
    return StorageController(DartHttpClientController(), appName: appName);
  }

  static AuthAdapter auth([String appName = BFastConfig.DEFAULT_APP]) {
    return new AuthController(
        DartHttpClientController(),
        CacheController(
            appName,
            BFastConfig.getInstance().getCacheDatabaseName(
                BFastConfig.getInstance().DEFAULT_AUTH_CACHE_DB_NAME, appName),
            BFastConfig.getInstance().getCacheCollectionName('cache', appName)),
        appName);
  }

  static CacheAdapter cache([String appName = BFastConfig.DEFAULT_APP]) {}
}
