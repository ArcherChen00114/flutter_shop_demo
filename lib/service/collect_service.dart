
import 'package:shopdemo/config/index.dart';
import 'package:shopdemo/model/collect_list_model.dart';
import 'package:shopdemo/utils/http_util.dart';

typedef OnSuccessList<T>(List<T> list);

typedef OnSuccess<T>(T t);

typedef OnFail(String message);

class CollectService{


  Future queryCollection(Map<String,dynamic> parameters,OnSuccessList onSuccesslist,OnFail onFail) async{
    try{
      var response= await HttpUtil.instance.get(ServerUrl.COLLECT_LIST,parameters: parameters);
      if(response['errno'] == 0){
        CollectListModel collectListModel=CollectListModel.fromJson(response['data']);
        onSuccesslist(collectListModel.list);
      }else{
        onFail(response['errmsg']);
      }
    } catch(e){
      print(e);
      onFail(KString.SERVER_EXCEPTION);
    }
  }

  Future addOrDeleteCollection(Map<String,dynamic> parameters,OnSuccess onSuccess,OnFail onFail) async{
    try{
      var response= await HttpUtil.instance.post(ServerUrl.COLLECT_ADD_DELETE,parameters: parameters);
      if(response['errno'] == 0){
        onSuccess(response['errmsg']);
      }else{
        onFail(response['errmsg']);
      }
    } catch(e){
      print(e);
      onFail(KString.SERVER_EXCEPTION);
    }
  }


}
