import 'package:event_bus/event_bus.dart';

/// 创建EventBus
EventBus eventBus = EventBus();

/// Event 修改主题色
class SocketEvent {
  Map msg;
  SocketEvent(this.msg);
}

class InputEvent {
  Map msg;
  InputEvent(this.msg);
}

class HideKeyboard {
  Map msg;
  HideKeyboard(this.msg);
}
