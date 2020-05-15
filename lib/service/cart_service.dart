
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:shopdemo/config/index.dart';
import 'package:shopdemo/model/cart_list_model.dart';
import 'package:shopdemo/model/category_title_model.dart';
import 'package:shopdemo/model/fill_in_order_model.dart';
import 'package:shopdemo/model/goods_detail_model.dart';
import 'package:shopdemo/model/user_model.dart';
import 'package:shopdemo/utils/http_util.dart';

typedef OnSuccessList<T>(List<T> list);

typedef OnSuccess<T>(T t);

typedef OnFail(String message);

class CartService{

  Future addCart(Map<String,dynamic> parameters,OnSuccess onSuccess,{OnFail onFail,Options options}) async{
    try{
      var response;
      if(response==null){
        response = await HttpUtil.instance.post(ServerUrl.CART_ADD,parameters: parameters);
      }else{
        response = await HttpUtil.instance.post(ServerUrl.CART_ADD,parameters: parameters,options: options);
      }
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

  Future queryCart(OnSuccess onSuccess,{OnFail onFail,Options options}) async{
    try{
      var response;
      response = await HttpUtil.instance.get(ServerUrl.CART_LIST,options: options);
      if(response['errno'] == 0){
        CartListModel cartList=CartListModel.fromJson(response['data']);
        onSuccess(cartList);
      }else{
        onFail(response['errmsg']);
      }
    } catch(e){
      print(e);
      onFail(KString.SERVER_EXCEPTION);
    }
  }



  Future deleteCart(OnSuccess onSuccess,OnFail onFail, Map<String,dynamic> parameters) async{
    try{
      var response;
      response = await HttpUtil.instance.post(ServerUrl.CART_DELETE,parameters: parameters);
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

  Future updateCart(OnSuccess onSuccess,Options options,OnFail onFail, Map<String,dynamic> parameters) async{
    try{
      var response;
      response = await HttpUtil.instance.post(ServerUrl.CART_UPDATE,options: options,parameters: parameters);
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

  Future cartCheck(OnSuccess onSuccess,OnFail onFail, Map<String,dynamic> parameters) async{
    try{
      var response;
      response = await HttpUtil.instance.post(ServerUrl.CART_CHECK,parameters: parameters);
      if(response['errno'] == 0){
        CartListModel cartList=CartListModel.fromJson(response['data']);
        onSuccess(cartList);
      }else{
        onFail(response['errmsg']);
      }
    } catch(e){
      print(e);
      onFail(KString.SERVER_EXCEPTION);
    }
  }

  Future getCartDataForFillInOrder(OnSuccess onSuccess,OnFail onFail, Map<String,dynamic> parameters) async{
    try{
      var response;
      response = await HttpUtil.instance.get(ServerUrl.CART_BUY,parameters: parameters);
      if(response['errno'] == 0){
        FillInOrderModel fillInOrderModel=FillInOrderModel.fromJson(response['data']);
        onSuccess(fillInOrderModel);
      }else{
        onFail(response['errmsg']);
      }
    } catch(e){
      print(e);
      onFail(KString.SERVER_EXCEPTION);
    }
  }

  Future fastBuy( Map<String,dynamic> parameters,OnSuccess onSuccess,OnFail onFail) async{
    try{
      var response = await HttpUtil.instance.post(ServerUrl.CART_CHECK,parameters: parameters);
      if(response['errno'] == 0){
        onSuccess(response['data']);
      }else{
        onFail(response['errmsg']);
      }
    } catch(e){
      print(e);
      onFail(KString.SERVER_EXCEPTION);
    }
  }

}
