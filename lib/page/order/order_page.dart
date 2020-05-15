import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopdemo/config/index.dart';
import 'package:shopdemo/model/order_model.dart';
import 'package:shopdemo/service/order_service.dart';
import 'package:shopdemo/utils/navigator_util.dart';
import 'package:shopdemo/utils/shred_preferences.dart';
import 'package:shopdemo/utils/text_util.dart';
import 'package:shopdemo/utils/toast_util.dart';
import 'package:shopdemo/widget/cached_image_widget.dart';
import 'package:shopdemo/widget/no_data_widget.dart';

class OrderPage extends StatefulWidget {
  OrderPage();

  @override
  State<StatefulWidget> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  OrderService _orderService = OrderService();

  List<OrderModel> _orders = List();

  var _token;

  var _page = 1;

  var _limit = 10;

  @override
  void initState() {
    super.initState();
    SharedPreferencesUtil.getToken().then((onValue) {
      _token = onValue;
      _getOrderData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextUtil.textWithStyle(KString.MINE_ORDER, Colors.white, 35),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        margin: EdgeInsets.all(ScreenUtil.instance.setWidth(20)),
        child: _orders.length == 0
            ? NoDataWidget()
            : ListView.builder(
          itemCount: _orders.length,
          itemBuilder: (BuildContext context, int index) {
            return _orderItemWidget(_orders[index]);
          },
        ),
      ),
    );
  }

  _getOrderData() {
    var parameters = {
      "page": _page,
      "limit": _limit,
    };
    _orderService.queryOrder(parameters, (success) {
      setState(() {
        _orders = success;
      });
    }, (error) {
      ToastUtil.showToast(error);
    });
  }

  Widget _orderItemWidget(OrderModel orderModel) {
    return Card(
      child: InkWell(
        onTap: ()=>_goOrderDeatil(orderModel.id),
        child: Container(
          margin: EdgeInsets.all(ScreenUtil.instance.setWidth(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: ScreenUtil.instance.setHeight(80),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextUtil.textWithStyle(
                        KString.ORDER_TITLE, Colors.black54, 26),
                    Padding(
                      padding: EdgeInsets.only(
                          left: ScreenUtil.instance.setWidth(10)),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextUtil.textWithDefaultStyle(
                                KString.MINE_ORDER_SN +
                                    "${orderModel.orderSn}"),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: ScreenUtil.instance.setWidth(40),
                              color: Colors.grey[350],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: orderModel.goodsList.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return _goodItemWidget(orderModel.goodsList[index]);
                },
              ),
              Container(
                margin: EdgeInsets.only(top: ScreenUtil.instance.setHeight(10)),
                alignment: Alignment.centerRight,
                child: TextUtil.textWithDefaultStyle(
                    KString.MINE_ORDER_TOTAL_GOODS +
                        "${goodNumber(orderModel)}" +
                        KString.MINE_ORDER_GOODS_TOTAL +
                        "合计￥${orderModel.actualPrice}"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int goodNumber(OrderModel orderModel) {
    int number = 0;
    orderModel.goodsList.forEach((good) {
      number += good.number;
    });
    return number;
  }

  _goOrderDeatil(int orderId){
    NavigatorUtil.goOrderDeatil(context, orderId,_token).then((bool){
      _getOrderData();
    });
  }


  Widget _goodItemWidget(OrderGoodsModel good) {
    return Container(
      padding: EdgeInsets.only(left: ScreenUtil.instance.setWidth(20),
          right: ScreenUtil.instance.setWidth(20)),
      height: ScreenUtil.instance.setHeight(180),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.network(
            good.picUrl ?? "",
            width: ScreenUtil.getInstance().setWidth(160),
            height: ScreenUtil.getInstance().setHeight(160),
          ),
          Padding(
            padding: EdgeInsets.only(left: ScreenUtil.instance.setWidth(10)),
          ),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil.instance.setWidth(20),
              top: ScreenUtil.instance.setHeight(20),),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextUtil.textWithStyle(good.goodsName, Colors.black54, 26.0),
                Padding(
                  padding: EdgeInsets.only(
                      top: ScreenUtil.instance.setHeight(10)),
                ),
                TextUtil.textWithStyle(
                    good.specifications[0], Colors.grey, 26.0),
                Padding(
                  padding: EdgeInsets.only(
                      top: ScreenUtil.instance.setHeight(10)),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(
                left: ScreenUtil.instance.setWidth(20),
                right: ScreenUtil.instance.setHeight(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextUtil.textWithStyle("￥${good.price}", Colors.black54, 24),
                  Padding(padding: EdgeInsets.only(top: ScreenUtil.instance.setHeight(20)),),
                  TextUtil.textWithStyle("X${good.number}", Colors.black54, 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}