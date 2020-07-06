import 'package:bfast/adapter/domain.dart';
import 'package:bfast/adapter/transaction.dart';
import 'package:bfast/controller/cache.dart';
import 'package:bfast/controller/domain.dart';
import 'package:bfast/controller/rest.dart';
import 'package:bfast/controller/transaction.dart';

import 'bfast_config.dart';

class BFastDatabase {
  String _appName;

  BFastDatabase({String appName = BFastConfig.DEFAULT_APP}) {
    this._appName = appName;
  }

  DomainAdapter domain(String domainName) {
    return DomainController(
        domainName,
        CacheController(
          this._appName,
          BFastConfig.getInstance().getCacheDatabaseName(
              BFastConfig.getInstance().DEFAULT_CACHE_DB_NAME, this._appName),
          BFastConfig.getInstance()
              .getCacheCollectionName(domainName, this._appName),
        ),
        new BFastHttpClientController(),
        this._appName);
  }

  DomainAdapter collection(String collectionName) {
    return this.domain(collectionName);
  }

  DomainAdapter table(String tableName) {
    return this.domain(tableName);
  }

  TransactionAdapter transaction([bool isNormalBatch]) {
    return TransactionController(this._appName, new BFastHttpClientController(),
        isNormalBatch: isNormalBatch);
  }
}
