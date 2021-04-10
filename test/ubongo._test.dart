import 'package:bfast/bfast.dart';
import 'package:bfast/bfast_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  TestWidgetsFlutterBinding.ensureInitialized();
  group("Test ubongo", (){
    BFast.init(AppCredentials('ubongokids', 'ubongokids'));
    test("save object", () async {
      var response = await BFast.database()
          .domain('content')
          .save({"name": "test category"});
      print(response);
    });
  });
}