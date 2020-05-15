import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemTextWidget extends StatelessWidget{

  var leftText;
  var rightText;
  VoidCallback callback;
  ItemTextWidget(this.leftText,this.rightText,{this.callback});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        callback();
      },
      child: Container(
        padding: EdgeInsets.only(
          left: ScreenUtil.instance.setWidth(20),
          right: ScreenUtil.instance.setWidth(20),
        ),
        height: ScreenUtil.instance.setHeight(80),
        child: Row(
          children: <Widget>[
            Text(
              leftText,
              style: TextStyle(
                color: Colors.black26,
                fontSize: ScreenUtil.instance.setSp(27)
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child:Text(
                  rightText,
                  style: TextStyle(
                      color: Colors.black26,
                      fontSize: ScreenUtil.instance.setSp(27)
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}