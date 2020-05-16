import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopdemo/config/index.dart';
import 'package:shopdemo/model/collect_list_model.dart';
import 'package:shopdemo/model/order_model.dart';
import 'package:shopdemo/service/collect_service.dart';
import 'package:shopdemo/service/order_service.dart';
import 'package:shopdemo/utils/navigator_util.dart';
import 'package:shopdemo/utils/shred_preferences.dart';
import 'package:shopdemo/utils/text_util.dart';
import 'package:shopdemo/utils/toast_util.dart';
import 'package:shopdemo/widget/cached_image_widget.dart';
import 'package:shopdemo/widget/no_data_widget.dart';

class CollectPage extends StatefulWidget {
  CollectPage();

  @override
  State<StatefulWidget> createState() => _CollectPageState();
}

class _CollectPageState extends State<CollectPage> {
  CollectService _collectService = CollectService();

  List<CollectModel> _collect = List();

  var _token;

  var _page = 1;

  var _limit = 10;

  var _type=0;

  @override
  void initState() {
    super.initState();
    SharedPreferencesUtil.getToken().then((onValue) {
      _token = onValue;
      _queryCollect();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextUtil.textWithStyle(KString.MINE_COLLECT, Colors.white, 35),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        margin: EdgeInsets.all(ScreenUtil.instance.setWidth(20)),
        child: _collect.length == 0
            ? NoDataWidget()
            : GridView.builder(
        itemCount: _collect.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: ScreenUtil.instance.setWidth(10),
            crossAxisSpacing: ScreenUtil.instance.setHeight(10),
        ),
        itemBuilder: (BuildContext context,int index){
          return _getGoodItemWidget(_collect[index],index);
        }),
      ),
    );
  }

  _queryCollect() {
    var parameters = {
      "type":_type,
      "page": _page,
      "limit": _limit,
    };
    _collectService.queryCollection(parameters, (successList) {
      setState(() {
        _collect = successList;
      });
    }, (error) {
      ToastUtil.showToast(error);
    });
  }

  Widget _getGoodItemWidget(CollectModel collect,int index){
    return GestureDetector(
      onTap: ()=>_itemClick(collect,index),
      onLongPress: ()=>_showDeleteDialog(collect,index),
      child: Container(
        alignment: Alignment.center,
        child: SizedBox(
          height: ScreenUtil.instance.setHeight(460),
          width: ScreenUtil.instance.setWidth(320),
          child: Card(
            elevation: 2,
            margin: EdgeInsets.all(6),
            child: Column(
              children: <Widget>[
                Container(
                  margin:EdgeInsets.all(5),
                  child: Image.network(
                      collect.picUrl??"",
                    fit: BoxFit.fill,
                    height: 100,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 5),
                ),
                Text(
                  collect.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black45,fontSize: 14),
                ),
                Padding(padding: EdgeInsets.only(top: 5),
                ),
                TextUtil.textWithStyle("￥${collect.retailPrice}", KColor.priceColor, 14),
                Padding(padding: EdgeInsets.only(top: 4),
                ),
                TextUtil.textWithStyle("￥${collect.retailPrice}", KColor.priceColor,14),
              ],
            ),
          ),
        ),
      ),
    );

  }


  _showDeleteDialog(CollectModel collectModel,int index){
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context){
          return AlertDialog(
            title: TextUtil.textWithStyle(KString.TIPS,Colors.black54,28),
            content: TextUtil.textWithStyle(KString.MINE_CANCEL_COLLECT,Colors.black54,28),
            actions: <Widget>[
              FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child:
                TextUtil.textWithStyle(KString.CANCEL, Colors.grey, 26),
              ),
              FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                  _cancelCollect(collectModel.valueId,index);
                },
                child: TextUtil.textWithStyle(KString.CONFIRM, KColor.defaultTextColor, 26),
              ),
            ],
          );
        }
    );
  }
  _itemClick(CollectModel collect,int index){

  }

  _cancelCollect(int valueId,int index){
    var parameters={
      "type":0,
      "valueId":valueId,

    };
    _collectService.addOrDeleteCollection(parameters,(onSuccess){
      setState(() {
        _collect.removeAt(index);
      });
      ToastUtil.showToast(KString.ADDRESS_DELETE_SUCCESS);
      Navigator.pop(context);
    }, (error){
      ToastUtil.showToast(error);
    });
  }

}