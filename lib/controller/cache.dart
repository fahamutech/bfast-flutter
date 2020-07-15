import 'dart:io';

import 'package:bfast/adapter/cache.dart';
import 'package:bfast/adapter/query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

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
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String dbPath = '$appDocPath/${this._database}.db';
    DatabaseFactory dbFactory = databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbPath);
    StoreRef storeRef = stringMapStoreFactory.store(this._collection);
    return DatabaseInstance(db, storeRef);
  }

  Future<DatabaseInstance> _getTTLStore() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String dbPath = '$appDocPath/${this._database}_ttl_.db';
    DatabaseFactory dbFactory = databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbPath);
    // BFastConfig.getInstance().DEFAULT_CACHE_TTL_COLLECTION_NAME
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
    return databaseInstance.store.record(identifier).get(databaseInstance.db)
        as T;
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
    int dayToLeave = ttlDatabaseInstance.store
        .record(identifier)
        .get(ttlDatabaseInstance.db) as int;
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
  Database db;
  StoreRef store;

  DatabaseInstance(Database db, StoreRef store) {
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
