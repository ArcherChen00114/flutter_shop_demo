
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shopdemo/config/index.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopdemo/model/fill_in_order_model.dart';
import 'package:shopdemo/service/cart_service.dart';
import 'package:shopdemo/service/order_service.dart';
import 'package:shopdemo/utils/fluro_convert_util.dart';
import 'package:shopdemo/utils/navigator_util.dart';
import 'package:shopdemo/utils/shred_preferences.dart';
import 'package:shopdemo/utils/text_util.dart';
import 'package:shopdemo/utils/toast_util.dart';
import 'package:shopdemo/widget/cached_image_widget.dart';
import 'package:shopdemo/widget/item_text_widget.dart';

class FillInOrderPage extends StatefulWidget{

  var cartId;

  FillInOrderPage(this.cartId);

  @override
  State<StatefulWidget> createState() =>_FillInOrderPageState();
}

class _FillInOrderPageState extends State<FillInOrderPage> {

  FillInOrderModel _fillInOrderModel;

  OrderService _orderService=OrderService();

  CartService _cartService=CartService();

  TextEditingController _controller=TextEditingController();

  var token;
  Future fillInOrderFuture;
  Options options=Options();

  @override
  void initState() {
    super.initState();
    SharedPreferencesUtil.getToken().then((onValue){
      token=onValue;
      _getFillInOrder();
    });
  }

  _getFillInOrder(){
    var parameters={
      "cartId":widget.cartId==0? 0:widget.cartId,
      "addressId":0,
    };
    fillInOrderFuture= _cartService.getCartDataForFillInOrder((success){
      setState(() {
        _fillInOrderModel=success;
      });
    }, (error){

    }, parameters);
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fillInOrderFuture,
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
        });
  }

  _contentWidget(){
    return Scaffold(
      appBar: AppBar(
        title: Text(KString.FILL_IN_ORDER),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _addressWidget(),
            Divider(
              height: ScreenUtil.instance.setHeight(1),
              color: Colors.grey[350],
            ),
            _remarkWidget(),
            Divider(
              height: ScreenUtil.instance.setHeight(1),
              color: Colors.grey[350],
            ),
            ItemTextWidget(KString.GOODS_TOTAL,"￥${_fillInOrderModel.goodsTotalPrice}"),
            Divider(
              height: ScreenUtil.instance.setHeight(1),
              color: Colors.grey,
            ),
            ItemTextWidget(KString.FREIGHT,"￥${_fillInOrderModel.freightPrice}"),
            Divider(
              height: ScreenUtil.instance.setHeight(1),
              color: Colors.grey,
            ),
            Column(
              children: _goodsItems(_fillInOrderModel.checkedGoodsList),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          margin: EdgeInsets.only(left: ScreenUtil.instance.setWidth(20)),
          height: ScreenUtil.instance.setHeight(100),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextUtil.textWithDefaultStyle("实付：￥${_fillInOrderModel.orderTotalPrice}"),
              ),
              InkWell(
                onTap: ()=>_submitOrder(),
                child: Container(
                  alignment: Alignment.center,
                  width: ScreenUtil.instance.setWidth(200),
                  height: double.infinity,
                  color: KColor.buyButtonColor,
                  child: TextUtil.textWithStyle(KString.PAY, Colors.white, 28),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _submitOrder(){
    if(_fillInOrderModel.checkedAddress.id==0){
      ToastUtil.showToast(KString.PLEASE_SELECT_ADDRESS);
      return;
    }
    var parameters={
      "cartId":0,
      "addressId":_fillInOrderModel.checkedAddress.id,
      "message":_controller.text,
    };
    _orderService.submitOrder(options, parameters, (success){
      print(success);
      NavigatorUtil.goOrder(context);
      //Navagator to bill page goOrder
    }, (error){
      ToastUtil.showToast(error);
    });
  }

  List<Widget> _goodsItems(List<CheckedGoodsModel> goods){
    List<Widget> list=List();
    for (int listLength=0;listLength<goods.length;listLength++){
      list.add(_goodItem(goods[listLength]));
      list.add(
        Divider(
          height: ScreenUtil.instance.setHeight(1),
          color: Colors.grey,
        ),);
    }
    return list;
  }

  Widget _goodItem(CheckedGoodsModel checkedGoodsModel){
    return Container(
      padding: EdgeInsets.only(left: ScreenUtil.instance.setWidth(20),
      right: ScreenUtil.instance.setWidth(20)),
            height: ScreenUtil.instance.setHeight(180),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CachedImageWidget(
                  ScreenUtil.getInstance().setWidth(140),
                  ScreenUtil.getInstance().setHeight(140),
                  checkedGoodsModel.picUrl,
                ),
                Padding(
                  padding: EdgeInsets.only(left: ScreenUtil.instance.setWidth(10)),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextUtil.textWithStyle(checkedGoodsModel.goodsName, Colors.black54, 26.0),
                    Padding(
                      padding: EdgeInsets.only(
                          top: ScreenUtil.instance.setHeight(6)),
                    ),
                    TextUtil.textWithStyle(checkedGoodsModel.specifications[0], Colors.grey, 22.0),
                    Padding(
                      padding: EdgeInsets.only(
                          top: ScreenUtil.instance.setHeight(10)),
                    ),
                    TextUtil.textWithStyle(checkedGoodsModel.price, Colors.grey, 20.0),
                  ],
                ),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "X${checkedGoodsModel.number}",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: ScreenUtil.instance.setSp(24),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );

  }

  Widget _remarkWidget(){
    return Container(
      height: ScreenUtil.instance.setHeight(80),
      width: double.infinity,
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: ScreenUtil.instance.setHeight(10)),
      padding: EdgeInsets.only(left: ScreenUtil.instance.setWidth(20),
          right: ScreenUtil.instance.setWidth(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextUtil.textWithStyle(KString.REMARK, Colors.black54, 26.0),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: ScreenUtil.instance.setWidth(10)),
              height: ScreenUtil.instance.setHeight(80),
              alignment: Alignment.centerLeft,
              child: TextField(
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: KString.REMARK,
                  hintStyle: TextStyle(
                    color: Colors.grey[350],
                    fontSize: ScreenUtil.instance.setSp(26),
                  ),
                  hasFloatingPlaceholder: false,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: ScreenUtil.instance.setHeight(1),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: ScreenUtil.instance.setHeight(1),
                    ),
                ),
              ),
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: ScreenUtil.instance.setSp(21),
                ),
                controller: _controller,
            ),
          ),
          ),
        ],
      ),

  );
  }

  Widget _addressWidget(){
    return Container(
      height: ScreenUtil.instance.setHeight(120),
      margin: EdgeInsets.all(ScreenUtil.instance.setWidth(10)),
      padding: EdgeInsets.only(
        left: ScreenUtil.instance.setWidth(20),
        right: ScreenUtil.instance.setWidth(20)
      ),
      child: _fillInOrderModel.checkedAddress.id !=0 ?
      InkWell(
        onTap: (){
          NavigatorUtil.goAddress(context);
        },
        child: Row(
          //联系人部分
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    TextUtil.textWithStyle(_fillInOrderModel.checkedAddress.name.toString(),Colors.grey,28.0),
                    Padding(padding: EdgeInsets.only(left: ScreenUtil.instance.setHeight(10)),),
                    TextUtil.textWithStyle(_fillInOrderModel.checkedAddress.tel,Colors.grey,26.0),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: ScreenUtil.instance.setHeight(20)),
                ),
                TextUtil.textWithStyle(_fillInOrderModel.checkedAddress.province
                    +_fillInOrderModel.checkedAddress.city
                    +_fillInOrderModel.checkedAddress.county
                    +_fillInOrderModel.checkedAddress.addressDetail,Colors.grey,26.0),
              ],
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),

      ):
      InkWell(
        onTap: (){NavigatorUtil.goAddress(context).then((value){
          print(value.toString());
          Map<String,dynamic> addressData=Map();
          addressData=FluroConvertUtil.StringToMap(value);
          setState(() {
            _fillInOrderModel.checkedAddress=CheckedAddressModel.fromJson(addressData);
          });
        });
      },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(KString.PLEASE_SELECT_ADDRESS,
            style: TextStyle(
              color: Colors.grey,
              fontSize: ScreenUtil.instance.setSp(30),
            ),),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                ),
              ),
            )

          ],
        ),
      )
    );
  }

}
