import 'package:flutter/material.dart';
import 'package:shopdemo/model/user_model.dart';

class UserInfoProvide with ChangeNotifier{
  UserModel userModel;

  updateInfo(UserModel userModel){
    this.userModel=userModel;
    notifyListeners();
  }
}