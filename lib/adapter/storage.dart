import 'package:bfast/adapter/auth.dart';

abstract class StorageAdapter {
  String getData();

  save(BFastFile file, [FileOptions options]);
}

class BFastFile {}

class FileOptions extends AuthOptions {
  bool forceSecure;
  Function progress;

  FileOptions(
      [Function progress,
      bool forceSecure,
      bool useMasterKey,
      String sessionToken]): super(useMasterKey, sessionToken){
    this.forceSecure = forceSecure;
    this.progress = progress;
  }
}
