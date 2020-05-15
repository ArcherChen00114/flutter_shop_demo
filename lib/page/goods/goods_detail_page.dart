import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopdemo/config/index.dart';
import 'package:shopdemo/event/refresh_event.dart';
import 'package:shopdemo/model/category_title_model.dart';
import 'package:shopdemo/model/goods_detail_model.dart';
import 'package:shopdemo/page/goods/goods_detail_gallery.dart';
import 'package:shopdemo/page/goods/goods_list_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shopdemo/service/cart_service.dart';
import 'package:shopdemo/service/goods_service.dart';
import 'package:shopdemo/utils/navigator_util.dart';
import 'package:shopdemo/utils/shred_preferences.dart';
import 'package:shopdemo/utils/toast_util.dart';
import 'package:shopdemo/widget/cached_image_widget.dart';
import 'package:shopdemo/widget/cart_number_widget.dart';

class GoodsDetailPage extends StatefulWidget {
  int goodsId;

  GoodsDetailPage({Key key, @required this.goodsId}) : super(key: key);

  @override
  _GoodsDetailPageState createState() => _GoodsDetailPageState();
}

class _GoodsDetailPageState extends State<GoodsDetailPage>
    with TickerProviderStateMixin {
  int goodsId;

  GoodsService _goodsService = GoodsService();

  CartService _cartService = CartService();

  GoodsDetailModel _goodsDetail;

  var parameters;

  int _specificationIndex = 0;

  int _number = 1;

  var _goodsDetailFuture;

  var token;

  var _isCollection = false;

  //Todo CartService
  //todo CollectionService

  @override
  void initState() {
    super.initState();
    goodsId = widget.goodsId;
    var params = {"id": goodsId};
    _goodsDetailFuture =
        _goodsService.getGoodsDetailData(params, (goodsDetail) {
      _goodsDetail = goodsDetail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text(KString.GOODS_DETAIL),
          centerTitle: true,
        ),
        body: FutureBuilder(
            future: _goodsDetailFuture,
            builder: (BuildContext context, AsyncSnapshot async) {
              switch (async.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Container(
                    child: Center(
                      child: SpinKitFoldingCube(
                        size: 40,
                        color: KColor.watingColor,
                      ),
                    ),
                  );
                  break;
                default:
                  if (async.hasError) {
                    return Container(
                      child: Center(
                        child: Text(
                          KString.SERVER_EXCEPTION,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  }
              }
              return _detailWidget();
            }),
        bottomNavigationBar: BottomAppBar(
            child: Container(
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () => _isCollection == false
                        ? _collection()
                        : _addOrDeleteCollect(),
                    child: Icon(
                      Icons.star_border,
                      color: _isCollection
                          ? KColor.collectionButtonColor
                          : KColor.unCollectionButtonColor,
                      size: 30,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Icon(
                  Icons.add_shopping_cart,
                  color: KColor.addCartIconColor,
                  size: 30,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  color: KColor.addCartButtonColor,
                  child: InkWell(
                    onTap: () => openBottomSheet(
                        context, _goodsDetail.productList[0], 1),
                    child: Center(
                      child: Text(
                        KString.ADD_CART,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  color: KColor.buyButtonColor,
                  child: InkWell(
                    onTap: () => openBottomSheet(
                        context, _goodsDetail.productList[0], 0),
                    child: Center(
                      child: Text(
                        KString.BUY,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  Widget _detailWidget() {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        ListView(
          children: <Widget>[
            GoodsDetailGallery(_goodsDetail.info.gallery,
                _goodsDetail.info.gallery.length, 240),
            Divider(
              height: 2,
              color: Colors.grey,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _goodsDetail.info.name,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 6),
                  ),
                  Text(
                    _goodsDetail.info.brief,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "原价：${_goodsDetail.info.retailPrice}",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                      ),
                      Text(
                        "现价：${_goodsDetail.info.counterPrice}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 6),
            ),
            _goodsDetail.attribute == null || _goodsDetail.attribute.length == 0
                ? Divider()
                : Container(
                    child: Column(
                      children: <Widget>[
                        Text(
                          KString.GOODS_ATTRIBUTES,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 6),
                        ),
                        _attributeWidget(_goodsDetail),
                      ],
                    ),
                  ),
            Html(
              data: _goodsDetail.info.detail,
            ),
            _goodsDetail.issue == null || _goodsDetail.issue.length == 0
                ? Divider()
                : Container(
                    child: Column(
                      children: <Widget>[
                        Text(
                          KString.GOODS_ATTRIBUTES,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        _issueWidget(_goodsDetail)
                      ],
                    ),
                  ),
          ],
        )
      ],
    );
  }

  openBottomSheet(
      BuildContext context, ProductModel productModel, int showType) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SizedBox(
              width: double.infinity,
              height: ScreenUtil.instance.setHeight(630.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(ScreenUtil.instance.setWidth(20)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CachedImageWidget(
                            ScreenUtil.instance.setWidth(120),
                            ScreenUtil.instance.setHeight(120),
                            productModel.url),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              KString.PRICE + ":" + "${productModel.price}",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: ScreenUtil.instance.setSp(24),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: ScreenUtil.instance.setHeight(10)),
                            ),
                            Text(
                              KString.ALREAD_SELECTED +
                                  ":" +
                                  "${_goodsDetail.productList[0].specifications[_specificationIndex]}",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: ScreenUtil.instance.setSp(24),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(ScreenUtil.instance.setWidth(10)),
                    child: Text(
                      KString.SPECIFICATIONS,
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: ScreenUtil.instance.setSp(30)),
                    ),
                  ),
                  Wrap(
                    children: _specificationWidget(productModel.specifications),
                  ),
                  Container(
                    margin: EdgeInsets.all(ScreenUtil.instance.setWidth(10)),
                    child: Text(
                      KString.NUMBER,
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: ScreenUtil.instance.setSp(30)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(ScreenUtil.instance.setWidth(10)),
                    height: ScreenUtil.instance.setHeight(80),
                    alignment: Alignment.centerLeft,
                    child: CartNumberWidget(1, (number) {
                      setState(() {
                        _number = number;
                      });
                    }),
                  ),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: <Widget>[
                        SizedBox(
                          height: ScreenUtil.instance.setHeight(100),
                          width: double.infinity,
                          child: InkWell(
                            onTap: () => showType == 1 ? _addCart() : _buy(),
                            child: Container(
                              alignment: Alignment.center,
                              color: KColor.defaultButtonColor,
                              child: Text(
                                showType == 1 ? KString.ADD_CART : KString.BUY,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil.instance.setSp(30),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  _addCart() {
    SharedPreferencesUtil.getToken().then((value) {
      if (value != null) {
        parameters = {
          "goodsId": _goodsDetail.info.id,
          "productId": _goodsDetail.productList[0].id,
          "number": _number,
        };
        _cartService.addCart(parameters, (value) {
          ToastUtil.showToast(KString.ADD_CART_SUCCESS);
          Navigator.of(context).pop();
          eventBus.fire(RefreshEvent());
        });
      } else {
        NavigatorUtil.goLogin(context);
      }
    });
  }

  _buy() {
    if (SharedPreferencesUtil.token != null) {
      parameters = {
        "goodsId": _goodsDetail.info.id,
        "productId": _goodsDetail.productList[0].id,
        "number": _number,
      };
      _cartService.fastBuy(parameters, (success) {
        NavigatorUtil.goFillInOrderPage(context, success);
        eventBus.fire(RefreshEvent());
      }, (error) {});
    } else {
      NavigatorUtil.goLogin(context);
    }
  }

  _collection() {
    //TODO deal with collection
  }

  _addOrDeleteCollect() {
    //TODO DealWith Collection or cancel Collection
  }

  List<Widget> _specificationWidget(List<String> specifications) {
    List<Widget> specificationsWidget = List();
    for (int i = 0; i < specifications.length; i++) {
      specificationsWidget.add(Container(
        padding: EdgeInsets.all(ScreenUtil.instance.setWidth(10)),
        child: InkWell(
          child: Chip(
            label: Text(
              specifications[i],
              style: TextStyle(
                color: i == _specificationIndex ? Colors.white : Colors.grey,
                fontSize: ScreenUtil.instance.setSp(24),
              ),
            ),
            backgroundColor: i == _specificationIndex
                ? KColor.specificationWarpColor
                : Colors.grey,
          ),
        ),
      ));
      return specificationsWidget;
    }
  }

  Widget _attributeWidget(GoodsDetailModel goodsDetailModel) {
    print("${goodsDetailModel.attribute.length}");
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: goodsDetailModel.attribute.length,
        itemBuilder: (BuildContext context, int index) {
          return _attributeItemWidtget(goodsDetailModel.attribute[index]);
        });
  }

  Widget _attributeItemWidtget(AttributeModel attributeModel) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(6),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(
              attributeModel.attribute,
              style: TextStyle(color: KColor.attributeTextColor, fontSize: 14),
            ),
          ),
          Expanded(
              flex: 4,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  attributeModel.value,
                  style: TextStyle(
                      color: KColor.attributeTextColor, fontSize: 14.0),
                ),
              )),
        ],
      ),
    );
  }

  Widget _issueWidget(GoodsDetailModel goodsDetailModel) {
    print("${goodsDetailModel.issue.length}");
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: goodsDetailModel.issue.length,
        itemBuilder: (BuildContext context, int index) {
          return _issueItemWidtget(goodsDetailModel.issue[index]);
        });
  }

  Widget _issueItemWidtget(IssueModel issueModel) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            issueModel.question,
            style: TextStyle(color: KColor.issueQuestionColor, fontSize: 14),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          Text(
            issueModel.answer,
            style: TextStyle(color: KColor.issueAnswerColor, fontSize: 14.0),
          ),
        ],
      ),
    );
  }
}
