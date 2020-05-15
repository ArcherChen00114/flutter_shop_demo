import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopdemo/config/index.dart';

class NoDataWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      alignment: Alignment.center,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset('images/no_data.png',
            height: ScreenUtil.instance.setWidth(120),
            width: ScreenUtil.instance.setHeight(120),),
            Padding(
              padding: EdgeInsets.only(top: ScreenUtil.instance.setHeight(20)),
            ),
            Text(KString.NO_DATA_TEXT,
            style: TextStyle(
              fontSize: ScreenUtil.instance.setSp(28),
              color: KColor.defaultTextColor,
            ),),
          ],
        ),
      ),
    );
  }

}