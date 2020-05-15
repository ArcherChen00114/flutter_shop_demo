import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextUtil{
  static Widget textWithStyle(var content,Color inputColor,double textSize){
    content=content.toString();
    return Text(
      content,
      style: TextStyle(
        color: inputColor,
        fontSize: ScreenUtil.instance.setSp(textSize),
      ),
    );
  }

  static Widget textWithDefaultStyle(String content){
    return Text(
      content,
    );
  }



}
