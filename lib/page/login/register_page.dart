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

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _accountTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  UserService userService = UserService();
  UserModel userModel;
  bool _autovalidator = false;
  final registerFormKey = GlobalKey<FormState>();

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
                  key: registerFormKey,
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
                            onPressed: _register,
                            color: KColor.registerButtonColor,
                            child: Text(KString.REGISTER,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil.instance.setSp(28),
                              ),
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

  _register(){
    if(registerFormKey.currentState.validate()){
      registerFormKey.currentState.save();
      Map<String,dynamic> map=Map();
      map.putIfAbsent('username', ()=>_accountTextController.text.toString());
      map.putIfAbsent('password', ()=>_passwordTextController.text.toString());
      map.putIfAbsent('mobile', ()=>_accountTextController.text.toString());
      map.putIfAbsent('code', ()=>"8888");
      userService.register(map, (success){
        print(success);
        _showToast(KString.REGISTER_SUCCESS);
        NavigatorUtil.popRegister(context);
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

}
