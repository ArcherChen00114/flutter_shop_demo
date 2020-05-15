import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:shopdemo/config/index.dart';
import 'package:shopdemo/model/home_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shopdemo/utils/navigator_util.dart';
import 'package:shopdemo/widget/cached_image_widget.dart';

class HomeCategoryWidget extends StatelessWidget{

  List<Channel> categoryList;

  HomeCategoryWidget(this.categoryList);

  _goCategoryView(BuildContext context,Channel channel){
    NavigatorUtil.goCategoryGoodsListPage(context, channel.name, channel.id);
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: categoryList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: ScreenUtil.instance.setWidth(20),
            crossAxisSpacing: ScreenUtil.instance.setWidth(20),
          ),
          itemBuilder: (BuildContext context,int index){
            return _getGridViewItem(context, categoryList[index]);
          }),
    );
  }

  Widget _getGridViewItem(BuildContext context,Channel channel){
    return Center(
      child: InkWell(
        onTap: ()=> _goCategoryView(context, channel),
        child: Column(
          children: <Widget>[
            CachedImageWidget(
              ScreenUtil.instance.setWidth(60),
              ScreenUtil.instance.setHeight(60),
              channel.iconUrl,
            ),
            Padding(
              padding: EdgeInsets.only(top: ScreenUtil.instance.setWidth(10)),
            ),
            Text(
              channel.name,
              style: TextStyle(
                fontSize: ScreenUtil.instance.setSp(26),
                color: Colors.black26
              ),
            )
          ],
        ),
      ),
    );

  }
}