
import 'package:flutter/foundation.dart';

abstract class RealtimeAdapter {
  void emit({dynamic auth, @required dynamic body});

  void listener(void Function(dynamic data) handler);

  void close();
  void open();
}

