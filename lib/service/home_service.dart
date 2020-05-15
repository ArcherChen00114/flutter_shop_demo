

import 'package:shopdemo/config/index.dart';
import 'package:shopdemo/model/home_model.dart';
import 'package:shopdemo/utils/http_util.dart';

typedef OnSuccessList<T>(List<T> list);

typedef OnSuccess<T>(T t);

typedef OnFail(String message);

class HomeService{

  Future queryHomeData(OnSuccess onSuccess,OnFail onFail) async{
    try{
      var response = await HttpUtil.instance.get(ServerUrl.HOME_URL);
      if(response['errno'] == 0){
        HomeModel homeModel = HomeModel.fromJson(response['data']);
        onSuccess(homeModel);
      }else{
        onFail(response['errmsg']);
      }
    } catch(e){
      onFail(KString.SERVER_EXCEPTION);
    }
  }

}
