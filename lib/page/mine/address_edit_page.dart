

import 'package:city_pickers/city_pickers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopdemo/config/index.dart';
import 'package:shopdemo/model/address_model.dart';
import 'package:shopdemo/service/address_service.dart';
import 'package:shopdemo/utils/navigator_util.dart';
import 'package:shopdemo/utils/shred_preferences.dart';
import 'package:shopdemo/utils/text_util.dart';
import 'package:shopdemo/utils/toast_util.dart';
import 'package:shopdemo/widget/no_data_widget.dart';

class AddressEditPage extends StatefulWidget{

  var addressId;


  AddressEditPage(this.addressId);

  @override
  State<StatefulWidget> createState() =>_AddressEditPageState();
}

class _AddressEditPageState extends State<AddressEditPage> {

  TextEditingController _nameController;

  TextEditingController _phoneController=TextEditingController();

  TextEditingController _addressDetailController=TextEditingController();

  AddressModel _addressData;

  AddressService _addressService=AddressService();

  var addressFuture;

  var _cityText;

  var _isDefault=false;

  var _addressId;

  var _provinceName;

  var _countryName;

  var _cityName;

  var _areaId;

  var token;

  Options options=Options();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextUtil.textWithDefaultStyle(KString.ADDRESS_EDIT_TITLE),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(left: ScreenUtil.instance.setWidth(20),right: ScreenUtil.instance.setWidth(20)),
        child: Column(
          children: <Widget>[
            _textFieldWidget(_nameController, KString.ADDRESS_PLEASE_INPUT_NAME),
            _dividerWidget(),
            _textFieldWidget(_phoneController, KString.ADDRESS_PLEASE_INPUT_PHONE),
            _dividerWidget(),
            _textFieldWidget(_addressDetailController, KString.ADDRESS_PLEASE_INPUT_DETAIL),
            _dividerWidget(),
            InkWell(
              onTap: ()=>this.show(context),
              child: Container(
                alignment: Alignment.centerLeft,
                height: ScreenUtil.instance.setHeight(100),
                child: TextUtil.textWithStyle(_cityText==null?KString.ADDRESS_PLEASE_SELECT_CITY:_cityText,
                    _cityText==null?Colors.grey:Colors.black54,26)
              ),
            ),
            _dividerWidget(),
            Container(
              height: ScreenUtil.instance.setHeight(100),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextUtil.textWithStyle(KString.ADDRESS_SET_DEFAULT, Colors.black54, 26),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Switch(
                        value: _isDefault,
                        activeColor: KColor.defaultSwitchColor,
                        onChanged: (bool){
                          setState(() {
                            this._isDefault=bool;
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          _dividerWidget(),
          Offstage(
            offstage: _addressId==0,
            child: InkWell(
              onTap: ()=>_deleteAddressDialog(context),
            child: Container(
              alignment: Alignment.centerLeft,
              height: ScreenUtil.instance.setHeight(100),
              child: TextUtil.textWithStyle(KString.ADDRESS_DELETE, KColor.defaultButtonColor, 26),
            ),
            ),
          ),
            Offstage(offstage: _addressId==0,
            child: _dividerWidget(),
            ),

          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          alignment: Alignment.center,
          height: ScreenUtil.instance.setHeight(100),
          color: KColor.defaultButtonColor,
          width: double.infinity,
              child:InkWell(
                onTap: ()=>_addAddress(),
                child: TextUtil.textWithStyle(KString.SUBMIT, Colors.white, 28),
              ),
        ),
      ),
    );
  }
  Widget _dividerWidget(){
    return Container(
        child:Divider(color: Colors.grey[350],
          height: ScreenUtil.instance.setHeight(1),)
    );
  }

  Widget _textFieldWidget(TextEditingController controller,String hintString){
    return Container(
      child:TextField(
      maxLines: 1,
      keyboardType: TextInputType.phone,
      controller: controller,
      style: TextStyle(
        color: Colors.black54,
        fontSize: ScreenUtil.instance.setSp(26),
      ),
      decoration: InputDecoration(
        hintText: hintString,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: ScreenUtil.instance.setSp(28),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent,),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent,),
        ),
      ),
    ),
    );
  }

  @override
  void initState() {
    super.initState();
    _addressId=widget.addressId;
    SharedPreferencesUtil.getToken().then((onValue){
      if(onValue!=null){
        token=onValue;
      }
      if(_addressId!=0){//0=>means add new address,else means edit
        _queryAddressDetail(onValue);
      }else{
        _initController();
      }

    });
  }
  _initController(){
    _nameController = TextEditingController(
      text: _addressData == null ? "" : _addressData.name,
    );
    _phoneController = TextEditingController(
      text: _addressData == null ? "" : _addressData.tel,
    );
    _addressDetailController = TextEditingController(
      text: _addressData == null ? "" : _addressData.addressDetail,
    );
  }

  _queryAddressDetail(var token){
    var parameters={"id":_addressId};
    _addressService.addressDetail(parameters, (addressDetail){
      setState(() {
        _addressData=addressDetail;
        _areaId=_addressData.areaCode;
        _cityText=_addressData.province+_addressData.city+_addressData.county;
        _isDefault=_addressData.isDefault;
        _cityName=_addressData.city;
        _countryName=_addressData.county;
        _provinceName=_addressData.province;
      });
      _initController();
    }, (error){

    });
  }

  show(context) async{
    Result temp=await CityPickers.showCityPicker(context: context,
    itemExtent: ScreenUtil.instance.setHeight(80),
    itemBuilder: (item,list,index){
      return Center(
        child: Text(
          item,
          maxLines: 1,
          style: TextStyle(fontSize: ScreenUtil.instance.setSp(26)),
        ),
      );
    },
      height: ScreenUtil.instance.setHeight(400),
    );
    print(temp);
    setState(() {
      _cityText=temp.provinceName+temp.cityName+temp.areaName;
      _areaId=temp.areaId;
      _provinceName=temp.provinceName;
      _cityName=temp.cityName;
      _countryName=temp.areaName;
    });
  }


  _deleteAddressDialog(BuildContext context){
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context){
          return AlertDialog(
            title: TextUtil.textWithStyle(KString.TIPS,Colors.black54,30),
            content: TextUtil.textWithStyle(KString.ADDRESS_DELETE,Colors.black54,30),
            actions: <Widget>[
              FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: 
                  TextUtil.textWithStyle(KString.CANCEL, KColor.defaultButtonColor, 26),
              ),
              FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                  _deleteAddress();
                },
                child: TextUtil.textWithStyle(KString.CONFIRM, KColor.defaultTextColor, 26),
              ),
            ],
          );
        }
    );
  }

  _deleteAddress(){
    var parameters={
      "id":_addressData.id,
    };
    _addressService.deleteAdress(parameters,(onSuccess){
      ToastUtil.showToast(KString.ADDRESS_DELETE_SUCCESS);
      Navigator.pop(context);
    }, (error){
      ToastUtil.showToast(error);
    });
  }

  _addAddress(){
    if(_checkAddressIntegrity()){
      var parameters={
        "addressDetail":_addressDetailController.text.toString(),
        "areaCode":_areaId,
        "city":_cityName,
        "county":_countryName,
        "id":_addressData==null? 0: _addressData.id,
        "isDefault":_isDefault,
        "name":_nameController.text.toString(),
        "province":_provinceName,
        "tel":_phoneController.text.toString(),
      };
      _addressService.addAdress(parameters, (onSuccess){
        ToastUtil.showToast(KString.SUBMIT_SUCCESS);
        Navigator.of(context).pop(true);
      }, (onFail){
        ToastUtil.showToast(onFail);
      });
    }

  }

  bool _checkAddressIntegrity(){
    if(_addressDetailController.text.toString().isEmpty){
      ToastUtil.showToast(KString.ADDRESS_PLEASE_INPUT_DETAIL);
      return false;
    }
    if(_nameController.text.toString().isEmpty){
      ToastUtil.showToast(KString.ADDRESS_PLEASE_INPUT_NAME);
      return false;
    }
    if(_phoneController.text.toString().isEmpty||_phoneController.text.length!=11){
      ToastUtil.showToast(KString.ADDRESS_PLEASE_INPUT_PHONE);
      return false;
    }
    return true;
  }
  

}



