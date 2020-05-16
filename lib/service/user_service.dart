
import 'package:shopdemo/config/index.dart';
import 'package:shopdemo/model/user_model.dart';
import 'package:shopdemo/utils/http_util.dart';

typedef OnSuccessList<T>(List<T> list);

typedef OnSuccess<T>(T t);

typedef OnFail(String message);

class UserService{

  Future register(Map<String,dynamic> parameters,OnSuccess onSuccess,OnFail onFail) async{
    try{
      var response = await HttpUtil.instance.post(ServerUrl.REGISTER,parameters: parameters);
      if(response['errno'] == 0){
        onSuccess(" ");
      }else{
        onFail(response['errmsg']);
      }
    } catch(e){
      onFail(KString.SERVER_EXCEPTION);
    }
  }

  Future login(Map<String,dynamic> parameters,OnSuccess onSuccess,OnFail onFail) async{
    try{
      var response = await HttpUtil.instance.post(ServerUrl.LOGIN,parameters: parameters);
      if(response['errno'] == 0){
        UserModel userModel=UserModel.fromJson(response['data']);
        onSuccess(userModel);
      }else{
        onFail(response['errmsg']);
      }
    } catch(e){
      onFail(KString.SERVER_EXCEPTION);
    }
  }

  Future loginOut(OnSuccess onSuccess,OnFail onFail) async{
    try{
      var response = await HttpUtil.instance.post(ServerUrl.LOGIN_OUT);
      if(response['errno'] == 0){
        onSuccess(KString.SUCCESS);
      }else{
        onFail(response['errmsg']);
      }
    } catch(e){
      onFail(KString.SERVER_EXCEPTION);
    }
  }
}
