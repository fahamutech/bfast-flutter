import 'package:bfast/adapter/transaction.dart';
import 'package:bfast/bfast.dart';
import 'package:bfast/bfast_config.dart';
import 'package:bfast/controller/rest.dart';
import 'package:bfast/controller/transaction.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockHttpClient extends Mock implements http.Client {
  String mockDaasAPi =
      BFastConfig.getInstance().databaseURL(BFastConfig.DEFAULT_APP);
  String mockFaasAPi =
      BFastConfig.getInstance().functionsURL('', BFastConfig.DEFAULT_APP);
}

void main() {
  BFast.init(AppCredentials("smartstock_lb", "smartstock"));
  MockHttpClient mockHttpClient = MockHttpClient();

  // KwTFHsDoH8m3ivAA
  // [{"success":{"objectId":"IrPEp1LZWP6O8R2f","createdAt":"2020-07-06T10:38:03.089Z"}},{"success":{"objectId":"YNpYIn0miOg5JG7t","createdAt":"2020-07-06T10:38:03.089Z"}}]
  group("BFast transaction", () {
    test("should do a transaction on bfast database", () async {
//      TransactionController transactionController = TransactionController(
//          BFastConfig.DEFAULT_APP, BFastHttpClientController(),
//          isNormalBatch: false);
//      var r = await transactionController.createMany<Map>('test', [{"name":"eitan"},{"name":"ageage"}]).commit(
//          before: (transactionsRequests) async {
//            print(transactionsRequests);
//            print('before transaction is called');
//            return transactionsRequests;
//          },
//          after: () async => print('after transaction called'));
//      print(r);
    });
  });
}
