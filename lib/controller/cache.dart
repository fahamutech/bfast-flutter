Future Function(dynamic x) clearAllCache(Function(String c) fn) => (x) => fn(x);

Future Function(dynamic x) getCache(Function(String id) fn) => (x) => fn(x);

Future<List> Function(dynamic x) cacheKeys(Function(String c) fn) =>
    (x) => fn(x);

Future Function(dynamic x) removeCache(Function(String i) fn) => (x) => fn(x);

Future Function(dynamic x) setCache(Function(String data) fn) => (x) => fn(x);
