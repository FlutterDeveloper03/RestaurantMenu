// ignore_for_file: non_constant_identifier_names

import 'model.dart';
class TblDkResource extends Model{
  final int ResId;
  final String ResGuid;
  final int ResCatId;
  final String ResName;
  final String ResDesc;
  final String ResFullDesc;
  final String ResNameTm;
  final String ResNameRu;
  final String ResNameEn;
  final DateTime? SyncDateTime;

  TblDkResource({
    required this.ResId,
    required this.ResGuid,
    required this.ResCatId,
    required this.ResName,
    required this.ResDesc,
    required this.ResFullDesc,
    required this.ResNameTm,
    required this.ResNameRu,
    required this.ResNameEn,
    required this.SyncDateTime,
  });

  @override
  Map<String,dynamic> toMap()=>{
    "ResId":ResId,
    "ResGuid":ResGuid,
    "ResCatId":ResCatId,
    "ResName":ResName,
    "ResDesc":ResDesc,
    "ResFullDesc":ResFullDesc,
    "ResNameTm":ResNameTm,
    "ResNameRu":ResNameRu,
    "ResNameEn":ResNameEn,
    "SyncDateTime":(SyncDateTime!=null) ? SyncDateTime?.millisecondsSinceEpoch : null,
  };

  static TblDkResource fromMap(Map<String,dynamic> map)=>
    TblDkResource(
      ResId:map['ResId'] ?? 0,
      ResGuid:map['ResGuid'] ?? "",
      ResCatId:map['ResCatId'] ?? 0,
      ResName:map['ResName']?.toString() ?? "",
      ResDesc:map['ResDesc']?.toString() ?? "",
      ResFullDesc:map['ResFullDesc']?.toString() ?? "",
      ResNameTm:map['ResNameTm']?.toString() ?? "",
      ResNameRu:map['ResNameRu']?.toString() ?? "",
      ResNameEn:map['ResNameEn']?.toString() ?? "",
      SyncDateTime:(map['SyncDateTime']!=null) ? DateTime.fromMillisecondsSinceEpoch(map['SyncDateTime'] ?? 0) : null,
        );
}