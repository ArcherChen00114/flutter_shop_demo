import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shopdemo/config/index.dart';
import 'package:shopdemo/model/order_detail_model.dart';
import 'package:shopdemo/service/order_service.dart';
import 'package:shopdemo/utils/shred_preferences.dart';
import 'package:shopdemo/utils/text_util.dart';
import 'package:shopdemo/utils/toast_util.dart';
import 'package:shopdemo/widget/divider_line_widget.dart';
import 'package:shopdemo/widget/item_text_widget.dart';

class OrderDetailPage extends StatefulWidget {

  var orderId;

  var token;

  OrderDetailPage(this.orderId,this.token);

  @override
  State<StatefulWidget> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {

  OrderService _orderService=OrderService();

  OrderDetailModel _orderDetailModel;

  Future _orderDetailFuture;

  var orderAction;

  var parameters;




  @override
  void initState() {
    super.initState();
    parameters={"orderId":widget.orderId};
    _queryOrderDetail();
  }

  _queryOrderDetail(){
    _orderDetailFuture=_orderService.queryOrderDetail(parameters, (success){
      _orderDetailModel=success;
    }, (error){
      ToastUtil.showToast(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: TextUtil.textWithDefaultStyle(KString.MINE_ORDER_DETAIL),
      ),
      body:FutureBuilder(
        future: _orderDetailFuture,
        builder: (BuildContext context, AsyncSnapshot async) {
          switch (async.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Container(
                child: Center(
                  child: SpinKitFoldingCube(
                    size: 40,
                    color: KColor.watingColor,
                  ),
                ),
              );
              break;
            default:
              if (async.hasError) {
                return Container(
                  child: Center(
                    child: Text(
                      KString.SERVER_EXCEPTION,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }else{
                return _contentWidget();
              }
          }
        }),
    );
  }

  _contentWidget(){
    return Container(
      margin: EdgeInsets.all(ScreenUtil.instance.setWidth(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ItemTextWidget(KString.MINE_ORDER_SN,_orderDetailModel.orderInfo.orderSn),
          DividerLineWidget(),
          ItemTextWidget(KString.MINE_ORDER_TIME,_orderDetailModel.orderInfo.addTime),
          DividerLineWidget(),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil.instance.setWidth(20),),
            height: ScreenUtil.instance.setHeight(80),
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextUtil.textWithStyle(
                    KString.ORDER_INFORMATION, Colors.black54, 26),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Offstage(
                      offstage: _orderDetailModel.orderInfo.handleOption.cancel,
                      child: TextUtil.textWithStyle(KString.MINE_ORDER_ALREADY_CANCEL, KColor.defaultTextColor, 26),
                    ),
                  ),
                ),
              ],
            ),
          ),
          DividerLineWidget(),
          ListView.builder(
            shrinkWrap: true,
            itemCount: _orderDetailModel.orderGoods.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return _goodItemWidget(_orderDetailModel.orderGoods[index]);
            },
          ),
          DividerLineWidget(),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil.instance.setWidth(20),
                top: ScreenUtil.instance.setHeight(20),
                bottom: ScreenUtil.instance.setHeight(20)),
            height: ScreenUtil.instance.setHeight(80),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    TextUtil.textWithStyle(_orderDetailModel.orderInfo.consignee, Colors.black54, 26.0),
                    Padding(padding: EdgeInsets.only(left: ScreenUtil.instance.setWidth(20)),),
                    TextUtil.textWithStyle(_orderDetailModel.orderInfo.mobile, Colors.black54, 26.0),
                  ],
                ),
                TextUtil.textWithStyle(_orderDetailModel.orderInfo.address, Colors.black54, 26.0),
              ],
            ),
          ),
          DividerLineWidget(),
          ItemTextWidget(KString.MINE_ORDER_DETAIL_TOTAL,_orderDetailModel.orderInfo.goodsPrice.toString()),
          DividerLineWidget(),
          ItemTextWidget(KString.FREIGHT,_orderDetailModel.orderInfo.freightPrice.toString()),
          DividerLineWidget(),
          ItemTextWidget(KString.MINE_ORDER_DETAIL_PAYMENTS,_orderDetailModel.orderInfo.actualPrice.toString()),
          DividerLineWidget(),
          Container(
            height: ScreenUtil.instance.setHeight(100),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: MaterialButton(
                    color: KColor.defaultButtonColor,
                    onPressed: (){
                      orderAction=1;_showDialog(orderAction);

                    },
                    child: TextUtil.textWithStyle(KString.CANCEL, Colors.white, 28),
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: ScreenUtil.instance.setWidth(60)),),
                Expanded(
                  child: MaterialButton(
                    color: KColor.defaultButtonColor,
                    onPressed: (){
                      orderAction=2;_showDialog(orderAction);
                    },
                    child: TextUtil.textWithStyle(KString.DELETE, Colors.white, 28),
                  ),
                ),
              ],
            ),
          )

        ],
      ),
    );
  }


  Widget _goodItemWidget(OrderDetailGoodsModel good) {
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


  _showDialog(int index){
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context){
          return AlertDialog(
            title: TextUtil.textWithStyle(KString.TIPS, Colors.black54, 28),
            content: Text(orderAction==1?KString.MINE_ORDER_CANCEL_TIPS:KString.MINE_ORDER_DELETE_TIPS,),
            actions: <Widget>[
              FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: TextUtil.textWithStyle(KString.CANCEL, Colors.black54, 24),
              ),

              FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                  if(orderAction==1){
                    _cancelOrder();
                  }else{
                    _deleteOrder();
                  }
                },
                child: TextUtil.textWithStyle(KString.CONFIRM, Colors.black54, 24),
              ),
            ],
          );
        }
    );
  }

  _deleteOrder(){
    var parameters={"orderId":widget.orderId};
    {
      _orderService.deleteOrder(parameters, (success){
        Navigator.of(context).pop(true);
      }, (error){

      });
    }
  }
  _cancelOrder(){
    var parameters={"orderId":widget.orderId};
    {
      _orderService.cancelOrder(parameters, (success){
        ToastUtil.showToast(KString.MINE_ORDER_CANCEL_SUCCESS);
        setState(() {
          _orderDetailModel.orderInfo.handleOption.cancel=false;
        });
      }, (error){

      });
    }
  }

}