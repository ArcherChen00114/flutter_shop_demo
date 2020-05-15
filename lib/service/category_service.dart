
import 'package:shopdemo/config/index.dart';
import 'package:shopdemo/model/first_category_model.dart';
import 'package:shopdemo/model/sub_category_model.dart';
import 'package:shopdemo/utils/http_util.dart';

typedef OnSuccessList<T>(List<T> list);

typedef OnSuccess<T>(T t);

typedef OnFail(String message);

class CategoryService{

  Future getFirstCategoryData(OnSuccessList onSuccessList,{OnFail onFail}) async{
    try{
      var responseList=[];
      var response = await HttpUtil.instance.get(ServerUrl.CATEGORY_FIRST);
      if(response['errno'] == 0){
        responseList=response['data'];
        FirstListCategoryModel firstLevelCategoryModel = FirstListCategoryModel.fromJson(responseList);
        onSuccessList(firstLevelCategoryModel.firstLevelCategory);
      }else{
        onFail(response['errmsg']);
      }
    } catch(e){
      onFail(KString.SERVER_EXCEPTION);
    }
  }

  Future getSubCategoryData(Map<String,dynamic> parameters,OnSuccessList onSuccessList,OnFail onFail) async{
    try{
      var responseList=[];
      var response = await HttpUtil.instance.get(ServerUrl.CATEGORY_SECOND,parameters: parameters);
      if(response['errno'] == 0){
        responseList=response['data'];
        SubCategoryListModel subCategoryListModel = SubCategoryListModel.fromJson(responseList);
        onSuccessList(subCategoryListModel.subCategoryModels);
      }else{
        onFail(response['errmsg']);
      }
    } catch(e){
      onFail(KString.SERVER_EXCEPTION);
    }
  }

}
