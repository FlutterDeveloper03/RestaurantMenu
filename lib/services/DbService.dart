// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:restaurantmenu/models/tbl_dk_company.dart';
import 'package:restaurantmenu/models/tbl_dk_image.dart';
import 'package:restaurantmenu/models/tbl_dk_res_category.dart';
import 'package:restaurantmenu/models/tbl_dk_res_price.dart';
import 'package:restaurantmenu/models/tbl_dk_res_price_group.dart';
import 'package:restaurantmenu/models/tbl_dk_resource.dart';
import 'package:sql_conn/sql_conn.dart';

class DbService {
  final String host;
  final int port;
  final String dbUName;
  final String dbUPass;
  final String dbName;

  DbService(this.host, this.port, this.dbName, this.dbUName, this.dbUPass);

  Future<int> connect() async {
    try {
      if (host.isNotEmpty && port > 0 && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
        await SqlConn.connect(ip: host, port: port.toString(), databaseName: dbName, username: dbUName, password: dbUPass);
        if (SqlConn.isConnected) {
          debugPrint("Connected!");
          return 1;
        } else {
          debugPrint("DkPrint: Can't connect to db.");
          return 0;
        }
      } else {
        debugPrint("DkPrint: Can't connect to db. Some required fields are empty");
        return 0;
      }
    } catch (e) {
      debugPrint("DkPrintError on QueryFromDb.connect: $e");
      return 0;
    }
  }

  Future<TblDkCompany?> getCompany() async {
    if (host.isNotEmpty && port > 0 && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
      try {
        int connectionStatus = 1;
        if (!SqlConn.isConnected) {
          connectionStatus = await connect();
        }
        if (connectionStatus == 1) {
          var result = await SqlConn.readData("SELECT firm_id as CId, firm_id_guid as CGuid, firm_name as CName, firm_fullname as CFullName, "
                                              "firm_phone as Phone1, firm_fax as Phone2, firm_adres1 as WebAddress FROM tbl_mg_firm");
          if (result != null) {
            List decodedList = jsonDecode(result);
            return TblDkCompany.fromJson(decodedList.first);
          }
        }
      } catch (e) {
        debugPrint("DkPrintError on QueryFromApi.getFirm: ${e.toString()}");
      }
    }
    return null;
  }

  Future<List<TblDkResCategory>> getCategories() async {
    String query = '''select cat_id as ResCatId, 
                      0 as ResOwnerCatId,
                      cat_order as ResCatVisibleIndex,
                      cat_name as ResCatName,
                      cat_name_tm as ResCatNameTm,
                      cat_name_ru as ResCatNameRu,
                      cat_name_en as ResCatNameEn,
                      cat_image as ResCatIconData
                      from tbl_mg_category''';

    if (host.isNotEmpty && port > 0 && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
      try {
        int connectionStatus = 1;
        if (!SqlConn.isConnected) {
          connectionStatus = await connect();
        }
        if (connectionStatus == 1) {
          var result = await SqlConn.readData(query);
          if (result != null) {
            List decoded = jsonDecode(result);
            return decoded.map((e) => TblDkResCategory.fromJson(e)).toList();
          }
        }
      } catch (e) {
        debugPrint("DkPrintError from getCategories(): ${e.toString()}");
      }
    }
    return [];
  }

  Future<List<TblDkResource>> getResources() async {
    String query =
        '''select 
            material_id as ResId,
            material_id_guid as ResGuid,
            cat_id as ResCatId,
            material_name as ResName,
            spe_code1 as ResDesc,
            spe_code2 as ResFullDesc,
            mat_name_lang1 as ResNameTm,
            mat_name_lang2 as ResNameRu,
            mat_name_lang3 as ResNameEn
           from tbl_mg_materials
          where m_cat_id=14 
        ''';

    if (host.isNotEmpty && port > 0 && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
      try {
        int connectionStatus = 1;
        if (!SqlConn.isConnected) {
          connectionStatus = await connect();
        }
        if (connectionStatus == 1) {
          var result = await SqlConn.readData(query);
          if (result != null) {
            List decoded = jsonDecode(result);
            return decoded.map((e) => TblDkResource.fromMap(e)).toList();
          }
        }
      } catch (e) {
        debugPrint("DkPrintError from getResources(): ${e.toString()}");
      }
    }
    return [];
  }

  Future<List<TblDkResPrice>> getResPrices() async {
    String query =
        '''select 
            price_id as ResPriceId,
            price_cat_id as ResPriceGroupId,
            currency_id as CurrencyId,
            material_id as ResId,
            '' as ResPriceRegNo,
            price_value as ResPriceValue,
            price_start_date as PriceStartDate,
            price_end_date as PriceEndDate,
            sync_datetime as SyncDateTime
           from tbl_mg_mat_price
           where price_type_id=2
           ''';

    if (host.isNotEmpty && port > 0 && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
      try {
        int connectionStatus = 1;
        if (!SqlConn.isConnected) {
          connectionStatus = await connect();
        }
        if (connectionStatus == 1) {
          var result = await SqlConn.readData(query);
          if (result != null) {
            List decoded = jsonDecode(result);
            return decoded.map((e) => TblDkResPrice.fromJson(e)).toList();
          }
        }
      } catch (e) {
        debugPrint("DkPrintError from getResPrices(): ${e.toString()}");
      }
    }
    return [];
  }

  Future<List<TblDkResPriceGroup>> getResPriceGroup() async {
    String query =
        '''select 
            price_cat_id as  ResPriceGroupId,
            price_cat_name as ResPriceGroupName
           from tbl_mg_price_category
        ''';

    if (host.isNotEmpty && port > 0 && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
      try {
        int connectionStatus = 1;
        if (!SqlConn.isConnected) {
          connectionStatus = await connect();
        }
        if (connectionStatus == 1) {
          var result = await SqlConn.readData(query);
          if (result != null) {
            List decoded = jsonDecode(result);
            return decoded.map((e) => TblDkResPriceGroup.fromMap(e)).toList();
          }
        }
      } catch (e) {
        debugPrint("DkPrintError from getResPriceGroup(): ${e.toString()}");
      }
    }
    return [];
  }

  Future<List<TblDkImage>> getImages(String oldImages, int offset, int rowCnt) async {
    String query =
        '''select 
            image_id as ImgId,
            image_id_guid as ImgGuid,
            0 as ResCatId,
            0 as CId,
            material_id as ResId,
            image_pict as Image
            from tbl_mg_images 
           ${oldImages.isNotEmpty ? 'where image_id_guid not in ($oldImages)' : ''}
           ORDER BY image_id
           OFFSET $offset ROWS FETCH NEXT $rowCnt ROWS ONLY
        ''';

    if (host.isNotEmpty && port > 0 && dbUName.isNotEmpty && dbUPass.isNotEmpty && dbName.isNotEmpty) {
      try {
        int connectionStatus = 1;
        if (!SqlConn.isConnected) {
          connectionStatus = await connect();
        }
        if (connectionStatus == 1) {
          var result = await SqlConn.readData(query);
          if (result != null) {
            List decoded = jsonDecode(result);
            return decoded.map((e) => TblDkImage.fromJson(e)).toList();
          }
        }
      } catch (e) {
        debugPrint("DkPrintError from getImage(): ${e.toString()}");
      }
    }
    return [];
  }

}
