
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopdemo/config/index.dart';
import 'package:shopdemo/model/address_model.dart';
import 'package:shopdemo/service/address_service.dart';
import 'package:shopdemo/utils/fluro_convert_util.dart';
import 'package:shopdemo/utils/navigator_util.dart';
import 'package:shopdemo/utils/text_util.dart';
import 'package:shopdemo/widget/no_data_widget.dart';

class AddressPage extends StatefulWidget{


  AddressPage();

  @override
  State<StatefulWidget> createState() =>_AddressPageState();
}

class _AddressPageState extends State<AddressPage> {

  List<AddressModel> _addressData;

  AddressService _addressService=AddressService();

  var addressFuture;

  var token;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextUtil.textWithDefaultStyle(KString.MY_ADDRESS),
        centerTitle: true,
        actions: <Widget>[
          InkWell(
            child: Container(
              margin: EdgeInsets.only(right: ScreenUtil.instance.setWidth(10)),
              alignment: Alignment.center,
              child: InkWell(
                onTap: ()=>_goAddressEdit(0),
                child: TextUtil.textWithDefaultStyle(KString.ADD_ADDRESS),
              ),
            ),
          )
        ],
      ),
      body: _addressData!=null&&_addressData.length>0?
      Container(
        child: ListView.builder(
            itemCount: _addressData.length,
            itemBuilder: (BuildContext context,int index){
              return _addressItemView(_addressData[index]);
            }),
      ):NoDataWidget(),
    );
  }

  @override
  void initState() {
    super.initState();
    _getAddressData();
  }

  _getAddressData(){
    _addressService.getAddressList((addressList){
      setState(() {
        _addressData = addressList;
      });
    });
  }

  Widget _addressItemView(AddressModel addressData){
    return Container(
      padding: EdgeInsets.only(
          left: ScreenUtil.instance.setWidth(20),
          right: ScreenUtil.instance.setWidth(20)
      ),
      height: ScreenUtil.instance.setHeight(120),
      alignment: Alignment.center,
      child: Card(
        child: InkWell(
          onTap: ()=> _goFillInOrder(addressData),
          child: Row(
            //联系人部分
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(left: ScreenUtil.instance.setWidth(30)),),
              Expanded(
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        TextUtil.textWithStyle(addressData.name,Colors.grey,28.0),
                        Padding(padding: EdgeInsets.only(left: ScreenUtil.instance.setWidth(10)),),
                        TextUtil.textWithStyle(addressData.tel,Colors.grey,26.0),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: ScreenUtil.instance.setHeight(20)),
                    ),
                    Text(addressData.province
                        +addressData.city
                        +addressData.county
                        +addressData.addressDetail,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black54, fontSize: ScreenUtil.instance.setSp(26)),
                    ),
                  ],
                ),
              ),
              Container(
                width: ScreenUtil.instance.setWidth(120),
                margin: EdgeInsets.only(right: ScreenUtil.instance.setWidth(10)),
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  shape: Border(
                    left: BorderSide(
                      color: Colors.grey[350],
                      width: ScreenUtil.instance.setWidth(1),
                    )
                  )
                ),
                padding: EdgeInsets.only(left: ScreenUtil.instance.setWidth(10)),
                child: InkWell(
                  onTap: ()=>_goAddressEdit(addressData.id),
                  child: TextUtil.textWithStyle(KString.ADDRESS_EDIT, Colors.grey, 26),
                ),
              ),

            ],
          ),

        )
    )
    );
  }

  _goFillInOrder(AddressModel addressModel){
    Navigator.of(context).pop(FluroConvertUtil.objectToString(addressModel));
  }

  _goAddressEdit(var addressId){
    NavigatorUtil.goAddressEdit(context, addressId).then((bool){
      _getAddressData();
    });
  }
}



