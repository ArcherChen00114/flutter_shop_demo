

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopdemo/event/cart_number_event.dart';

typedef OnNumberChange(int number);

class CartNumberWidget extends StatefulWidget{

  OnNumberChange onNumberChange;
  var _number;

  CartNumberWidget(this._number,this.onNumberChange);
  @override
  State<StatefulWidget> createState() {
    return _CartNumberWidgetState();
  }

}

class _CartNumberWidgetState extends State<CartNumberWidget>{

  var goodsNumber;


  OnNumberChange onNumberChange;

  @override
  void initState(){
    super.initState();
    goodsNumber=widget._number;
    onNumberChange=widget.onNumberChange;
  }

  _listener(){
    cartNumberEventBus.on<CartNumberEvent>().listen((CartNumberEvent cartNumberEvent){
      setState((){
        goodsNumber=cartNumberEvent.number;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _listener();
    return Container(
      width: ScreenUtil.instance.setWidth(150),
      height: ScreenUtil.instance.setHeight(50),
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: ()=>_reduce() ,
          child: Container(
            width: ScreenUtil.instance.setWidth(50),
            height: double.infinity,
            alignment: Alignment.center,
            decoration: ShapeDecoration(
              shape: Border(
                left:BorderSide(color: Colors.grey,width: 1.0),
                top:BorderSide(color: Colors.grey,width: 1.0),
                right:BorderSide(color: Colors.grey,width: 1.0),
                bottom:BorderSide(color: Colors.grey,width: 1.0),
              )
            ),
            child: Text('-',
            style: TextStyle(
              color: Colors.black45,
              fontSize: ScreenUtil.instance.setSp(26)
            ),),
          ),
          ),
        //
          Container(
            width: ScreenUtil.instance.setWidth(50),
            height: double.infinity,
            alignment: Alignment.center,
            decoration: ShapeDecoration(
                shape: Border(
                  top:BorderSide(color: Colors.grey,width: 1.0),
                  bottom:BorderSide(color: Colors.grey,width: 1.0),
                )
            ),
            child: Text('${goodsNumber}',
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: ScreenUtil.instance.setSp(26)
              ),),
          ),

          InkWell(
            onTap: ()=>_add() ,
            child: Container(
              width: ScreenUtil.instance.setWidth(50),
              height: double.infinity,
              alignment: Alignment.center,
              decoration: ShapeDecoration(
                  shape: Border(
                    left:BorderSide(color: Colors.grey,width: 1.0),
                    top:BorderSide(color: Colors.grey,width: 1.0),
                    right:BorderSide(color: Colors.grey,width: 1.0),
                    bottom:BorderSide(color: Colors.grey,width: 1.0),
                  )
              ),
              child: Text('+',
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: ScreenUtil.instance.setSp(26)
                ),),
            ),
          ),

        ],
      ),
    );
  }

  _reduce(){
    if(goodsNumber>1){
      setState(() {
        goodsNumber=goodsNumber-1;
      });
      print("${widget._number}");
      onNumberChange(goodsNumber);
    }
  }
  _add(){
    setState(() {
      goodsNumber=goodsNumber+1;
    });
    print("${widget._number}");
    onNumberChange(goodsNumber);
  }

}