import 'package:bfast/adapter/cache.dart';
import 'package:bfast/adapter/query.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast_sqflite/sembast_sqflite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../bfast_config.dart';

class CacheController extends CacheAdapter {
  String _database;
  String _collection;
  String _appName;

  CacheController(String appName, String database, String collection) {
    this._appName = appName;
    this._collection = collection;
    this._database = database;
  }

  Future<DatabaseInstance> _getCacheDatabase() async {
    var databaseFactory = getDatabaseFactorySqflite(sqflite.databaseFactory);
//    Directory appDocDir = await getApplicationDocumentsDirectory();
//    String appDocPath = appDocDir.path;
    String dbPath = '${this._database}.db';
    // getDatabasesPath()
    var db = await databaseFactory.openDatabase(dbPath);
    StoreRef storeRef = stringMapStoreFactory.store(this._collection);
    return DatabaseInstance(db, storeRef);
  }

  Future<DatabaseInstance> _getTTLStore() async {
    var databaseFactory = getDatabaseFactorySqflite(sqflite.databaseFactory);
    String dbPath = '${this._database}_ttl_.db';
    var db = await databaseFactory.openDatabase(dbPath);
    StoreRef storeRef = stringMapStoreFactory.store(this._collection);
    return DatabaseInstance(db, storeRef);
  }

  static int _getDayToLeave(int days) {
    DateTime date = new DateTime.now();
    return date.millisecondsSinceEpoch + (days * 24 * 60 * 60 * 1000);
  }

  @override
  bool cacheEnabled([RequestOptions options]) {
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
    var res = await databaseInstance.store
        .record(identifier)
        .get(databaseInstance.db);
    return res as T;
  }

  @override
  Future<List<String>> keys() async {
    DatabaseInstance databaseInstance = await this._getCacheDatabase();
    return await databaseInstance.store.findKeys(databaseInstance.db);
  }

  @override
  Future<bool> remove(String identifier, [bool force]) async {
    DatabaseInstance ttlDatabaseInstance = await this._getTTLStore();
    DatabaseInstance databaseInstance = await this._getCacheDatabase();
    var ttlRes = await ttlDatabaseInstance.store
        .record(identifier)
        .get(ttlDatabaseInstance.db);
    int dayToLeave = ttlRes as int;
    if ((force != null && force) ||
        (dayToLeave != null &&
            dayToLeave < DateTime.now().millisecondsSinceEpoch)) {
      await databaseInstance.store
          .record(identifier)
          .delete(ttlDatabaseInstance.db);
      await ttlDatabaseInstance.store
          .record(identifier)
          .delete(ttlDatabaseInstance.db);
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<T> set<T>(String identifier, T data, [int dtl]) async {
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
  var db;
  StoreRef store;

  DatabaseInstance(var db, StoreRef store) {
    this.store = store;
    this.db = db;
  }
}

class CacheOptions {
  String database;
  String collection;

  CacheOptions({String database, String collection}) {
    this.database = database;
    this.collection = collection;
  }
}
