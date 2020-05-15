
import 'package:shopdemo/config/index.dart';
import 'package:shopdemo/model/category_title_model.dart';
import 'package:shopdemo/model/goods_detail_model.dart';
import 'package:shopdemo/model/goods_model.dart';
import 'package:shopdemo/model/user_model.dart';
import 'package:shopdemo/utils/http_util.dart';

typedef OnSuccessList<T>(List<T> list);

typedef OnSuccess<T>(T t);

typedef OnFail(String message);

class GoodsService{

  Future getGoodsCategory(Map<String,dynamic> parameters,OnSuccess onSuccess,OnFail onFail) async{
    try{
      var response = await HttpUtil.instance.get(ServerUrl.GOODS_CATEGORY,parameters: parameters);
      if(response['errno'] == 0){
        CategoryTitleModel categoryTitleModel=CategoryTitleModel.fromJson(response['data']);
        onSuccess(categoryTitleModel);
      }else{
        onFail(response['errmsg']);
      }
    } catch(e){
      print(e);
      onFail(KString.SERVER_EXCEPTION);
    }
  }

  Future getGoodsList(Map<String,dynamic> parameters,OnSuccessList onSuccessList,{OnFail onFail}) async{
    try{
      var responseList=[];
      var response = await HttpUtil.instance.get(ServerUrl.GOODS_LIST,parameters: parameters);
      if(response['errno'] == 0){
        responseList=response['data']['list'];
        GoodsListModel goodsListModel=GoodsListModel.fromJson(responseList);
        onSuccessList(goodsListModel.goodsModels);
      }else{
        onFail(response['errmsg']);
      }
    } catch(e){
      print(e);
      onFail(KString.SERVER_EXCEPTION);
    }
  }

  Future getGoodsDetailData(Map<String,dynamic> parameters,OnSuccess onSuccessList,{OnFail onFail}) async{
    try{
      var response = await HttpUtil.instance.get(ServerUrl.GOODS_DETAILS_URL,parameters: parameters);
      if(response['errno'] == 0){
        GoodsDetailModel goodsDetailModel=GoodsDetailModel.fromJson(response['data']);
        onSuccessList(goodsDetailModel);
      }else{
        onFail(response['errmsg']);
      }
    } catch(e){
      print(e);
      onFail(KString.SERVER_EXCEPTION);
    }
  }

}
