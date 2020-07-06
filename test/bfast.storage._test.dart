import 'package:bfast/adapter/storage.dart';
import 'package:bfast/bfast.dart';
import 'package:bfast/bfast_config.dart';
import 'package:bfast/controller/rest.dart';
import 'package:bfast/controller/storage.dart';
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
  BFast.int(AppCredentials("smartstock_lb", "smartstock"));
  MockHttpClient mockHttpClient = MockHttpClient();

  group("BFast storage", () {
    test("should save a file to bfast cloud", () async {
//      StorageController storageController = StorageController(
//          BFastHttpClientController(),
//          appName: BFastConfig.DEFAULT_APP);
//      SaveFileResponse r = await storageController.save(BFastFile(
//          fileName: 'testflutter.txt',
//          fileType: 'plain/text',
//          data: BFastFileDataMap('aGVsbG8sIHdvcmxkCg==')));
//      print(r?.url);
    });
  });
}
