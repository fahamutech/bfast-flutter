abstract class RealtimeAdapter {
  void emit({dynamic auth, dynamic payload});

  void listener(void Function(dynamic data) handler);

  void close();
  void open();
}

