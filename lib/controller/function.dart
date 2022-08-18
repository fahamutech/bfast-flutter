import 'package:bfast/controller/database.dart';

import '../util.dart';

// ((a) -> b) -> map(b.body -> Map)
// impure because it throw error.
// Future Function(RawResponse Function() httpRequest)
var executeHttp = composeAsync([
  ifThrow((x) => errorsMessage(x) != '', (x) => errorsMessage(x)),
  executeRule
]);
