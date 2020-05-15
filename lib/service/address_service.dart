
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:shopdemo/config/index.dart';
import 'package:shopdemo/model/address_model.dart';
import 'package:shopdemo/model/cart_list_model.dart';
import 'package:shopdemo/model/category_title_model.dart';
import 'package:shopdemo/model/fill_in_order_model.dart';
import 'package:shopdemo/model/goods_detail_model.dart';
import 'package:shopdemo/model/user_model.dart';
import 'package:shopdemo/utils/http_util.dart';

typedef OnSuccessList<T>(List<T> list);

typedef OnSuccess<T>(T t);

typedef OnFail(String message);

class AddressService{

  Future getAddressList(OnSuccessList onSuccessList,{OnFail onFail}) async{
    try{
      var response=await HttpUtil.instance.get(ServerUrl.ADDRESS_LIST);
      if(response['errno'] == 0){
        AddressListModel addressListModel=AddressListModel.fromJson(response['data']);
        print(response['data']);
        onSuccessList(addressListModel.list);
      }else{
        onFail(response['errmsg']);
      }
    } catch(e){
      print(e);
      onFail(KString.SERVER_EXCEPTION);
    }
  }

  Future addAdress(Map<String,dynamic> parameters,OnSuccess onSuccess,OnFail onFail) async{
    try{
      var response= await HttpUtil.instance.post(ServerUrl.ADDRESS_SAVE,parameters: parameters);
      if(response['errno'] == 0){
        onSuccess(KString.SUCCESS);
      }else{
        onFail(response['errmsg']);
      }
    } catch(e){
      print(e);
      onFail(KString.SERVER_EXCEPTION);
    }
  }

  Future deleteAdress(Map<String,dynamic> parameters,OnSuccess onSuccess,OnFail onFail) async{
    try{
      var response= await HttpUtil.instance.post(ServerUrl.ADDRESS_DELETE,parameters: parameters);
      if(response['errno'] == 0){
        onSuccess(KString.SUCCESS);
      }else{
        onFail(response['errmsg']);
      }
    } catch(e){
      print(e);
      onFail(KString.SERVER_EXCEPTION);
    }
  }

  Future addressDetail(Map<String,dynamic> parameters,OnSuccess onSuccess,OnFail onFail) async{
    try{
      var response= await HttpUtil.instance.get(ServerUrl.ADDRESS_DETAIL,parameters: parameters);
      if(response['errno'] == 0){
        AddressModel addressDetail=AddressModel.fromJson(response['data']);
        onSuccess(addressDetail);
      }else{
        onFail(response['errmsg']);
      }
    } catch(e){
      print(e);
      onFail(KString.SERVER_EXCEPTION);
    }
  }


}
