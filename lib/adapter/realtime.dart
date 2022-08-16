import '../options.dart';

abstract class RealtimeAdapter {
  send(App app,String event);
  close(App app, String event);
  receive(App app, String event);
  closeAll();
  closeAllOfApp(App app);
  count(App app);
}
