import 'package:event_bus/event_bus.dart';


EventBus loginEventBus=EventBus();

class LoginEvent{
  bool isLogin;
  String nickname;
  String url;

  LoginEvent(this.isLogin,{this.nickname,this.url});

}


