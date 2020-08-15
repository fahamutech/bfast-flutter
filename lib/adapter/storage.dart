//import 'package:bfast/adapter/auth.dart';
//
//class BFastFile {
//  String fileName;
//  String fileType;
//  BFastFileDataMap data;
//
//  BFastFile({String fileName, String fileType, BFastFileDataMap data}) {
//    this.data = data;
//    this.fileName = fileName;
//    this.fileType = fileType;
//  }
//}
//
//class BFastFileDataMap {
//  String base64;
//
//  BFastFileDataMap(String base64) {
//    this.base64 = base64;
//  }
//}
//
//class FileOptions extends AuthOptions {
//  bool forceSecure;
//  Function progress;
//
//  FileOptions(
//      [Function progress,
//      bool forceSecure,
//      bool useMasterKey,
//      String sessionToken])
//      : super(useMasterKey, sessionToken) {
//    this.forceSecure = forceSecure;
//    this.progress = progress;
//  }
//}
//
//class SaveFileResponse {
//  String url;
//
//  SaveFileResponse(String url) {
//    this.url = url;
//  }
//}
