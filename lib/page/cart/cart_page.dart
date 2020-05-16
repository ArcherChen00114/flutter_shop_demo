
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopdemo/config/index.dart';
import 'package:shopdemo/event/cart_number_event.dart';
import 'package:shopdemo/event/login_event.dart';
import 'package:shopdemo/event/refresh_event.dart';
import 'package:shopdemo/model/cart_list_model.dart';
import 'package:shopdemo/service/cart_service.dart';
import 'package:shopdemo/utils/navigator_util.dart';
import 'package:shopdemo/utils/shred_preferences.dart';
import 'package:shopdemo/utils/toast_util.dart';
import 'package:shopdemo/widget/cached_image_widget.dart';
import 'package:shopdemo/widget/cart_number_widget.dart';

class CartPage extends StatefulWidget{

  @override
  _CartPageState createState() => _CartPageState();

}

class _CartPageState extends State<CartPage>{

  CartService _cartService=CartService();

  List<CartModel> _cartList;

  CartListModel _cartListModel;

  bool _isAllCheck=false;

  double _totalMoney=0.0;

  bool _isLogin=false;

  var token;


  @override
  void initState() {
    super.initState();
    SharedPreferencesUtil.getToken().then((onValue){
      if (onValue==null){
        setState(() {
          _isLogin=false;
        });
      }else{
        token=onValue;
        _getCartData(token);
      }
    });
  }

  _getCartData(token){
    Options options=Options();
    _cartService.queryCart((cartList){
      setState(() {
        _isLogin=true;
        _cartListModel=cartList;
        _cartList=_cartListModel.cartList;
      });
      _isAllCheck=_isCheckedAll();
    },options: options);
  }

  _refreshEvent(){
    eventBus.on<RefreshEvent>().listen((RefreshEvent refreshEvent) => _getCartData(token));
    loginEventBus.on<LoginEvent>().listen((LoginEvent loginEvent){
      if(loginEvent.isLogin){
        _getCartData(SharedPreferencesUtil.token);
      }else{
        setState(() {
          _isLogin=false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _refreshEvent();
    return Scaffold(
      appBar: AppBar(
        title: Text(KString.CART),
        centerTitle: true,
      ),
      body: _isLogin&&_cartList!=null?Container(
        child: _cartList.length!=0?
        Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            ListView.builder(itemBuilder: (BuildContext context, int index){
              return _getCartItemWidget(index);
            },
            itemCount: _cartList.length,),
            Container(
              height: ScreenUtil.instance.setHeight(120),
              decoration: ShapeDecoration(
                shape: Border(
                  top: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Checkbox(
                    value: _isAllCheck,
                    activeColor: KColor.defaultCheckBoxColor,
                    onChanged: (bool){
                      _setCheckedAll(bool);
                    },
                  ),
                  Container(
                    width: ScreenUtil.instance.setWidth(200),
                    child: Text(_isAllCheck
                        ? KString.TOTAL_MONEY + "${_cartListModel.cartTotal.checkedGoodsAmount}"
                        :KString.TOTAL_MONEY + "${_cartListModel.cartTotal.checkedGoodsAmount}"),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: ScreenUtil.instance.setWidth(30),
                      ),
                      alignment: Alignment.centerRight,
                      child: RaisedButton(
                        onPressed: (){
                          _fillInOrder();
                        },
                        color: KColor.defaultButtonColor,
                        child: Text(
                          KString.SETTLEMENT,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil.instance.setSp(26),
                          ),
                        ),

                      ),
                    ),
                  ),
                ],
              ),
            )
          ],


        ):Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("images/no_data.png",
              height: ScreenUtil.instance.setHeight(80),
              width: ScreenUtil.instance.setWidth(80),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              Text(
                KString.NO_DATA_TEXT,
                style: TextStyle(
                  fontSize: ScreenUtil.instance.setSp(16),
                  color: KColor.defaultTextColor
                ),
              )
            ],
          ),
        ),
      ):Center(
        child: RaisedButton(
          color: KColor.defaultButtonColor,
          onPressed: (){
            NavigatorUtil.goLogin(context);
          },
          child: Text(
            KString.LOGIN,
            style: TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil.getInstance().setSp(30),
            ),
          ),
        ),
      ),
    );
  }

  _fillInOrder(){
    NavigatorUtil.goFillInOrderPage(context, 0);
  }

  Widget _getCartItemWidget(int index){
    return Container(
      height: ScreenUtil.getInstance().setHeight(180),
      width: double.infinity,
      child: InkWell(
        onLongPress: ()=>_deleteDialog(index),
        child: Card(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Checkbox(
                value: _cartList[index].checked ?? true,
                activeColor: KColor.defaultCheckBoxColor,
                onChanged: (bool){
                  _checkCart(index,bool);
                },
              ),
              CachedImageWidget(
                ScreenUtil.getInstance().setWidth(140),
                ScreenUtil.getInstance().setHeight(140),
                _cartList[index].picUrl,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    _cartList[index].goodsName,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: ScreenUtil.instance.setSp(24),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: ScreenUtil.instance.setHeight(10)),
                  ),
                  Text(
                    "￥${_cartList[index].price}",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: ScreenUtil.instance.setSp(24),
                    ),
                  ),
                ],
              ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                      Text(
                      "X${_cartList[index].number}",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: ScreenUtil.instance.setSp(24),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: ScreenUtil.instance.setHeight(10)),
                    ),

                    CartNumberWidget(_cartList[index].number,(value){
                      _updateCart(index, value);
                    }),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  _updateCart(int index,int number){
    Options options=Options();
    var parameters={
      "productId":_cartList[index].productId,
      "goodsId":_cartList[index].goodsId,
      "number":number,
      "id":_cartList[index].id,
    };
    _cartService.updateCart((success){
      setState(() {
        _cartList[index].number=number;
        _checkCart(index,_cartList[index].checked ?? true);
        _totalMoney=_cartListModel.cartTotal.checkedGoodsAmount;
      });
    }, options, (error){
      ToastUtil.showToast(error);
      cartNumberEventBus.fire(CartNumberEvent(number-1));
    }, parameters);
  }


  _checkCart(int index,bool isCheck){
    Options options=Options();
    var parameters={
      "productIds":[_cartList[index].productId],
      "isChecked":isCheck ? 1:0,
    };
    _cartService.cartCheck((success){
      setState(() {
        _cartListModel=success;
        _cartList=_cartListModel.cartList;
        _isAllCheck=_isCheckedAll();
      });
      _totalMoney=_cartListModel.cartTotal.checkedGoodsAmount;
    }, (error){
      ToastUtil.showToast(error);
    }, parameters);
  }

  _deleteDialog(int index){
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(KString.TIPS),
          content: Text(KString.DELETE_CART_ITEM_TIPS),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text(KString.CANCEL,
              style: TextStyle(
                color: Colors.black54
              ),),
            ),


            FlatButton(
              onPressed: (){
                _deleteGoods(index);
              },
              child: Text(KString.CONFIRM,
                style: TextStyle(
                    color: KColor.defaultTextColor
                ),),
            ),
          ],
        );
      }
    );


  }

  _deleteGoods(int index){
    var parameters={
      "productIds":[_cartList[index].productId],
    };
    _cartService.deleteCart((success){
      ToastUtil.showToast(KString.DELETE_SUCCESS);
      setState(() {
        _cartList.removeAt(index);
      });
      Navigator.pop(context);
    }, (error){
      ToastUtil.showToast(error);
    }, parameters);
  }


  bool _isCheckedAll(){
    for(int i=0;i<_cartList.length;i++){
      if(_cartList[i].checked==null||!_cartList[i].checked){
        return false;
      }
    }
    return true;
  }

  _setCheckedAll(bool checked){
    setState(() {
      _isAllCheck = checked;
      for(int i=0;i<_cartList.length;i++){
        _cartList[i].checked=checked;
      }
    });
  }
}