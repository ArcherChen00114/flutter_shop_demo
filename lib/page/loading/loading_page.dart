import 'package:flutter/material.dart';
import 'package:shopdemo/utils/navigator_util.dart';


class LoadingPage extends StatefulWidget{

  @override
  _LoadingPageState createState() => _LoadingPageState();

}

class _LoadingPageState extends State<LoadingPage>{

  @override
  void initState(){
    super.initState();
    Future.delayed(Duration(seconds: 3),(){
      NavigatorUtil.goShopMainPage(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Image.asset(
          "images/loading.png",
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

}