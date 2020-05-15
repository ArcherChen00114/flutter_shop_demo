
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shopdemo/config/index.dart';
import 'package:shopdemo/utils/navigator_util.dart';
import 'package:shopdemo/utils/text_util.dart';

class MinePage extends StatefulWidget{


  MinePage();

  @override
  State<StatefulWidget> createState() =>_MinePageState();
}

class _MinePageState extends State<MinePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar:AppBar(
          title: TextUtil.textWithDefaultStyle(KString.EDIT),
        ),
        body:RaisedButton(
          onPressed: (){
            NavigatorUtil.goCollect(context);
          },
        ),
    );
  }

}