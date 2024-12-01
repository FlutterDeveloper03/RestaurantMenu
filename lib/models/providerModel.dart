import 'package:flutter/material.dart';
import 'package:restaurantmenu/models/tbl_dk_cart_item.dart';
import 'package:restaurantmenu/models/tbl_dk_res_category.dart';
import 'package:restaurantmenu/models/v_dk_resource.dart';

class ProviderModel with ChangeNotifier{

  List<VDkResource> _resources=[];
  List<VDkResource> get getResources=>_resources;
  set setResources(List<VDkResource> resources){
    _resources = resources;
    notifyListeners();
  }

  List<TblDkCartItem> _cartItems=[];
  List<TblDkCartItem> get  getCartItems=>_cartItems;
  set setCartItems(List<TblDkCartItem> cartItems){
    _cartItems=cartItems;
    notifyListeners();
  }
  updateCartItems(int index, TblDkCartItem cartItem){
    _cartItems[index]=cartItem;
    notifyListeners();
  }

  List<TblDkResCategory> _resCategories=[];
  List<TblDkResCategory> get getResCategories=>_resCategories;
  set setResCategories(List<TblDkResCategory> resCategories){
    _resCategories = resCategories;
    notifyListeners();
  }

  String _host="";
  String get getHost=>_host;
  set setHost(String host){
    _host = host;
    notifyListeners();
  }

  int _port=1433;
  int get getPort=>_port;
  set setPort(int port){
    _port = port;
    notifyListeners();
  }

  String _dbName="";
  String get getDbName=>_dbName;
  set setDbName(String dbName){
    _dbName = dbName;
    notifyListeners();
  }

  String _dbUName="";
  String get getDbUName=>_dbUName;
  set setDbUName(String dbUName){
    _dbUName = dbUName;
    notifyListeners();
  }

  String _dbUPass="";
  String get getDbUPass=>_dbUPass;
  set setDbUPass(String dbUPass){
    _dbUPass = dbUPass;
    notifyListeners();
  }
}