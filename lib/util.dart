// ( (*)->bool fn, (*)->* fn1, (*)->* fn2) -> x ->  fn1(x) : fn2(x)
Function(dynamic) ifDoElse(
  Function(dynamic f) fn,
  Function(dynamic f1) fn1,
  Function(dynamic f2) fn2,
) =>
    (x) => fn(x) == true ? fn1(x) : fn2(x);

// [(a->b),(c->d)] -> a -> d
Function(dynamic x) compose(List<Function> fns) => (x) {
      var _x = x;
      final _reversed = fns.reversed.toList();
      for (Function fn in _reversed) {
        _x = fn(_x);
      }
      return _x;
    };

// [(a->b),(c->d)] -> a -> d
Future Function(dynamic x) composeAsync(List<Function> fns) => (x) async {
      var _x = x;
      final _reversed = fns.reversed.toList();
      for (Function fn in _reversed) {
        _x = await fn(_x);
      }
      return _x;
    };

// * fn(*) -> a -> fn(a)
Function(dynamic x) map<T>(Function fn) => (x) => fn(x);

// impure, because it throw data
Function(dynamic x) ifThrow(fn1, fn2) => (x) => fn1(x) == true ? throw fn2(x) : x;
