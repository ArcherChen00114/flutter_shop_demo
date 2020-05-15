import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:shopdemo/config/index.dart';
import 'package:shopdemo/model/home_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shopdemo/utils/navigator_util.dart';
import 'package:shopdemo/widget/cached_image_widget.dart';

// ignore: must_be_immutable
class HomeProductWidget extends StatelessWidget{

  List<Goods> productList;

  HomeProductWidget(this.productList);

  _goGoodsDetailView(BuildContext context,Goods goods){
    NavigatorUtil.goGoodsDetailsPage(context, goods.id);
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: productList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.9
          ),
          itemBuilder: (BuildContext context,int index){
            return _getGridViewItem(context, productList[index]);
          }),
    );
  }

  Widget _getGridViewItem(BuildContext context,Goods goods){
    return Container(
      child: InkWell(
        onTap: ()=>_goGoodsDetailView(context, goods),
        child: Card(
          elevation: 2,
          margin: EdgeInsets.all(6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin:EdgeInsets.all(5),
                  child: CachedImageWidget(
                    ScreenUtil.instance.setHeight(200),
                    ScreenUtil.instance.setWidth(200),
                    goods.picUrl
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 4),
                ),
                Container(
                  padding: EdgeInsets.only(left: 4,right: 4),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    goods.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black45,fontSize: 14),
                  ),
                  ),
                Padding(padding: EdgeInsets.only(top: 4),
                ),
                Container(
                  padding: EdgeInsets.only(left: 4,right: 4),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "￥${goods.retailPrice}",
                    style: TextStyle(color:KColor.priceColor,fontSize: 12),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 4),
                ),
                Container(
                  padding: EdgeInsets.only(left: 4,right: 4),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "￥${goods.retailPrice}",
                    style: TextStyle(color:KColor.priceColor,fontSize: 12),
                  ),
                ),

              ],
          ),
        ),
      ),
    );

  }
}