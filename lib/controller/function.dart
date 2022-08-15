import 'package:bfast/controller/database.dart';
import 'package:bfast/model/raw_response.dart';

import '../util.dart';

// ((a) -> b) -> map(b.body -> Map)
// impure because it throw error.
Future Function(RawResponse Function() a) executeHttp = compose([
  ifThrow((x) => errorsMessage(x) != '', (x) => errorsMessage(x)),
  executeRule
]);

