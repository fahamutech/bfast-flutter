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
    if (kIsWeb == true) {
      var databaseFactory = databaseFactoryWeb;
      String dbPath = '${this._database}';
      Database db = await databaseFactory.openDatabase(dbPath);
      StoreRef storeRef = stringMapStoreFactory.store(this._collection);
      return DatabaseInstance(db, storeRef);
    } else {
      var databaseFactory = databaseFactoryIo;
      var databasePah = await sqflite.getDatabasesPath();
      String dbPath = join(databasePah, '${this._database}.db');
      // print(dbPath);
      Database db = await databaseFactory.openDatabase(dbPath);
      StoreRef storeRef = stringMapStoreFactory.store(this._collection);
      return DatabaseInstance(db, storeRef);
    }
  }

  Future<DatabaseInstance> _getTTLStore() async {
    if (kIsWeb == true) {
      var databaseFactory = databaseFactoryWeb;
      String dbPath = '${this._database}_ttl_';
      Database db = await databaseFactory.openDatabase(dbPath);
      StoreRef storeRef = stringMapStoreFactory.store(this._collection);
      return DatabaseInstance(db, storeRef);
    } else {
      var databaseFactory = databaseFactoryIo;
      var databasePah = await sqflite.getDatabasesPath();
      String dbPath = join(databasePah, '${this._database}_ttl_.db');
      Database db = await databaseFactory.openDatabase(dbPath);
      StoreRef storeRef = stringMapStoreFactory.store(this._collection);
      return DatabaseInstance(db, storeRef);
    }
  }

  static int _getDayToLeave(int days) {
    DateTime date = new DateTime.now();
    return date.millisecondsSinceEpoch + (days * 24 * 60 * 60 * 1000);
  }

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
    DatabaseInstance ttlDatabaseInstance = await this._getTTLStore();
    await databaseInstance.store.delete(databaseInstance.db);
    await ttlDatabaseInstance.store.delete(ttlDatabaseInstance.db);
    return true;
  }

  @override
  Future<T> get<T>(String identifier) async {
    await this.remove(identifier);
    DatabaseInstance databaseInstance = await this._getCacheDatabase();
    //print(databaseInstance.store);
    // print(databaseInstance.db);
    var res = await databaseInstance.store
        .record(identifier)
        .get(databaseInstance.db);
    return res as T;
  }

  @override
  Future<List<K>> keys<K>() async {
    DatabaseInstance databaseInstance = await this._getCacheDatabase();
    var keys = await databaseInstance.store.findKeys(databaseInstance.db);
    return keys as List<K>;
  }

  @override
  Future<bool> remove(String identifier, {bool force}) async {
    DatabaseInstance ttlDatabaseInstance = await this._getTTLStore();
    DatabaseInstance databaseInstance = await this._getCacheDatabase();
    var ttlRes = await ttlDatabaseInstance.store
        .record(identifier)
        .get(ttlDatabaseInstance.db);
    int dayToLeave = ttlRes as int;
    if ((force != null && force == true) ||
        (dayToLeave != null &&
            dayToLeave < DateTime.now().millisecondsSinceEpoch)) {
      await databaseInstance.store
          .record(identifier)
          .delete(ttlDatabaseInstance.db);
      await databaseInstance.store
          .record(identifier)
          .delete(databaseInstance.db);
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<T> set<T>(String identifier, T data, {int dtl}) async {
    DatabaseInstance databaseInstance = await this._getCacheDatabase();
    DatabaseInstance ttlDatabaseInstance = await this._getTTLStore();
    await databaseInstance.db.transaction((transaction) async {
      await databaseInstance.store
          .record(identifier)
          .put(transaction, data, merge: true);
    });
    await ttlDatabaseInstance.db.transaction((transaction) async {
      await databaseInstance.store.record(identifier).put(
          transaction, CacheController._getDayToLeave(dtl != null ? dtl : 7),
          merge: true);
    });
    return data;
  }
}

class DatabaseInstance {
  Database db;
  StoreRef store;

  DatabaseInstance(this.db, this.store);
}
