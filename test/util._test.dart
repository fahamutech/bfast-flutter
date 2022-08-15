import 'package:bfast/util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Utilities", () {
    group("ifDoElse", () {
      test("should execute do if true", () {
        var one = ifDoElse((_) => true, (a) => 1, (_) => 4);
        expect(one(3), 1);
      });
      test('should execute else if not true', () {
        [false, 1, '', () => {}, {}, 'abc'].forEach((x) {
          var two = ifDoElse((_) => x==true, (a) => 1, (b) => 2);
          expect(two(4), 2);
        });
      });
    });
    group("ifThrow", () {
      test('should throw if true', () {
        try {
          var err = ifThrow((_) => true, (_) => 'err');
          err(1);
        } catch (e) {
          expect(e, 'err');
        }
      });
      test('should return pass if false', () {
        [false, 1, '', () => {}, {}, 'abc'].forEach((x) {
          var pass = ifThrow((_) => x, () => 3);
          expect(pass(2), 2);
        });
      });
    });
    group("combine", () {
      test("combine functions", () async {
        f1(a) => 1 + a;
        f2(b) => b * 2;
        var j = compose([f2, f1]);
        expect(await j(1), 4);
      });
    });
    group("map", () {
      test("should execute a map function", () {
        var to100 = map((x) => 100);
        expect(to100('x'), 100);
      });
    });
  });
}
