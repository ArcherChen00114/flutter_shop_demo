
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shopdemo/config/index.dart';
import 'package:shopdemo/page/category/category_page.dart';
import 'package:shopdemo/page/home/home_page.dart';
import 'package:shopdemo/page/login/login_page.dart';
import 'package:shopdemo/page/cart/cart_page.dart';
import 'package:shopdemo/page/mine/mine_page.dart';

class IndexPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=> IndexPageState();
}
class IndexPageState extends State<IndexPage>{

  var _selectedIndex=0;
  List<Widget> _list=List();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _list,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const<BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(KString.HOME_TITLE),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            title: Text(KString.CATEGORY_TITLE),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text(KString.SHOP_CAR),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text(KString.MINE),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: KColor.indexTabSelectedColor,
        unselectedItemColor: KColor.indexTabUnSelectedColor,
        onTap: _onItemTapped,
      ),


    );
  }

  @override
  void initState() {
    super.initState();
    _list
    ..add(HomePage())
    ..add(CategoryPage())
    ..add(CartPage())
    ..add(MinePage());
  }

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex=index;
    });
  }

}
