import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopdemo/config/index.dart';
import 'package:shopdemo/model/goods_model.dart';
import 'package:shopdemo/service/goods_service.dart';
import 'package:shopdemo/utils/navigator_util.dart';
import 'package:shopdemo/widget/cached_image_widget.dart';

class GoodsListPage extends StatefulWidget {
  int categoryId;

  GoodsListPage(this.categoryId);

  @override
  _GoodsListPageState createState() => _GoodsListPageState();
}

class _GoodsListPageState extends State<GoodsListPage> {
  GoodsService goodsService = GoodsService();

  List<GoodsModel> goodsModels = List();

  var categoryId;

  _getGoodsData(int categoryId) {
    goodsService.getGoodsList(
        {"categoryId": categoryId, "page": 1, "limit": 100}, (goodsModelList) {
      if (mounted) {
        setState(() {
          goodsModels = goodsModelList;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (goodsModels == null || goodsModels.length == 0) {
      categoryId = widget.categoryId;
      _getGoodsData(categoryId);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: GoodsModel != null && goodsModels.length != 0
              ? GridView.builder(
            itemCount: goodsModels==null? 0:goodsModels.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              childAspectRatio: 1,
            ),
            itemBuilder: (BuildContext context,int index){
              return _getGoodsItemWidget(goodsModels[index]);
            },

          )
              : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "images/no_data.png",
                  height: 80,
                  width: 80,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Text(
                  KString.NO_DATA_TEXT,
                  style: TextStyle(color: KColor.noDataTextColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getGoodsItemWidget(GoodsModel goodsModel) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        child: SizedBox(
          width: 320,
          height: 460,
          child: Card(
            child: Column(
              children: <Widget>[
                CachedImageWidget(
                  double.infinity,
                  ScreenUtil.instance.setHeight(200.0),
                  goodsModel.picUrl,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0),
                ),
                Text(
                  goodsModel.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14.0, color: Colors.black54),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0),
                ),
                Text(
                  "￥${goodsModel.retailPrice}",
                  style: TextStyle(fontSize: 14.0, color: KColor.priceColor),
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () => _itemClick(goodsModel.id),
    );
  }

  _itemClick(int id) {
    NavigatorUtil.goGoodsDetails(context, id);
  }
}
