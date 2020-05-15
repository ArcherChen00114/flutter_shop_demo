import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopdemo/event/category_number_event.dart';
import 'package:shopdemo/model/sub_category_model.dart';
import 'package:shopdemo/service/category_service.dart';
import 'package:shopdemo/utils/navigator_util.dart';

class SubCategoryWidget extends StatefulWidget {
  @override
  _SubCategoryWidgetState createState() => _SubCategoryWidgetState();
}

class _SubCategoryWidgetState extends State<SubCategoryWidget> {
  CategoryService categoryService = CategoryService();
  List<SubCategoryModel> subCategoryModels = List();

  var categoryName, categoryImage, categoryId;
  bool flag = true;

  @override
  void initState() {
    super.initState();
  }

  _listener(){
    eventBus.on<CategoryEvent>().listen((CategoryEvent event) => _updateView(event));
  }

  _updateView(CategoryEvent categoryEvent){
    if(flag){
      flag = false;
      setState(() {
        categoryName = categoryEvent.categoryName;
        categoryImage = categoryEvent.categoryImage;
        categoryId = categoryEvent.id;
      });
      _getSubCategory(categoryEvent.id);
    }
  }

  _getSubCategory(int id){
    var params = {"id":id};
    print(params);
    print("_getSubCategory");
    categoryService.getSubCategoryData(params, (subCategoryModelList){
      flag = true;
      setState(() {
        subCategoryModels = subCategoryModelList;
      });
    }, (value){});
  }


  @override
  Widget build(BuildContext context) {
    _listener();
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(ScreenUtil.instance.setWidth(20.0)),
            height: ScreenUtil.instance.setHeight(200.0),
            child: categoryImage != null ? Image.network(
              categoryImage,
              fit: BoxFit.fill,
            ) : Container(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4.0),
          ),
          Center(
            child: Text(
              categoryName ?? "",
              style: TextStyle(fontSize: 14.0,color: Colors.black54),
            ),
          ),
          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: subCategoryModels.length,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 20.0,
              childAspectRatio: 0.85,
              crossAxisSpacing: 20.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              return getItemWidget(subCategoryModels[index]);
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
        ],
      ),
    );
  }

  _itemClick(int id) {
    NavigatorUtil.goCategoryGoodsListPage(context, categoryName, id);
  }

  Widget getItemWidget(SubCategoryModel categoryModel) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        child: Column(children: <Widget>[
          Image.network(
            categoryModel.picUrl ?? "",
            fit: BoxFit.fill,
            height: 60,
          ),
          Text(
            categoryModel.name,
            style: TextStyle(fontSize: 14.0, color: Colors.black54),
          ),
        ]),
      ),
      onTap: () => _itemClick(categoryModel.id),
    );
  }
}
