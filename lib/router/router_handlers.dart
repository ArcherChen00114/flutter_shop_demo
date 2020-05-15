import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:shopdemo/page/goods/goods_category_page.dart';
import 'package:shopdemo/page/goods/goods_detail_page.dart';
import 'package:shopdemo/page/loading/loading_page.dart';
import 'package:shopdemo/page/home/index_page.dart';
import 'package:shopdemo/page/login/login_page.dart';
import 'package:shopdemo/page/login/register_page.dart';
import 'package:shopdemo/page/mine/address_edit_page.dart';
import 'package:shopdemo/page/mine/address_page.dart';
import 'package:shopdemo/page/mine/collect_page.dart';
import 'package:shopdemo/page/order/fill_in_order_page.dart';
import 'package:shopdemo/page/order/order_detail_page.dart';
import 'package:shopdemo/page/order/order_page.dart';
import 'package:shopdemo/utils/fluro_convert_util.dart';
import 'package:shopdemo/utils/string_util.dart';
import 'package:shopdemo/widget/webview_widget.dart';

var homeHandler = Handler(handlerFunc: (BuildContext context,Map<String,List<String>> parameters){
  return IndexPage();
});

var loadingHandler = Handler(handlerFunc: (BuildContext context,Map<String,List<String>> parameters){
  return LoadingPage();
});

var categoryGoodsListHandler = Handler(handlerFunc: (BuildContext context,Map<String,List<String>> parameters){
  var categoryName=StringUtil.decode(parameters['categoryName'].first);
  print('categoryName'+categoryName);
  var categoryId=int.parse(parameters['categoryId'].first);
//TODO goodsListPage
  return GoodsCategoryPage(categoryName: categoryName,categoryId: categoryId,);
});

var webViewHandler = Handler(handlerFunc: (BuildContext context,Map<String,List<String>> parameters){
  var title=FluroConvertUtil.FluroCnParamsDecode(parameters['title'].first);
  var url=FluroConvertUtil.FluroCnParamsDecode(parameters['url'].first);
  return WebviewWidget(url,title);
});

var goodsDetailHandler = Handler(handlerFunc: (BuildContext context,Map<String,List<String>> parameters){
  var goodsId=int.parse(parameters['GoodsId'].first);
  return GoodsDetailPage(goodsId: goodsId,);
});


var fillInOrderHandler = Handler(handlerFunc: (BuildContext context,Map<String,List<String>> parameters){
  var cartId=int.parse(parameters['cartId'].first);
  return FillInOrderPage(cartId);
});


var mineOrderHandler = Handler(handlerFunc: (BuildContext context,Map<String,List<String>> parameters){
  return OrderPage();
});

var goAddressHandler = Handler(handlerFunc: (BuildContext context,Map<String,List<String>> parameters){
  return AddressPage();
});

var addressEditHandler = Handler(handlerFunc: (BuildContext context,Map<String,List<String>> parameters){
  int addressId = int.parse(parameters["addressId"].first);
  return AddressEditPage(addressId);
});

var mineOrderDetailHandler = Handler(handlerFunc: (BuildContext context,Map<String,List<String>> parameters){
  int orderId=int.parse(parameters['orderId'].first);
  var token=parameters['token'].first;
  return OrderDetailPage(orderId,token);
});
var mineCollectHandler = Handler(handlerFunc: (BuildContext context,Map<String,List<String>> parameters){
  return CollectPage();
});

var loginHandler = Handler(handlerFunc: (BuildContext context,Map<String,List<String>> parameters){
  return LoginPage();
});

var registerHandler = Handler(handlerFunc: (BuildContext context,Map<String,List<String>> parameters){
  return RegisterPage();
});