import 'package:flutter/material.dart';
import 'package:shopdemo/config/index.dart';
import 'package:shopdemo/event/category_number_event.dart';
import 'package:shopdemo/model/first_category_model.dart';
import 'package:shopdemo/service/category_service.dart';

class FirstCategoryWidget extends StatefulWidget{
  @override
  _FirstCategoryWidgetState createState() => _FirstCategoryWidgetState();

}

class _FirstCategoryWidgetState extends State<FirstCategoryWidget> {

  CategoryService categoryService = CategoryService();
  List<FirstCategoryModel> firstCategoryList = List();
  int _selectIndex = 0;

  @override
  void initState(){
    super.initState();
    categoryService.getFirstCategoryData((list){
      eventBus.fire(CategoryEvent(list[0].id,list[0].name,list[0].picUrl));
      setState(() {
        firstCategoryList = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: firstCategoryList.length,
        itemBuilder: (BuildContext context, int index){
          return _getFirstLevelItemWidget(firstCategoryList[index],index);
        },
      ),
    );
  }


  _itemClick(int index){
    setState(() {
      _selectIndex = index;
    });
    eventBus.fire(CategoryEvent(
      firstCategoryList[index].id,
      firstCategoryList[index].name,
      firstCategoryList[index].picUrl,
    ));
  }


  Widget _getFirstLevelItemWidget(FirstCategoryModel firstLevelCategoryModel,int index){
    return GestureDetector(
      onTap: () => _itemClick(index),
      child: Container(
        width: 100.0,
        height: 50.0,
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Container(
              height: 48,
              alignment: Alignment.center,
              child: Text(firstLevelCategoryModel.name,
                  style: index == _selectIndex
                      ? TextStyle(
                      fontSize: 14.0, color: KColor.categorySelectedColor)
                      : TextStyle(
                      fontSize: 14.0, color: KColor.categoryDefaultColor)
              ),
            ),
            index == _selectIndex
                ? Divider(
              height: 2.0,
              color: KColor.categorySelectedColor,
            ): Divider(
              height: 1.0,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }


}