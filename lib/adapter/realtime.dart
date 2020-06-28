abstract class RealtimeAdapter {
  void emit({dynamic auth, dynamic payload});

  void listener(RealtimeListerHandler handler);
}

abstract class RealtimeListerHandler {
  handler({dynamic auth, dynamic payload});
}
