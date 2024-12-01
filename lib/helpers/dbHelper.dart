// ignore_for_file: file_names,depend_on_referenced_packages

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:restaurantmenu/models/model.dart';
import 'package:restaurantmenu/models/tbl_dk_cart_item.dart';
import 'package:restaurantmenu/models/tbl_dk_image.dart';
import 'package:restaurantmenu/models/tbl_dk_res_category.dart';
import 'package:restaurantmenu/models/tbl_dk_res_price.dart';
import 'package:restaurantmenu/models/tbl_dk_res_price_group.dart';
import 'package:restaurantmenu/models/tbl_dk_resource.dart';
import 'package:restaurantmenu/models/v_dk_resource.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

abstract class DbHelper {
  static const _dbName = "dbRestaurantMenu.db";

  static get _dbVersion => 1;
  static Database? _db;

  static Future<void> init() async {
    if (_db != null) {
      return;
    }

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);
    debugPrint('Print Db Path is:$path');
    _db = await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  static Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE tbl_dk_company(
            CId int,
            CGuid String NULL,
            CName String NULL,
            CDesc String NULL,
            CFullName String NULL,
            Phone1 String NULL,
            Phone2 String NULL,
            Phone3 String NULL,
            Phone4 String NULL,
            WebAddress String NULL,
            CEmail String NULL,
            SyncDateTime datetime NULL
          )
    ''');
    await db.execute('''
          CREATE TABLE tbl_dk_cart_item(
            CIId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            ResId int NULL,
            ResPriceGroupId int NULL,
            ResPriceValue REAL NULL,
            ResRegNo String NULL,
            ItemCount INT,
            ItemPriceTotal REAL,
            SyncDateTime datetime NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE tbl_dk_res_category(
            ResCatId INTEGER NOT NULL,
            ResOwnerCatId int NULL,
            ResCatVisibleIndex int NULL,
            IsMain int NULL,
            ResCatName String NULL,
            ResCatNameTm String NULL,
            ResCatNameRu String NULL,
            ResCatNameEn String NULL,
            ResCatDesc String NULL,
            ResCatIconName String NULL,
            ResCatIconFilePath String NULL,
            ResCatIconData String NULL,
            SyncDateTime datetime NULL
            )
          ''');
    await db.execute('''
          CREATE TABLE tbl_dk_resources(
            ResId INTEGER NOT NULL,
            ResGuid String NULL,
            ResCatId int NULL,
            ResName String NULL,
            ResDesc String NULL,
            ResFullDesc String NULL,
            ResNameTm String NULL,
            ResNameRu String NULL,
            ResNameEn String NULL,
            SyncDateTime datetime NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE tbl_dk_res_price(
            ResPriceId INTEGER NOT NULL,
            ResPriceGroupId int NULL,
            CurrencyId int NULL,
            ResId int NULL,
            ResPriceRegNo String NULL,
            ResPriceValue float NULL,
            PriceStartDate datetime NULL,
            PriceEndDate datetime NULL,
            SyncDateTime datetime NULL
          )
    ''');
    await db.execute('''
          CREATE TABLE tbl_dk_res_price_group(
            ResPriceGroupId INTEGER NOT NULL,
            ResPriceGroupName String NULL,
            ResPriceGroupDesc String NULL,
            SyncDateTime datetime NULL
          )
    ''');
    await db.execute('''
          CREATE TABLE tbl_dk_image(
            ImgId INTEGER NOT NULL,
            ImgGuid String NULL,
            ResCatId int NULL,
            CId int NULL,
            ResId int NULL,
            FileName String NULL,
            FileHash String NULL,
            FilePath String NULL,
            Image Uint8List NULL,
            SyncDateTime datetime NULL
            )
          ''');
    debugPrint('Print Database is created');
  }

//region //////////////////////////// Basic functions //////////////////////////
  static Future<int?> rowCount(String table) async => Sqflite.firstIntValue(await _db!.rawQuery('Select Count(*) FROM $table'));

  static Future<List<Map<String, dynamic>>> queryAllRows(String table, {String where = ''}) async =>
      (where.isNotEmpty) ? await _db!.query(table, where: where) : await _db!.query(table);

  static Future<Map<String, dynamic>> queryFirstRow(String table, {String where = ''}) async {
    if (where.isNotEmpty) {
      List<Map<String, dynamic>> result0 = await _db!.query(table, where: where, limit: 1);
      if (result0.isNotEmpty) return result0[0];
      return {};
    }
    List<Map<String, dynamic>> result = await _db!.query(table, limit: 1);
    if (result.isNotEmpty) return result[0];
    return {};
  }

  static Future<int> insert(String table, Model model) async => await _db!.insert(table, model.toMap());

  static Future<int> update(String table, String columnId, Model model) async =>
      await _db!.update(table, model.toMap(), where: '$columnId = ?', whereArgs: [model.toMap()[columnId]]);

  static Future<int> delete(String table, {String where = ''}) async => await _db!.delete(table, where: where);

  static Future<int> insertUpdateRowById(String table, Model model, String idColumnName, int id) async {
    try {
      int? count = Sqflite.firstIntValue(await _db!.rawQuery('SELECT COUNT(*) FROM $table WHERE $idColumnName=$id'));
      if (count != null && count > 0) {
        return _db!.update(table, model.toMap(), where: '$idColumnName=$id');
      }
      return await _db!.insert(table, model.toMap());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<int> insertUpdateRowByGuid(String table, Model model, String guidColumnName, String uGuid) async {
    try {
      int count = Sqflite.firstIntValue(await _db!.rawQuery('SELECT COUNT(*) FROM $table WHERE $guidColumnName=\'$uGuid\'')) ?? 0;
      if (count > 0) {
        return _db!.update(table, model.toMap(), where: '$guidColumnName=\'$uGuid\'');
      } else {
        return await _db!.insert(table, model.toMap());
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<int> initTable(String tableName) async => await _db!.delete(tableName);

  static Future<int> deleteRowByGuid(String tableName, String guidColumnName, String guid) async =>
      await _db!.delete(tableName, where: '$guidColumnName=\'$guid\'');

  static Future<List<Map<String, dynamic>>> getRowByGuid(String tableName, String guidColumnName, String guid) async =>
      await _db!.query(tableName, where: '$guidColumnName=\'$guid\'');

//endregion //////////////////// Basic functions /////////////////////////

//region ///////////////////////////// Cart Items //////////////////////////////
  static Future<int> insertCartItem(String table, Model model, int resId, int rpAccId) async {
    int count = Sqflite.firstIntValue(await _db!.rawQuery('SELECT COUNT(*) FROM tbl_dk_cart_item WHERE ResId=$resId and RpAccId=$rpAccId')) ?? 0;
    if (count > 0) {
      if ((model as TblDkCartItem).ItemCount == 0) {
        return _db!.delete(table, where: 'ResId=? and RpAccId=?', whereArgs: [resId, rpAccId]);
      }
      return _db!.update(table, model.toMap(), where: 'ResId= ? and RpAccId=?', whereArgs: [resId, rpAccId]);
    }
    return await _db!.insert(table, model.toMap());
  }

  static Future<int> initCartItems(int rpAccId) async => await _db!.delete('tbl_dk_cart_item', where: 'RpAccId=?', whereArgs: [rpAccId]);

  static Future<int> deleteCartItem(int resId, int rpAccId) async =>
      await _db!.delete('tbl_dk_cart_item', where: 'ResId = ? and RpAccId=?', whereArgs: [resId, rpAccId]);

  static Future<List<Map<String, dynamic>>> getCartItemsByRpAccId(int rpAccId) async =>
      await _db!.query('tbl_dk_cart_item', where: 'RpAccId=?', whereArgs: [rpAccId]);

//endregion Cart Items

//region /////////////////////////ResCategories/////////////////////////////////

  static Future<int> insertCategoryList(String table, List<TblDkResCategory> categoryList) async {
    Batch batch = _db!.batch();
    await _db!.delete(table);
    for (TblDkResCategory model in categoryList) {
      try {
        batch.insert(table, model.toMap());
      } catch (e) {
        throw Exception(e.toString());
      }
    }
    try {
      await batch.commit();
      return categoryList.length;
    } on Exception catch (_) {
      return 0;
    }
  }

//endregion ResCategories

//region ///////////////////////Resources//////////////////////////////

  static Future<int> insertResourceList(String table, List<TblDkResource> resourceList) async {
    Batch batch = _db!.batch();
    await _db!.delete(table);
    for (TblDkResource model in resourceList) {
      try {
        batch.insert(table, model.toMap());
      } catch (e) {
        throw Exception(e.toString());
      }
    }
    try {
      await batch.commit();
      return resourceList.length;
    } catch (e) {
      debugPrint("PrintError on insertResourceList: $e");
      return 0;
    }
  }

  static Future<List<VDkResource>> queryVResource(int resPriceGroupId) async {
    try {
      List<Map<String, dynamic>> result = await _db!.rawQuery(
          "SELECT tbl_dk_resources.ResId, tbl_dk_resources.ResGuid,tbl_dk_resources.ResCatId,ResName,ResNameTm,ResNameRu,ResNameEn,ResDesc,ResFullDesc,tbl_dk_res_price.ResPriceValue,tbl_dk_image.FilePath FROM tbl_dk_resources "
          "LEFT OUTER JOIN tbl_dk_image ON tbl_dk_image.ResId=tbl_dk_resources.ResId "
          "LEFT OUTER JOIN tbl_dk_res_price ON tbl_dk_res_price.ResId=tbl_dk_resources.ResId and tbl_dk_res_price.ResPriceGroupId = $resPriceGroupId and tbl_dk_res_price.ResPriceValue>0");
      return result.map((e) => VDkResource.fromMap(e)).toList();
    } catch (e) {
      debugPrint("PrintError on dbHelper.queryVResource: $e");
      rethrow;
    }
  }

//endregion ////////////////////Resources///////////////////////////

//region ////////////////ResPriceGroup/////////////////////////////////

  static Future<int> insertResPriceGroupList(String table, List<TblDkResPriceGroup> resPriceGroupList) async {
    Batch batch = _db!.batch();
    await _db!.delete(table);
    for (TblDkResPriceGroup model in resPriceGroupList) {
      try {
        batch.insert(table, model.toMap());
      } catch (e) {
        throw Exception(e.toString());
      }
    }
    try {
      await batch.commit();
      return resPriceGroupList.length;
    } on Exception catch (_) {
      return 0;
    }
  }

//endregion ResPriceGroup

//region //////////////////ResPrices///////////////////////////////////

  static Future<int> insertResPricesList(String table, List<TblDkResPrice> resPricesList) async {
    Batch batch = _db!.batch();
    await _db!.delete(table);
    for (TblDkResPrice model in resPricesList) {
      try {
        batch.insert(table, model.toMap());
      } catch (e) {
        throw Exception(e.toString());
      }
    }

    try {
      await batch.commit();
      return resPricesList.length;
    } on Exception catch (_) {
      return 0;
    }
  }

//endregion ResPrices

//region //////////////////////// tbl_dk_images ///////////////////////
  static Future<List<Map<String, dynamic>>> rawQueryImageNameAndGuid() async {
    return await _db!.rawQuery("Select ImgGuid from tbl_dk_image");
  }

  static Future<int> insertImagesList(String table, List<TblDkImage> imagesList) async {
    Batch batch = _db!.batch();
    int imgCount = 0;
    for (TblDkImage model in imagesList) {
      try {
        final imgList = await _db!.query(table, where: "ImgGuid='${model.ImgGuid}'", limit: 1);
        TblDkImage? image = (imgList.isNotEmpty) ? TblDkImage.fromMap(imgList[0]) : null;
        if (image != null && image.ImgId != model.ImgId) {
          imgCount++;
          debugPrint("Print update image ${imgCount.toString()}");
          batch.update(table, model.toMap(), where: "ImgGuid='${model.ImgGuid}'");
        } else if (image == null) {
          imgCount++;
          debugPrint("Print insert image ${imgCount.toString()}");
          batch.insert(table, model.toMap());
        }
        if (imgCount > 20) {
          try {
            imgCount = 0;
            debugPrint('Print ImageCnt>20 try to commiting');
            await batch.commit();
            batch = _db!.batch();
          } catch (e) {
            imgCount = 0;
            throw Exception('Print SaveImageError: ${e.toString()}');
          }
        }
      } catch (e) {
        throw Exception('Print SaveImageError: ${e.toString()}');
      }
    }

    try {
      await batch.commit();
      return imagesList.length;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return 0;
    }
  }
//endregion Brand
}
