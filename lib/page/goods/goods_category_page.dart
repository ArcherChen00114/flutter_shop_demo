import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopdemo/config/index.dart';
import 'package:shopdemo/model/category_title_model.dart';
import 'package:shopdemo/model/goods_model.dart';
import 'package:shopdemo/page/goods/goods_list_page.dart';
import 'package:shopdemo/service/goods_service.dart';
import 'package:shopdemo/utils/navigator_util.dart';
import 'package:shopdemo/widget/cached_image_widget.dart';

class GoodsCategoryPage extends StatefulWidget {
  String categoryName;
  int categoryId;

  GoodsCategoryPage({Key key,@required this.categoryName,@required this.categoryId}):super (key:key);

  @override
  _GoodsCategoryPageState createState() => _GoodsCategoryPageState();
}

class _GoodsCategoryPageState extends State<GoodsCategoryPage> with TickerProviderStateMixin{
  ScrollController _scrollController;

  TabController _tabController;

  GoodsService _goodsService=GoodsService();

  CategoryTitleModel _categoryTitleModel;

  List<CategoryModel> brotherCategory=List();

  var categoryFuture;

  var currentIndex=0;

  @override
  void initState() {
    super.initState();
    categoryFuture=_goodsService.getGoodsCategory({"id":widget.categoryId}, (categoryTitles){
      _categoryTitleModel=categoryTitles;

      brotherCategory=_categoryTitleModel.brotherCategory;

      currentIndex=getCurrentIndex();

    }, (error){

    });
  }

  getCurrentIndex(){
    for(int i=0;i<brotherCategory.length;i++){
      if(brotherCategory[i].id==_categoryTitleModel.currentCategory.id){
        return i;
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: categoryFuture,
        builder: (BuildContext context, AsyncSnapshot async){
          _scrollController=ScrollController();
          _tabController=TabController(
            initialIndex: currentIndex,
            length: brotherCategory.length,
            vsync: this,
          );
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.categoryName),
              centerTitle: true,
              bottom: TabBar(
                isScrollable: true,
                controller: _tabController,
                indicatorColor: Colors.white,
                tabs:getTabBars()
              ),
            ),
            body: TabBarView(
              children:getTabBarViews(),
              controller: _tabController,
            ),
          );
        },
      ),
    );
  }

  List<Widget> getTabBars(){
    List<Widget> tabBar=List();
    for(var category in brotherCategory){
      tabBar.add(getTabBarWidget(category));
    }
    return tabBar;
  }
  List<Widget> getTabBarViews(){
    List<Widget> tabBarViews=List();
    for(var i=0;i<brotherCategory.length;i++){
      tabBarViews.add(GoodsListPage(brotherCategory[i].id));
    }
    return tabBarViews;
  }

  Widget getTabBarWidget(CategoryModel categoryModel){
    return Tab(
      text: categoryModel.name,
    );
  }

}
