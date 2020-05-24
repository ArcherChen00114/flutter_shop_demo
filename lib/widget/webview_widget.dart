import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WebviewWidget extends StatelessWidget{

  var url;
  var title;

  String replceLocalhost(String url){
    return url.replaceAll("localhost", "119.45.140.181");
  }

  WebviewWidget(this.url,this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: WebviewScaffold(
        url: replceLocalhost(url),
        withZoom: false,
        withLocalStorage: true,
        withJavascript: true,
      ),
    );
  }
}