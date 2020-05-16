
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopdemo/config/index.dart';
import 'package:shopdemo/event/login_event.dart';
import 'package:shopdemo/service/user_service.dart';
import 'package:shopdemo/utils/navigator_util.dart';
import 'package:shopdemo/utils/shred_preferences.dart';
import 'package:shopdemo/utils/text_util.dart';
import 'package:shopdemo/utils/toast_util.dart';
import 'package:shopdemo/widget/divider_line_widget.dart';
import 'package:shopdemo/widget/icon_text_arrow_widget.dart';

class MinePage extends StatefulWidget{


  MinePage();

  @override
  State<StatefulWidget> createState() =>_MinePageState();
}

class _MinePageState extends State<MinePage> {
  UserService _userService=UserService();

  var nickname;

  bool isLogin=false;

  var imageHeadUrl;
  @override
  Widget build(BuildContext context) {
    _refreshEvent();
    return Scaffold(
        appBar:AppBar(
          title: TextUtil.textWithDefaultStyle(KString.MINE),
          centerTitle: true,
        ),
        body:Column(
          children: <Widget>[
            Container(
              height: ScreenUtil.instance.setHeight(160),
              width: double.infinity,
              alignment: Alignment.center,
              child: isLogin?
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //头像+名字+退出登录按钮

                  Container(
                    width: ScreenUtil.instance.setWidth(60),
                    height: ScreenUtil.instance.setHeight(60),
                    margin: EdgeInsets.only(left: ScreenUtil.instance.setWidth(20)),
                    child: CircleAvatar(
                      radius: 30,
                      foregroundColor: Colors.redAccent,
                      backgroundImage: NetworkImage(
                          imageHeadUrl,
                          
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: ScreenUtil.instance.setWidth(10)),),
                  TextUtil.textWithStyle(nickname, KColor.defaultButtonColor, 26),
                  Expanded(
                    child: InkWell(
                      onTap: ()=>_logOutDialog(),
                    child: Offstage(
                      offstage: !isLogin,
                      child: Container(
                        padding: EdgeInsets.only(right: ScreenUtil.instance.setWidth(30),),
                        alignment: Alignment.centerRight,
                        child:
                        TextUtil.textWithStyle(KString.LOGIN_OUT, Colors.black54, 26),
                      ),
                    ),
                    ),
                  )
                ],
              ):
              InkWell(
                onTap: ()=>_toLogin(),
                child: TextUtil.textWithStyle(KString.CLICK_LOGIN, Colors.black54, 30),
              ),

            ),
            Padding(padding: EdgeInsets.only(top: ScreenUtil.instance.setHeight(20)),),
            DividerLineWidget(),
            IconTextArrowWidget(KIcon.ORDER,KString.ORDER,_order,Colors.deepPurpleAccent),
            DividerLineWidget(),
            IconTextArrowWidget(KIcon.COLLECTION,KString.COLLECTION,_collect,Colors.red),
            DividerLineWidget(),
            IconTextArrowWidget(KIcon.ADDRESS,KString.ADDRESS,_address,Colors.amber),
            DividerLineWidget(),
            IconTextArrowWidget(KIcon.ABOUT_US,KString.ABOUT_US,_aboutUs,Colors.teal),
          ],
        ),
    );
  }


  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  _getUserInfo(){
    SharedPreferencesUtil.getToken().then((token){
      if(token !=null){
        setState(() {
          isLogin=true;
        });
        SharedPreferencesUtil.getImageHead().then((imageHeadAddress){
          setState(() {
            imageHeadUrl=imageHeadAddress;
          });
        });
        SharedPreferencesUtil.getUserName().then((name){
          setState(() {
            nickname=name;
          });
        });
      }
    });
  }


  _refreshEvent(){
    loginEventBus.on<LoginEvent>().listen((LoginEvent loginEvent){
      if(loginEvent.isLogin){
        setState(() {
          isLogin=true;
          imageHeadUrl=loginEvent.url;
          nickname=loginEvent.nickname;
        });
      }else{
        setState(() {
          isLogin=false;
        });
      }
    });
  }


  _logOutDialog(){
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context){
          return AlertDialog(
            title: TextUtil.textWithStyle(KString.TIPS,Colors.black54,28),
            content: TextUtil.textWithStyle(KString.LOGIN_OUT_TIPS,Colors.black54,30),
            actions: <Widget>[
              FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child:
                TextUtil.textWithStyle(KString.CANCEL, Colors.black54, 26),
              ),
              FlatButton(
                onPressed: ()=>_logOut(),
                child: TextUtil.textWithStyle(KString.CONFIRM, KColor.defaultTextColor, 26),
              ),
            ],
          );
        }
    );
  }

  _logOut(){
    _userService.loginOut((success){
      loginEventBus.fire(LoginEvent(false));
    }, (error){
      loginEventBus.fire(LoginEvent(false));
      ToastUtil.showToast(error);
    });
    Navigator.pop(context);
  }

  void _order(){
    if(isLogin){
      NavigatorUtil.goOrder(context);
    }else{
      _toLogin();
    }
  }
  void _collect(){
    if(isLogin){
      NavigatorUtil.goCollect(context);
    }else{

    }
  }
  void _toLogin(){
    NavigatorUtil.goLogin(context);
  }
  void _address(){
    if(isLogin){
      NavigatorUtil.goAddress(context);
    }else{

    }

  }
  void _aboutUs(){
    if(isLogin){
      NavigatorUtil.goAboutUs(context);
    }else{

    }

  }

}