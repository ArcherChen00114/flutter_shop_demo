import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconTextArrowWidget extends StatelessWidget{
  final IconData iconData;
  final String title;
  final VoidCallback callback;
  final Color color;

  IconTextArrowWidget(this.iconData,this.title,this.callback,this.color);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil.getInstance().setHeight(100),
      width: double.infinity,
      child: InkWell(
        onTap: callback,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Icon(iconData,
              size: ScreenUtil.getInstance().setWidth(40),
              color: color,),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: ScreenUtil.getInstance().setWidth(20)
              ),
            ),
            Text(title,
              style: TextStyle(
                fontSize: ScreenUtil.getInstance().setSp(26),
                color: Colors.black54,
              ),
            ),
            Expanded(
              child:Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(right: ScreenUtil.getInstance().setWidth(30)),
                child: Icon(Icons.arrow_forward_ios,
                  size: ScreenUtil.getInstance().setWidth(30),
                  color: Colors.grey,),
              ),
            )
            
          ],
        ),
      ),
    );
  }

}