import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:shopdemo/router/router_handlers.dart';

class Routers{
  static String root="/";
  static String home="/home";
  static String categoryGoodsList="/categoryGoodsList";
  static String goodsDetail="/goodsDetail";
  static String bannerDetail="/bannerDetail";
  static String register="/register";
  static String login="/login";
  static String mineOrder="/mineOrder";
  static String address="/myAddress";
  static String addressEdit="/addressEdit";
  static String mineCollect="/myCollect";
  static String mineOrderDetail="/mineOrderDetail";
  static String fillInOrder="/fillInOrder";
  static void configureRouters(Router router){

    // ignore: missing_return
    router.notFoundHandler=Handler(handlerFunc: (BuildContext context,Map<String,List<String>> paremeters){
      print("handler not found");
    });
    router.define(root, handler: loadingHandler);
    router.define(home, handler: homeHandler);
    router.define(categoryGoodsList, handler: categoryGoodsListHandler);
    router.define(goodsDetail, handler: goodsDetailHandler);
    router.define(bannerDetail, handler: webViewHandler);
    router.define(register, handler: registerHandler);
    router.define(fillInOrder, handler: fillInOrderHandler);
    router.define(mineOrder, handler: mineOrderHandler);
    router.define(address, handler: goAddressHandler);
    router.define(addressEdit, handler: addressEditHandler);
    router.define(mineCollect, handler: mineCollectHandler);
    router.define(mineOrderDetail, handler: mineOrderDetailHandler);
    router.define(login, handler: loginHandler);
  }



}
