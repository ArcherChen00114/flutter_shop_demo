import 'package:flutter/material.dart';
import 'package:shopdemo/config/index.dart';
import 'package:shopdemo/page/category/first_category.dart';
import 'package:shopdemo/page/category/sub_category.dart';

class CategoryPage extends StatefulWidget{
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(KString.CATEGORY_TITLE),
        centerTitle: true,
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: FirstCategoryWidget(),
            ),
            Expanded(
              flex: 8,
              child: SubCategoryWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
