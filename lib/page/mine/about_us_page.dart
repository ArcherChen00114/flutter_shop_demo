

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopdemo/config/index.dart';
import 'package:shopdemo/utils/text_util.dart';
import 'package:shopdemo/widget/divider_line_widget.dart';
import 'package:shopdemo/widget/item_text_widget.dart';

class aboutUsPage extends StatelessWidget{
  aboutUsPage();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: TextUtil.textWithDefaultStyle(KString.MINE_ABOUT_US),
        centerTitle: true,
      ),
      body: Container(
        margin:EdgeInsets.all(ScreenUtil.instance.setWidth(20)),
        child: Column(
          children: <Widget>[
            TextUtil.textWithStyle(KString.MINE_ABOUT_US_CONTENT, Colors.black54, 26),
            Padding(padding: EdgeInsets.all(ScreenUtil.instance.setHeight(10)),),
            DividerLineWidget(),
            ItemTextWidget(KString.MINE_ABOUT_NAME_TITLE,KString.MINE_ABOUT_NAME),
            DividerLineWidget(),
            ItemTextWidget(KString.MINE_ABOUT_EMAIL_TITLE,KString.MINE_ABOUT_EMAIL),
            DividerLineWidget(),
            ItemTextWidget(KString.MINE_ABOUT_TEL_TITLE,KString.MINE_ABOUT_TEL),
          ],
        ),
      ),
    );
  }

}