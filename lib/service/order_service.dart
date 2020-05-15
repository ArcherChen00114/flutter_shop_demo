import 'dart:math';

import 'package:dio/dio.dart';
import 'package:shopdemo/config/index.dart';
import 'package:shopdemo/model/cart_list_model.dart';
import 'package:shopdemo/model/category_title_model.dart';
import 'package:shopdemo/model/fill_in_order_model.dart';
import 'package:shopdemo/model/goods_detail_model.dart';
import 'package:shopdemo/model/order_detail_model.dart';
import 'package:shopdemo/model/order_model.dart';
import 'package:shopdemo/model/user_model.dart';
import 'package:shopdemo/utils/http_util.dart';

typedef OnSuccessList<T>(List<T> list);

typedef OnSuccess<T>(T t);

typedef OnFail(String message);

class OrderService {
  Future submitOrder(Options options, Map<String, dynamic> parameters, OnSuccess onSuccess, OnFail onFail) async {
    try {
      var response = await HttpUtil.instance
          .post(ServerUrl.ORDER_SUBMIT, parameters: parameters,options: options);
      if (response['errno'] == 0) {
        onSuccess(KString.SUCCESS);
      } else {
        onFail(response['errmsg']);
      }
    } catch (e) {
      print(e);
      onFail(KString.SERVER_EXCEPTION);
    }
  }

  Future queryOrder(Map<String, dynamic> parameters,OnSuccess onSuccess, OnFail onFail) async {
    //TODO we need to test if delete parameter will cause any BUG?
    try {
      var response;
      response = await HttpUtil.instance.get(ServerUrl.ORDER_LIST);
      if (response['errno'] == 0) {
        OrderListModel orderListModel =
            OrderListModel.fromJson(response['data']);
        onSuccess(orderListModel.list);
      } else {
        onFail(response['errmsg']);
      }
    } catch (e) {
      print(e);
      onFail(KString.SERVER_EXCEPTION);
    }
  }

  Future deleteOrder(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      var response;
      response = await HttpUtil.instance
          .post(ServerUrl.ORDER_DELETE, parameters: parameters);
      if (response['errno'] == 0) {
        onSuccess(KString.SUCCESS);
      } else {
        onFail(response['errmsg']);
      }
    } catch (e) {
      print(e);
      onFail(KString.SERVER_EXCEPTION);
    }
  }

  Future cancelOrder(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      var response;
      response = await HttpUtil.instance
          .post(ServerUrl.ORDER_CANCEL, parameters: parameters);
      if (response['errno'] == 0) {
        onSuccess(KString.SUCCESS);
      } else {
        onFail(response['errmsg']);
      }
    } catch (e) {
      print(e);
      onFail(KString.SERVER_EXCEPTION);
    }
  }

  Future updateCart(OnSuccess onSuccess, Options options, OnFail onFail,
      Map<String, dynamic> parameters) async {
    try {
      var response;
      response = await HttpUtil.instance.post(ServerUrl.CART_UPDATE,
          options: options, parameters: parameters);
      if (response['errno'] == 0) {
        onSuccess(KString.SUCCESS);
      } else {
        onFail(response['errmsg']);
      }
    } catch (e) {
      print(e);
      onFail(KString.SERVER_EXCEPTION);
    }
  }

  Future queryOrderDetail(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      var response = await HttpUtil.instance
          .get(ServerUrl.ORDER_DETAIL, parameters: parameters);
      if (response['errno'] == 0) {
        OrderDetailModel orderDetailModel =
            OrderDetailModel.fromJson(response['data']);
        onSuccess(orderDetailModel);
      } else {
        onFail(response['errmsg']);
      }
    } catch (e) {
      print(e);
      onFail(KString.SERVER_EXCEPTION);
    }
  }
}
