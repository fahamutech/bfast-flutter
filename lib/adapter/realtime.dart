abstract class RealtimeAdapter {
  void emit({dynamic auth, dynamic payload});

  void listener(dynamic Function({dynamic auth, dynamic payload}) handler);

  void close();
  void open();
}

