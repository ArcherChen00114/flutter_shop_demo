import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopdemo/config/index.dart';
import 'package:shopdemo/model/home_model.dart';
import 'package:shopdemo/service/home_service.dart';
import 'package:shopdemo/utils/shred_preferences.dart';
import 'package:shopdemo/utils/toast_util.dart';
import 'package:shopdemo/widget/loading_dialog_widget.dart';

import 'home_banner.dart';
import 'home_category.dart';
import 'home_product.dart';


class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {



  HomeService _homeService = HomeService();
  HomeModel _homeModel;
  EasyRefreshController _controller = EasyRefreshController();

  @override
  void initState(){
    super.initState();
    SharedPreferencesUtil.getToken().then((token){
    });
    _queryHomeData();
  }

  _queryHomeData(){
    _homeService.queryHomeData((success){
      setState(() {
        _homeModel = success;
      });
      _controller.finishRefresh();
    }, (error){
      ToastUtil.showToast(error);
      _controller.finishRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750,height: 1334)..init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(KString.HOME_TITLE),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: (){},
          ),
        ],
      ),
      body: contentWidget(),
    );
  }


  Widget contentWidget(){
    return _homeModel == null
        ? LoadingDialogWidget()
        : Container(
      child: EasyRefresh(
        controller: _controller,
        header: BezierCircleHeader(backgroundColor: Colors.redAccent),
        footer: BezierBounceFooter(backgroundColor: Colors.redAccent),
        enableControlFinishRefresh: true,
        enableControlFinishLoad: false,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              HomeBannerWidget(_homeModel.banner,_homeModel.banner.length,
                ScreenUtil.instance.setHeight(360.0),),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
              ),
              HomeCategoryWidget(_homeModel.channel),
              Container(
                height: 40.0,
                alignment: Alignment.center,
                child: Text(KString.NEW_PRODUCT),
              ),
              HomeProductWidget(_homeModel.newGoodsList),
              Container(
                height: 40.0,
                alignment: Alignment.center,
                child: Text(KString.HOT_PRODUCT),
              ),
              HomeProductWidget(_homeModel.hotGoodsList),
            ],
          ),
        ),
        onRefresh: () async {
          _queryHomeData();
          _controller.finishRefresh();
        },
      ),
    );
  }
}