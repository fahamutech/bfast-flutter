// ( (*)->bool fn, (*)->* fn1, (*)->* fn2) -> x ->  fn1(x) : fn2(x)
Function ifDoElse(
  bool Function(dynamic f) fn,
  Function fn1,
  Function fn2,
) =>
    (x) => fn(x) == true ? fn1(x) : fn2(x);

// [(a->b),(c->d)] -> a -> d
compose(List<Function> fns) => (x) async {
      var _x = x;
      final _reversed = fns.reversed.toList();
      for (Function fn in _reversed) {
        _x = await fn(_x);
      }
      return _x;
    };

// * fn(*) -> a -> fn(a)
map<T>(Function fn) => (x) => fn(x);

// impure, because it throw data
ifThrow(fn1, fn2) => (x) => fn1(x) == true ? throw fn2(x) : x;
