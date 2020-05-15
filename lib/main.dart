import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:provider/provider.dart';
import 'package:shopdemo/config/color.dart';
import 'package:shopdemo/provider/user_info.dart';
import 'package:shopdemo/router/application.dart';
import 'package:shopdemo/router/routers.dart';
import 'package:shopdemo/router/router_handlers.dart';

void main(){
  runApp(ShopApp());
}

class ShopApp extends StatelessWidget{

  ShopApp(){
    final router=Router();
    Routers.configureRouters(router);
    Application.router=router;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_)=> UserInfoProvide(),)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Application.router.generator,
        theme: ThemeData(
          primaryColor: Colors.red,
        ),
      ),
    );
  }
}