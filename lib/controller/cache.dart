import 'package:bfast/adapter/cache.dart';
import 'package:bfast/adapter/query.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../bfast_config.dart';

class CacheController extends CacheAdapter {
  String _database;
  String _collection;
  String _appName;

  CacheController(this._appName, this._database, this._collection);

  Future<DatabaseInstance> _getCacheDatabase() async {
    var databaseFactory = databaseFactoryIo;
    StoreRef storeRef = stringMapStoreFactory.store(this._collection);
    if (kIsWeb == true) {
      databaseFactory = databaseFactoryWeb;
      String dbPath = '${this._database}';
      Database db = await databaseFactory.openDatabase(dbPath);
      return DatabaseInstance(db, storeRef);
    } else {
      var databasePah = await sqflite.getDatabasesPath();
      String dbPath = join(databasePah, '${this._database}.db');
      Database db = await databaseFactory.openDatabase(dbPath);
      return DatabaseInstance(db, storeRef);
    }
  }

  // Future<DatabaseInstance> _getTTLStore() async {
  //   if (kIsWeb == true) {
  //     var databaseFactory = databaseFactoryWeb;
  //     String dbPath = '${this._database}_ttl_';
  //     Database db = await databaseFactory.openDatabase(dbPath);
  //     StoreRef storeRef = stringMapStoreFactory.store(this._collection);
  //     return DatabaseInstance(db, storeRef);
  //   } else {
  //     var databaseFactory =
  //         databaseFactoryIo; //getDatabaseFactorySqflite(sqflite.databaseFactory); //
  //     var databasePah = await sqflite.getDatabasesPath();
  //     String dbPath = join(databasePah, '${this._database}_ttl_.db');
  //     StoreRef storeRef = stringMapStoreFactory.store(this._collection);
  //     Database db = await databaseFactory.openDatabase(dbPath);
  //     return DatabaseInstance(db, storeRef);
  //   }
  // }

  // static int _getDayToLeave(int days) {
  //   DateTime date = new DateTime.now();
  //   return date.millisecondsSinceEpoch + (days * 24 * 60 * 60 * 1000);
  // }

  @override
  bool cacheEnabled({RequestOptions options}) {
    if (options != null &&
        options.cacheEnable != null &&
        options.cacheEnable is bool) {
      return options.cacheEnable == true;
    } else {
      return BFastConfig.getInstance()
              .getAppCredential(this._appName)
              .cache
              ?.enable ==
          true;
    }
  }

  @override
  Future<bool> clearAll() async {
    DatabaseInstance databaseInstance = await this._getCacheDatabase();
    await databaseInstance.store.delete(databaseInstance.db);
    await databaseInstance.db.close();
    return true;
  }

  @override
  Future<T> get<T>(String identifier) async {
    DatabaseInstance databaseInstance = await this._getCacheDatabase();
    var res = await databaseInstance.store
        .record(identifier)
        .get(databaseInstance.db);
    await databaseInstance.db.close();
    return res as T;
  }

  @override
  Future<List<K>> keys<K>() async {
    DatabaseInstance databaseInstance = await this._getCacheDatabase();
    var keys = await databaseInstance.store.findKeys(databaseInstance.db);
    await databaseInstance.db.close();
    return keys as List<K>;
  }

  @override
  Future<bool> remove(String identifier, {bool force}) async {
    DatabaseInstance databaseInstance = await this._getCacheDatabase();
    await databaseInstance.store.record(identifier).delete(databaseInstance.db);
    await databaseInstance.db.close();
    return true;
  }

  @override
  Future<T> set<T>(String identifier, T data, {int dtl}) async {
    DatabaseInstance databaseInstance = await this._getCacheDatabase();
    var v1 = await databaseInstance.store
        .record(identifier)
        .put(databaseInstance.db, data, merge: true);
    await databaseInstance.db.close();
    if (v1 != null) {
      return data;
    }
    throw "Fail to save data";
  }
}

class DatabaseInstance {
  Database db;
  StoreRef store;

  DatabaseInstance(this.db, this.store);
}
