import 'package:bfast/controller/auth.dart';
import 'package:bfast/controller/cache.dart';
import 'package:bfast/controller/database.dart';
import 'package:bfast/controller/rest.dart';
import 'package:bfast/controller/rules.dart';
import 'package:bfast/controller/transaction.dart';

import 'bfast_config.dart';

class BFastDatabase {
  String appName;

  BFastDatabase({this.appName = BFastConfig.DEFAULT_APP});

  DatabaseController domain(String domainName) {
    CacheController authCache = CacheController(
        this.appName,
        BFastConfig.getInstance().getCacheDatabaseName(
            BFastConfig.getInstance().DEFAULT_AUTH_CACHE_DB_NAME(),
            this.appName),
        BFastConfig.getInstance()
            .getCacheCollectionName('cache', this.appName));
    var restController = BFastHttpClientController();
    var authController =
        AuthController(restController, authCache, this.appName);
    var rulesController = RulesController(authController);
    return DatabaseController(domainName, restController, authController,
        rulesController, this.appName);
  }

  DatabaseController collection(String collectionName) {
    return this.domain(collectionName);
  }

  DatabaseController table(String tableName) {
    return this.domain(tableName);
  }

  TransactionController transaction([bool isNormalBatch]) {
    var authCache = CacheController(
        this.appName,
        BFastConfig.getInstance().getCacheDatabaseName(
            BFastConfig.getInstance().DEFAULT_AUTH_CACHE_DB_NAME(),
            this.appName),
        BFastConfig.getInstance()
            .getCacheCollectionName('cache', this.appName));
    var restController = BFastHttpClientController();
    var authController =
        AuthController(restController, authCache, this.appName);
    var rulesController = RulesController(authController);
    return TransactionController(this.appName, restController, rulesController);
  }
}
