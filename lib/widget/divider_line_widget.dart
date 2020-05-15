import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DividerLineWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.grey,
      height: ScreenUtil.instance.setHeight(1),

    );
  }

}