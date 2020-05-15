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
            : ListView.builder(
          itemCount: _collect.length,
          itemBuilder: (BuildContext context, int index) {

          },
        ),
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


}