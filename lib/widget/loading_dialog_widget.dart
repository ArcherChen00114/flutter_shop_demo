
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shopdemo/config/index.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingDialogWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>_LoadingDialogWidgetState();
  }

  class _LoadingDialogWidgetState extends State<LoadingDialogWidget> {
    @override
    Widget build(BuildContext context) {
      return Container(
        child: Center(
          child: SpinKitFoldingCube(
            size: ScreenUtil.instance.setWidth(60),
            color: KColor.watingColor,
          ),
        ),
      );
    }
  }
