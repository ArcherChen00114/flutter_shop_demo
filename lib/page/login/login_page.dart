import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopdemo/config/index.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopdemo/event/login_event.dart';
import 'package:shopdemo/model/user_model.dart';
import 'package:shopdemo/service/user_service.dart';
import 'package:shopdemo/utils/navigator_util.dart';
import 'package:shopdemo/utils/shred_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _accountTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  UserService userService = UserService();
  UserModel userModel;
  bool _autovalidator = false;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.centerLeft,
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(30),
                    ScreenUtil().setWidth(0),
                    ScreenUtil().setWidth(30),
                    ScreenUtil().setWidth(0)),
                height: ScreenUtil.instance.setHeight(800),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: ScreenUtil.instance.setHeight(60)),
                      ),
                      Container(
                        margin:
                            EdgeInsets.all(ScreenUtil.instance.setWidth(30)),
                        child: TextFormField(
                          maxLines: 1,
                          maxLength: 11,
                          autovalidate: _autovalidator,
                          keyboardType: TextInputType.phone,
                          validator: _validatorAccount,
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.person,
                              color: KColor.loginIconColor,
                              size: ScreenUtil.instance.setWidth(60),
                            ),
                            hintText: KString.ACCOUNT_HINT,
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: ScreenUtil.instance.setSp(28),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: ScreenUtil.instance.setSp(28),
                            ),
                            labelText: KString.ACCOUNT,
                          ),
                          controller: _accountTextController,
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.all(ScreenUtil.instance.setWidth(30)),
                        child: TextFormField(
                          maxLines: 1,
                          maxLength: 12,
                          autovalidate: _autovalidator,
                          keyboardType: TextInputType.phone,
                          validator: _validatorPassword,
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.lock,
                              color: KColor.loginIconColor,
                              size: ScreenUtil.instance.setWidth(60),
                            ),
                            hintText: KString.PASSWORD_HINT,
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: ScreenUtil.instance.setSp(28),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: ScreenUtil.instance.setSp(28),
                            ),
                            labelText: KString.PASSWORD,
                          ),
                          controller: _passwordTextController,
                        ),
                      ),

                      Container(
                        margin:
                        EdgeInsets.all(ScreenUtil.instance.setWidth(30)),
                        child: SizedBox(
                          height: ScreenUtil.instance.setHeight(80),
                          width: ScreenUtil.instance.setWidth(600),
                          child: RaisedButton(//loginButton
                            onPressed: _login,
                            color: KColor.loginButtonColor,
                            child: Text(KString.LOGIN,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil.instance.setSp(28),
                            ),
                            ),
                          ),
                        ),
                      ),

              Container(
                margin:
                EdgeInsets.all(ScreenUtil.instance.setWidth(20)),
                alignment: Alignment.centerRight,
                child: InkWell(//loginButton
                  onTap:()=>_register(),
                  child: Text(KString.NOW_REGISTER,
                    style: TextStyle(
                      color: KColor.registerTextColor,
                      fontSize: ScreenUtil.instance.setSp(24),
                    ),
                  ),
                ),
              ),


                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _validatorAccount(String value){
    if(value == null|| value.length<11){
      return KString.ACCOUNT_RULE;
    }
    return null;
  }

  String _validatorPassword(String value){
    if(value == null|| value.length<6){
      return KString.PASSWORD_RULE;
    }
    return null;
  }

  _login(){
    if(formKey.currentState.validate()){
      formKey.currentState.save();
      Map<String,dynamic> map=Map();
      map.putIfAbsent('username', ()=>_accountTextController.text.toString());
      map.putIfAbsent('password', ()=>_passwordTextController.text.toString());
      userService.login(map, (success){
        print(success);
        userModel=success;
        _saveUserInfo();
        _showToast(KString.LOGIN_SUCESS);
        loginEventBus.fire(LoginEvent(true,url:userModel.userInfo.avatarUrl,nickname:userModel.userInfo.nickName));
        Navigator.pop(context);
      }, (onFail){
        print(onFail);
        _showToast(onFail);
      });
    }else{
      setState(() {
        _autovalidator=true;
      });
    }
  }

  _showToast(message){
    Fluttertoast.showToast(msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIos: 1,
    backgroundColor: KColor.toastTextColor,
    fontSize: ScreenUtil.instance.setSp(28));
  }

  _register(){
    NavigatorUtil.goRegister(context);
  }

  _saveUserInfo() async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    SharedPreferencesUtil.token=userModel.token;
    await sharedPreferences.setString(KString.TOKEN, userModel.token);
    await sharedPreferences.setString(KString.HEAD_URL, userModel.userInfo.avatarUrl);
    await sharedPreferences.setString(KString.NICK_NAME, userModel.userInfo.nickName);
  }

}
