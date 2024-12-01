// ignore_for_file: file_names

import 'dart:io';
import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:restaurantmenu/helpers/dbHelper.dart';
import 'package:restaurantmenu/helpers/enums.dart';
import 'package:restaurantmenu/models/providerModel.dart';
import 'package:restaurantmenu/models/tbl_dk_company.dart';
import 'package:restaurantmenu/models/tbl_dk_image.dart';
import 'package:restaurantmenu/models/tbl_dk_res_category.dart';
import 'package:restaurantmenu/services/DbService.dart';

//region States
class DbSyncPageState extends Equatable {
  @override
  List<Object> get props => [];
}

class DbSyncPageInitial extends DbSyncPageState {}

class LoadingDbSyncPage extends DbSyncPageState {}

class DbSyncPageLoadedState extends DbSyncPageState {
  final bool companyInfCheckbox;
  final bool resourcesCheckBox;
  final bool resPricesCheckBox;
  final bool imagesCheckBox;

  DbSyncPageLoadedState(this.companyInfCheckbox, this.resourcesCheckBox, this.resPricesCheckBox, this.imagesCheckBox);

  @override
  List<Object> get props => [companyInfCheckbox, resourcesCheckBox, resPricesCheckBox, imagesCheckBox];
}

class DbSyncingState extends DbSyncPageState {
  final Status companyInfCheckbox;
  final Status resourcesCheckBox;
  final Status resPricesCheckBox;
  final Status imagesCheckBox;

  DbSyncingState(this.companyInfCheckbox, this.resourcesCheckBox, this.resPricesCheckBox, this.imagesCheckBox);

  @override
  List<Object> get props => [companyInfCheckbox, resourcesCheckBox, resPricesCheckBox, imagesCheckBox];
}

class DbSyncedState extends DbSyncPageState {
  final Status companyInfCheckbox;
  final Status resourcesCheckBox;
  final Status resPricesCheckBox;
  final Status imagesCheckBox;

  final int companyInfSyncCount;
  final int resourcesSyncCount;
  final int resPricesSyncCount;
  final int imagesSyncCount;

  final String errorString;

  DbSyncedState(this.companyInfCheckbox, this.resourcesCheckBox, this.resPricesCheckBox, this.imagesCheckBox, this.companyInfSyncCount,
      this.resourcesSyncCount, this.resPricesSyncCount, this.imagesSyncCount, this.errorString);

  @override
  List<Object> get props => [
        companyInfCheckbox,
        resourcesCheckBox,
        resPricesCheckBox,
        imagesCheckBox,
        companyInfSyncCount,
        resourcesSyncCount,
        resPricesSyncCount,
        imagesSyncCount,
        errorString
      ];
}

class DbSyncErrorState extends DbSyncPageState {
  final String _errorString;

  DbSyncErrorState(this._errorString);

  String get getErrorString => _errorString;

  @override
  List<Object> get props => [_errorString];
}

class AccessDeniedState extends DbSyncPageState {}

//endregion States

class DbSyncPageCubit extends Cubit<DbSyncPageState> {
  final DbService srv;
  final ProviderModel provider;

  DbSyncPageCubit(this.srv, this.provider) : super(DbSyncPageInitial());

  bool _companyInfCheckbox = false;
  bool _resourcesCheckBox = false;
  bool _resPricesCheckBox = false;
  bool _imagesCheckBox = false;

  int dbCompanyInfCnt = 0;
  int dbResourcesCnt = 0;
  int dbResPricesCnt = 0;
  int dbImagesCnt = 0;

  void companyInfCheckboxClicked() {
    if (dbCompanyInfCnt <= 0) {
      _companyInfCheckbox = true;
    } else {
      _companyInfCheckbox = !_companyInfCheckbox;
    }
    emit(DbSyncPageLoadedState(_companyInfCheckbox, _resourcesCheckBox, _resPricesCheckBox, _imagesCheckBox));
  }

  void resourcesCheckBoxClicked() {
    if (!_resourcesCheckBox) {
      if (dbCompanyInfCnt <= 0) {
        _companyInfCheckbox = true;
      }
    }
    _resourcesCheckBox = !_resourcesCheckBox;
    if (!_resourcesCheckBox && dbResourcesCnt <= 0) {
      _resPricesCheckBox = false;
      _imagesCheckBox = false;
    }
    emit(DbSyncPageLoadedState(_companyInfCheckbox, _resourcesCheckBox, _resPricesCheckBox, _imagesCheckBox));
  }

  void resPricesCheckBoxClicked() {
    if (!_resPricesCheckBox) {
      if (dbCompanyInfCnt <= 0) {
        _companyInfCheckbox = true;
      }
      if (dbResourcesCnt <= 0) {
        _resourcesCheckBox = true;
      }
    }
    _resPricesCheckBox = !_resPricesCheckBox;
    emit(DbSyncPageLoadedState(_companyInfCheckbox, _resourcesCheckBox, _resPricesCheckBox, _imagesCheckBox));
  }

  void imagesCheckBoxClickedEvent() {
    if (!_imagesCheckBox) {
      if (dbCompanyInfCnt <= 0) {
        _companyInfCheckbox = true;
      }
      if (dbResourcesCnt <= 0) {
        _resourcesCheckBox = true;
      }
    }
    _imagesCheckBox = !_imagesCheckBox;
    emit(DbSyncPageLoadedState(_companyInfCheckbox, _resourcesCheckBox, _resPricesCheckBox, _imagesCheckBox));
  }

  void loadDbSyncPageEvent() async {
    emit(LoadingDbSyncPage());
    dbCompanyInfCnt = await DbHelper.rowCount('tbl_dk_company') ?? 0;
    dbResourcesCnt = await DbHelper.rowCount('tbl_dk_resources') ?? 0;
    dbResPricesCnt = await DbHelper.rowCount('tbl_dk_res_price') ?? 0;
    dbImagesCnt = await DbHelper.rowCount('tbl_dk_image') ?? 0;
    if (dbCompanyInfCnt <= 0) {
      _companyInfCheckbox = true;
      _resourcesCheckBox = true;
      _resPricesCheckBox = true;
      _imagesCheckBox = true;
      emit(DbSyncPageLoadedState(_companyInfCheckbox, _resourcesCheckBox, _resPricesCheckBox, _imagesCheckBox));
    } else if (dbImagesCnt > 0) {
      _companyInfCheckbox = false;
      _resourcesCheckBox = true;
      _resPricesCheckBox = true;
      _imagesCheckBox = false;
      emit(DbSyncPageLoadedState(_companyInfCheckbox, _resourcesCheckBox, _resPricesCheckBox, _imagesCheckBox));
    } else {
      _companyInfCheckbox = false;
      _resourcesCheckBox = true;
      _resPricesCheckBox = true;
      _imagesCheckBox = true;
      emit(DbSyncPageLoadedState(_companyInfCheckbox, _resourcesCheckBox, _resPricesCheckBox, _imagesCheckBox));
    }
  }

  void startSyncProcess(String token) async {
    int companyInfCheckbox = _companyInfCheckbox ? 1 : 0;
    int resourcesCheckBox = _resourcesCheckBox ? 1 : 0;
    int resPricesCheckBox = _resPricesCheckBox ? 1 : 0;
    int imagesCheckBox = _imagesCheckBox ? 1 : 0;

    int companyInfSyncedCount = 0;
    int resourcesSyncedCount = 0;
    int resPricesSyncedCount = 0;
    int imagesSyncedCount = 0;

    int syncCnt = (companyInfCheckbox * 1) + (resourcesCheckBox * 2) + (resPricesCheckBox * 2) + imagesCheckBox;
    bool deviceRegistered = false;
    if (syncCnt > 0) {
      emit(DbSyncingState(
        (companyInfCheckbox > 0) ? Status.onProgress : Status.initial,
        (resourcesCheckBox > 0) ? Status.onProgress : Status.initial,
        (resPricesCheckBox > 0) ? Status.onProgress : Status.initial,
        (imagesCheckBox > 0) ? Status.onProgress : Status.initial,
      ));
      PermissionStatus pStatus = await Permission.storage.request();
      if (token.isEmpty) {
        try {
          deviceRegistered = true;
        } catch (e) {
          if (!deviceRegistered) {
            emit(DbSyncErrorState('Device unregistered or cant connect to server'));
          }
          debugPrint(e.toString());
        }
      } else {
        deviceRegistered = true;
      }

      if (deviceRegistered) {
        //region CompanySync
        if (companyInfCheckbox > 0) {
          //region CompanySync
          try {
            debugPrint("Print Getting companyInfo from api");
            srv.getCompany().then((respDkCompanyInfo) async {
              if (respDkCompanyInfo != null) {
                try {
                  debugPrint("Print Got companyInfo. CName: ${respDkCompanyInfo.CName}");
                  TblDkCompany tblDkCompany = TblDkCompany(
                    CId: respDkCompanyInfo.CId,
                    CGuid: respDkCompanyInfo.CGuid,
                    CName: respDkCompanyInfo.CName,
                    CDesc: respDkCompanyInfo.CDesc,
                    CFullName: respDkCompanyInfo.CFullName,
                    Phone1: respDkCompanyInfo.Phone1,
                    Phone2: respDkCompanyInfo.Phone2,
                    Phone3: respDkCompanyInfo.Phone3,
                    Phone4: respDkCompanyInfo.Phone4,
                    WebAddress: respDkCompanyInfo.WebAddress,
                    CEmail: respDkCompanyInfo.CEmail,
                    SyncDateTime: respDkCompanyInfo.SyncDateTime,
                  );
                  await DbHelper.insertUpdateRowByGuid('tbl_dk_company', tblDkCompany, 'CGuid', tblDkCompany.CGuid);
                  debugPrint("Print Company inserted to db");
                  companyInfSyncedCount++;
                } catch (e) {
                  syncCnt = syncCnt - 1;
                  companyInfCheckbox = 4;
                  debugPrint(e.toString());
                }
              }
              syncCnt = syncCnt - 1;
              companyInfCheckbox = 2;
              emit(DbSyncingState(
                (companyInfCheckbox == 1)
                    ? Status.onProgress
                    : (companyInfCheckbox == 2)
                    ? Status.completed
                    : (companyInfCheckbox == 3)
                    ? Status.warning
                    : (companyInfCheckbox == 4)
                    ? Status.failed
                    : Status.initial,
                (resourcesCheckBox == 1)
                    ? Status.onProgress
                    : (companyInfCheckbox == 2)
                    ? Status.completed
                    : (companyInfCheckbox == 3)
                    ? Status.warning
                    : (companyInfCheckbox == 4)
                    ? Status.failed
                    : Status.initial,
                (resPricesCheckBox == 1)
                    ? Status.onProgress
                    : (companyInfCheckbox == 2)
                    ? Status.completed
                    : (companyInfCheckbox == 3)
                    ? Status.warning
                    : (companyInfCheckbox == 4)
                    ? Status.failed
                    : Status.initial,
                (imagesCheckBox == 1)
                    ? Status.onProgress
                    : (companyInfCheckbox == 2)
                    ? Status.completed
                    : (companyInfCheckbox == 3)
                    ? Status.warning
                    : (companyInfCheckbox == 4)
                    ? Status.failed
                    : Status.initial,
              ));
            }).catchError((e) {
              syncCnt = syncCnt - 1;
              companyInfCheckbox = 4;
              emit(DbSyncingState(
                (companyInfCheckbox == 1)
                    ? Status.onProgress
                    : (companyInfCheckbox == 2)
                    ? Status.completed
                    : (companyInfCheckbox == 3)
                    ? Status.warning
                    : (companyInfCheckbox == 4)
                    ? Status.failed
                    : Status.initial,
                (resourcesCheckBox == 1)
                    ? Status.onProgress
                    : (companyInfCheckbox == 2)
                    ? Status.completed
                    : (companyInfCheckbox == 3)
                    ? Status.warning
                    : (companyInfCheckbox == 4)
                    ? Status.failed
                    : Status.initial,
                (resPricesCheckBox == 1)
                    ? Status.onProgress
                    : (companyInfCheckbox == 2)
                    ? Status.completed
                    : (companyInfCheckbox == 3)
                    ? Status.warning
                    : (companyInfCheckbox == 4)
                    ? Status.failed
                    : Status.initial,
                (imagesCheckBox == 1)
                    ? Status.onProgress
                    : (companyInfCheckbox == 2)
                    ? Status.completed
                    : (companyInfCheckbox == 3)
                    ? Status.warning
                    : (companyInfCheckbox == 4)
                    ? Status.failed
                    : Status.initial,
              ));
              debugPrint(e.toString());
            });
          } catch (e) {
            companyInfCheckbox = 4;
            syncCnt = syncCnt - 1;
            emit(DbSyncingState(
              (companyInfCheckbox == 1)
                  ? Status.onProgress
                  : (companyInfCheckbox == 2)
                  ? Status.completed
                  : (companyInfCheckbox == 3)
                  ? Status.warning
                  : (companyInfCheckbox == 4)
                  ? Status.failed
                  : Status.initial,
              (resourcesCheckBox == 1)
                  ? Status.onProgress
                  : (companyInfCheckbox == 2)
                  ? Status.completed
                  : (companyInfCheckbox == 3)
                  ? Status.warning
                  : (companyInfCheckbox == 4)
                  ? Status.failed
                  : Status.initial,
              (resPricesCheckBox == 1)
                  ? Status.onProgress
                  : (companyInfCheckbox == 2)
                  ? Status.completed
                  : (companyInfCheckbox == 3)
                  ? Status.warning
                  : (companyInfCheckbox == 4)
                  ? Status.failed
                  : Status.initial,
              (imagesCheckBox == 1)
                  ? Status.onProgress
                  : (companyInfCheckbox == 2)
                  ? Status.completed
                  : (companyInfCheckbox == 3)
                  ? Status.warning
                  : (companyInfCheckbox == 4)
                  ? Status.failed
                  : Status.initial,
            ));
            debugPrint(e.toString());
          }
          //endregion CompanySync
        }
        //endregion CompanySync

        //region ResourcesSync
        if (resourcesCheckBox == 1) {
          //region ResCategorySync
          try {
            debugPrint("Print Getting ResCategories from api");
            if (pStatus.isPermanentlyDenied) {
              openAppSettings();
              pStatus = await Permission.storage.request();
            } else if (pStatus.isDenied) {
              emit(DbSyncErrorState("Storage permission is denied"));
            }
            if (pStatus.isGranted) {
              srv.getCategories().then((respDkCategories) async {
                debugPrint("Print got resCategories. Cnt: ${respDkCategories.length.toString()}");
                if (respDkCategories.isNotEmpty) {
                  Directory dir = await getApplicationDocumentsDirectory();
                  List<TblDkResCategory> cats = respDkCategories.map((e) {
                    if (e.ResCatIconData.isNotEmpty){
                      String? mimeType = lookupMimeType('test', headerBytes: e.ResCatIconData);
                      String ext = (mimeType != null) ? extensionFromMime(mimeType) : '';
                      String imgFileDir = "${dir.path}/ResCatImages/${e.ResCatId}_${e.ResCatName}.$ext";
                      File imgFile = File(imgFileDir);
                      if (!imgFile.existsSync()) {
                        imgFile.createSync(recursive: true);
                      }
                      imgFile.writeAsBytes(e.ResCatIconData);
                      return e.copyWith(ResCatIconData: Uint8List(0), ResCatIconFilePath: imgFileDir);
                    } else {
                      return e;
                    }
                  }).toList();
                  await DbHelper.insertCategoryList('tbl_dk_res_category', cats);
                }
                syncCnt = syncCnt - 1;
              }).catchError((_) {
                resourcesCheckBox = 4;
                syncCnt = syncCnt - 1;
              });
            }
          } catch (e) {
            resourcesCheckBox = 4;
            syncCnt = syncCnt - 1;
            debugPrint(e.toString());
          }
          //endregion ResCategorySync

          //region ResourcesSync
          try {
            debugPrint("Print Getting Resources from api");
            srv.getResources().then((respDkResources) async {
              debugPrint("Print Got resources. Cnt: ${respDkResources.length.toString()}");
              if (respDkResources.isNotEmpty) {
                await DbHelper.insertResourceList('tbl_dk_resources', respDkResources);
              }
              debugPrint("Print Inserted resources to db");
              resourcesCheckBox = 2;
              resourcesSyncedCount = respDkResources.length;
              syncCnt = syncCnt - 1;
              emit(DbSyncingState(
                (companyInfCheckbox == 1)
                    ? Status.onProgress
                    : (companyInfCheckbox == 2)
                    ? Status.completed
                    : (companyInfCheckbox == 3)
                    ? Status.warning
                    : (companyInfCheckbox == 4)
                    ? Status.failed
                    : Status.initial,
                (resourcesCheckBox == 1)
                    ? Status.onProgress
                    : (companyInfCheckbox == 2)
                    ? Status.completed
                    : (companyInfCheckbox == 3)
                    ? Status.warning
                    : (companyInfCheckbox == 4)
                    ? Status.failed
                    : Status.initial,
                (resPricesCheckBox == 1)
                    ? Status.onProgress
                    : (companyInfCheckbox == 2)
                    ? Status.completed
                    : (companyInfCheckbox == 3)
                    ? Status.warning
                    : (companyInfCheckbox == 4)
                    ? Status.failed
                    : Status.initial,
                (imagesCheckBox == 1)
                    ? Status.onProgress
                    : (companyInfCheckbox == 2)
                    ? Status.completed
                    : (companyInfCheckbox == 3)
                    ? Status.warning
                    : (companyInfCheckbox == 4)
                    ? Status.failed
                    : Status.initial,
              ));
            }).catchError((e) {
              resourcesCheckBox = 4;
              debugPrint(e.toString());
              syncCnt = syncCnt - 1;
              emit(DbSyncingState(
                (companyInfCheckbox == 1)
                    ? Status.onProgress
                    : (companyInfCheckbox == 2)
                    ? Status.completed
                    : (companyInfCheckbox == 3)
                    ? Status.warning
                    : (companyInfCheckbox == 4)
                    ? Status.failed
                    : Status.initial,
                (resourcesCheckBox == 1)
                    ? Status.onProgress
                    : (companyInfCheckbox == 2)
                    ? Status.completed
                    : (companyInfCheckbox == 3)
                    ? Status.warning
                    : (companyInfCheckbox == 4)
                    ? Status.failed
                    : Status.initial,
                (resPricesCheckBox == 1)
                    ? Status.onProgress
                    : (companyInfCheckbox == 2)
                    ? Status.completed
                    : (companyInfCheckbox == 3)
                    ? Status.warning
                    : (companyInfCheckbox == 4)
                    ? Status.failed
                    : Status.initial,
                (imagesCheckBox == 1)
                    ? Status.onProgress
                    : (companyInfCheckbox == 2)
                    ? Status.completed
                    : (companyInfCheckbox == 3)
                    ? Status.warning
                    : (companyInfCheckbox == 4)
                    ? Status.failed
                    : Status.initial,
              ));
            });
          } catch (e) {
            resourcesCheckBox = 4;
            debugPrint(e.toString());
            syncCnt = syncCnt - 1;
            emit(DbSyncingState(
              (companyInfCheckbox == 1)
                  ? Status.onProgress
                  : (companyInfCheckbox == 2)
                  ? Status.completed
                  : (companyInfCheckbox == 3)
                  ? Status.warning
                  : (companyInfCheckbox == 4)
                  ? Status.failed
                  : Status.initial,
              (resourcesCheckBox == 1)
                  ? Status.onProgress
                  : (companyInfCheckbox == 2)
                  ? Status.completed
                  : (companyInfCheckbox == 3)
                  ? Status.warning
                  : (companyInfCheckbox == 4)
                  ? Status.failed
                  : Status.initial,
              (resPricesCheckBox == 1)
                  ? Status.onProgress
                  : (companyInfCheckbox == 2)
                  ? Status.completed
                  : (companyInfCheckbox == 3)
                  ? Status.warning
                  : (companyInfCheckbox == 4)
                  ? Status.failed
                  : Status.initial,
              (imagesCheckBox == 1)
                  ? Status.onProgress
                  : (companyInfCheckbox == 2)
                  ? Status.completed
                  : (companyInfCheckbox == 3)
                  ? Status.warning
                  : (companyInfCheckbox == 4)
                  ? Status.failed
                  : Status.initial,
            ));
          }
          //endregion ResourcesSync
        }
        //endregion ResourcesSync

        //region CleanCartItems
        provider.setCartItems = [];
        //endregion Clean CartItems

        //region ResPrices
        if (resPricesCheckBox == 1) {
          //region tbl_dk_res_price_group
          try {
            srv.getResPriceGroup().then((respDkResPriceGroupList) async {
              if (respDkResPriceGroupList.isNotEmpty) {
                await DbHelper.insertResPriceGroupList('tbl_dk_res_price_group', respDkResPriceGroupList);
              }
              resPricesCheckBox = 2;
              syncCnt = syncCnt - 1;
            }).catchError((_) {
              resPricesCheckBox = 4;
              syncCnt = syncCnt - 1;
            });
          } catch (e) {
            resPricesCheckBox = 4;
            syncCnt = syncCnt - 1;
            debugPrint(e.toString());
          }
          //endregion tbl_dk_res_price_group

          //region ResPrices
          try {
            srv.getResPrices().then((respDkPrices) async {
              debugPrint('Print ${respDkPrices.length}');
              if (respDkPrices.isNotEmpty) {
                await DbHelper.insertResPricesList('tbl_dk_res_price', respDkPrices);
              }
              resPricesCheckBox = 2;
              syncCnt = syncCnt - 1;
              resPricesSyncedCount = respDkPrices.length;
              emit(DbSyncingState(
                (companyInfCheckbox == 1)
                    ? Status.onProgress
                    : (companyInfCheckbox == 2)
                    ? Status.completed
                    : (companyInfCheckbox == 3)
                    ? Status.warning
                    : (companyInfCheckbox == 4)
                    ? Status.failed
                    : Status.initial,
                (resourcesCheckBox == 1)
                    ? Status.onProgress
                    : (companyInfCheckbox == 2)
                    ? Status.completed
                    : (companyInfCheckbox == 3)
                    ? Status.warning
                    : (companyInfCheckbox == 4)
                    ? Status.failed
                    : Status.initial,
                (resPricesCheckBox == 1)
                    ? Status.onProgress
                    : (companyInfCheckbox == 2)
                    ? Status.completed
                    : (companyInfCheckbox == 3)
                    ? Status.warning
                    : (companyInfCheckbox == 4)
                    ? Status.failed
                    : Status.initial,
                (imagesCheckBox == 1)
                    ? Status.onProgress
                    : (companyInfCheckbox == 2)
                    ? Status.completed
                    : (companyInfCheckbox == 3)
                    ? Status.warning
                    : (companyInfCheckbox == 4)
                    ? Status.failed
                    : Status.initial,
              ));
            }).catchError((_) {
              resPricesCheckBox = 4;
              syncCnt = syncCnt - 1;
              emit(DbSyncingState(
                (companyInfCheckbox == 1)
                    ? Status.onProgress
                    : (companyInfCheckbox == 2)
                    ? Status.completed
                    : (companyInfCheckbox == 3)
                    ? Status.warning
                    : (companyInfCheckbox == 4)
                    ? Status.failed
                    : Status.initial,
                (resourcesCheckBox == 1)
                    ? Status.onProgress
                    : (companyInfCheckbox == 2)
                    ? Status.completed
                    : (companyInfCheckbox == 3)
                    ? Status.warning
                    : (companyInfCheckbox == 4)
                    ? Status.failed
                    : Status.initial,
                (resPricesCheckBox == 1)
                    ? Status.onProgress
                    : (companyInfCheckbox == 2)
                    ? Status.completed
                    : (companyInfCheckbox == 3)
                    ? Status.warning
                    : (companyInfCheckbox == 4)
                    ? Status.failed
                    : Status.initial,
                (imagesCheckBox == 1)
                    ? Status.onProgress
                    : (companyInfCheckbox == 2)
                    ? Status.completed
                    : (companyInfCheckbox == 3)
                    ? Status.warning
                    : (companyInfCheckbox == 4)
                    ? Status.failed
                    : Status.initial,
              ));
            });
          } catch (_) {
            resPricesCheckBox = 4;
            syncCnt = syncCnt - 1;
            emit(DbSyncingState(
              (companyInfCheckbox == 1)
                  ? Status.onProgress
                  : (companyInfCheckbox == 2)
                  ? Status.completed
                  : (companyInfCheckbox == 3)
                  ? Status.warning
                  : (companyInfCheckbox == 4)
                  ? Status.failed
                  : Status.initial,
              (resourcesCheckBox == 1)
                  ? Status.onProgress
                  : (companyInfCheckbox == 2)
                  ? Status.completed
                  : (companyInfCheckbox == 3)
                  ? Status.warning
                  : (companyInfCheckbox == 4)
                  ? Status.failed
                  : Status.initial,
              (resPricesCheckBox == 1)
                  ? Status.onProgress
                  : (companyInfCheckbox == 2)
                  ? Status.completed
                  : (companyInfCheckbox == 3)
                  ? Status.warning
                  : (companyInfCheckbox == 4)
                  ? Status.failed
                  : Status.initial,
              (imagesCheckBox == 1)
                  ? Status.onProgress
                  : (companyInfCheckbox == 2)
                  ? Status.completed
                  : (companyInfCheckbox == 3)
                  ? Status.warning
                  : (companyInfCheckbox == 4)
                  ? Status.failed
                  : Status.initial,
            ));
          }
          //endregion ResPrices
        }
        //endregion ResPrices

        //region ImagesSync
        if (imagesCheckBox == 1) {
          int offset = 0;
          int offsetStep = 10;
          try {
            if (pStatus.isPermanentlyDenied) {
              openAppSettings();
              pStatus = await Permission.storage.request();
            } else if (pStatus.isDenied) {
              emit(DbSyncErrorState("Storage permission is denied"));
            }
            if (pStatus.isGranted) {
              String img = '';
              List<Map<String, dynamic>> map = [];
              debugPrint("Print Getting exist images from db");
              map = await DbHelper.rawQueryImageNameAndGuid();
              debugPrint("Print Exists images cnt: ${map.length.toString()}");
              if (map.isNotEmpty) {
                map.map((e) => img = "'$e', $img");
              }
              while (offset >= 0) {
                List<TblDkImage> respDkImages = await srv.getImages(img, offset, 10);
                try {
                  if (respDkImages.isNotEmpty) {
                    debugPrint("Print Got images. Cnt: ${respDkImages.length.toString()}");
                    Directory dir = await getApplicationDocumentsDirectory();
                    List<TblDkImage> images = respDkImages.map((e) {
                      if (e.Image.isNotEmpty){
                        String? mimeType = lookupMimeType('test', headerBytes: e.Image);
                        String ext = (mimeType != null) ? extensionFromMime(mimeType) : '';
                        String imgFileDir = '${dir.path}/ResImages/${e.ImgId}_${e.ImgGuid}.$ext';
                        File imgFile = File(imgFileDir);
                        if (!imgFile.existsSync()) {
                          imgFile.createSync(recursive: true);
                        }
                        imgFile.writeAsBytes(e.Image);
                        return e.copyWith(Image: Uint8List(0), FilePath: imgFileDir);
                      } else {
                        return e;
                      }

                    }).toList();
                    await DbHelper.insertImagesList('tbl_dk_image', images);
                    debugPrint("Print Images inserted to db");
                    if (respDkImages.length == offsetStep) {
                      offset = offset + offsetStep;
                    } else {
                      offset = -1;
                    }
                    imagesSyncedCount = imagesSyncedCount + respDkImages.length;
                  }
                } catch (e) {
                  debugPrint(e.toString());
                  imagesCheckBox = 4;
                  syncCnt = syncCnt - 1;
                }
              }
              imagesCheckBox = 2;
              syncCnt = syncCnt - 1;
            }
          } catch (e) {
            debugPrint(e.toString());
            imagesCheckBox = 4;
            syncCnt = syncCnt - 1;
            debugPrint(e.toString());
          }
        }
        //endregion ImagesSync
      } else {
        debugPrint("Print Access is denied state");
        emit(AccessDeniedState());
      }

      int syncCntChanges = syncCnt;
      while (syncCnt > 0) {
        if (syncCntChanges != syncCnt) {
          emit(DbSyncingState(
            (companyInfCheckbox == 1)
                ? Status.onProgress
                : (companyInfCheckbox == 2)
                    ? Status.completed
                    : (companyInfCheckbox == 3)
                        ? Status.warning
                        : (companyInfCheckbox == 4)
                            ? Status.failed
                            : Status.initial,
            (resourcesCheckBox == 1)
                ? Status.onProgress
                : (companyInfCheckbox == 2)
                    ? Status.completed
                    : (companyInfCheckbox == 3)
                        ? Status.warning
                        : (companyInfCheckbox == 4)
                            ? Status.failed
                            : Status.initial,
            (resPricesCheckBox == 1)
                ? Status.onProgress
                : (companyInfCheckbox == 2)
                    ? Status.completed
                    : (companyInfCheckbox == 3)
                        ? Status.warning
                        : (companyInfCheckbox == 4)
                            ? Status.failed
                            : Status.initial,
            (imagesCheckBox == 1)
                ? Status.onProgress
                : (companyInfCheckbox == 2)
                    ? Status.completed
                    : (companyInfCheckbox == 3)
                        ? Status.warning
                        : (companyInfCheckbox == 4)
                            ? Status.failed
                            : Status.initial,
          ));
          syncCntChanges = syncCnt;
        }
        await Future.delayed(const Duration(seconds: 1));
      }

      emit(DbSyncedState(
          (companyInfCheckbox == 1)
              ? Status.onProgress
              : (companyInfCheckbox == 2)
                  ? Status.completed
                  : (companyInfCheckbox == 3)
                      ? Status.warning
                      : (companyInfCheckbox == 4)
                          ? Status.failed
                          : Status.initial,
          (resourcesCheckBox == 1)
              ? Status.onProgress
              : (companyInfCheckbox == 2)
                  ? Status.completed
                  : (companyInfCheckbox == 3)
                      ? Status.warning
                      : (companyInfCheckbox == 4)
                          ? Status.failed
                          : Status.initial,
          (resPricesCheckBox == 1)
              ? Status.onProgress
              : (companyInfCheckbox == 2)
                  ? Status.completed
                  : (companyInfCheckbox == 3)
                      ? Status.warning
                      : (companyInfCheckbox == 4)
                          ? Status.failed
                          : Status.initial,
          (imagesCheckBox == 1)
              ? Status.onProgress
              : (companyInfCheckbox == 2)
                  ? Status.completed
                  : (companyInfCheckbox == 3)
                      ? Status.warning
                      : (companyInfCheckbox == 4)
                          ? Status.failed
                          : Status.initial,
          companyInfSyncedCount,
          resourcesSyncedCount,
          resPricesSyncedCount,
          imagesSyncedCount,
          ''));
    }
  }
}
