// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:typed_data';
import 'model.dart';

class TblDkResCategory extends Model {
  final int ResCatId;
  final int ResOwnerCatId;
  final int ResCatVisibleIndex;
  final int IsMain;
  final String ResCatName;
  final String ResCatNameTm;
  final String ResCatNameRu;
  final String ResCatNameEn;
  final String ResCatDesc;
  final String ResCatIconName;
  final String ResCatIconFilePath;
  final Uint8List ResCatIconData;
  final DateTime? SyncDateTime;

  TblDkResCategory({
    required this.ResCatId,
    required this.ResOwnerCatId,
    required this.ResCatVisibleIndex,
    required this.IsMain,
    required this.ResCatName,
    required this.ResCatNameTm,
    required this.ResCatNameRu,
    required this.ResCatNameEn,
    required this.ResCatDesc,
    required this.ResCatIconName,
    required this.ResCatIconFilePath,
    required this.ResCatIconData,
    required this.SyncDateTime,
  });

  @override
  Map<String, dynamic> toMap() => {
        'ResCatId': ResCatId,
        'ResOwnerCatId': ResOwnerCatId,
        'ResCatVisibleIndex': ResCatVisibleIndex,
        'IsMain': IsMain,
        'ResCatName': ResCatName,
        'ResCatNameTm': ResCatNameTm,
        'ResCatNameRu': ResCatNameRu,
        'ResCatNameEn': ResCatNameEn,
        'ResCatDesc': ResCatDesc,
        'ResCatIconName': ResCatIconName,
        'ResCatIconFilePath': ResCatIconFilePath,
        'ResCatIconData': ResCatIconData,
        'SyncDateTime': SyncDateTime.toString(),
      };

  static TblDkResCategory fromMap(Map<String, dynamic> map) => TblDkResCategory(
      ResCatId: map['ResCatId'] ?? 0,
      ResOwnerCatId: map['ResOwnerCatId'] ?? 0,
      ResCatVisibleIndex: map['ResCatVisibleIndex'] ?? 0,
      IsMain: map['IsMain'] ?? 0,
      ResCatName: map['ResCatName']?.toString() ?? "",
      ResCatNameTm: map['ResCatNameTm']?.toString() ?? "",
      ResCatNameRu: map['ResCatNameRu']?.toString() ?? "",
      ResCatNameEn: map['ResCatNameEn']?.toString() ?? "",
      ResCatDesc: map['ResCatDesc']?.toString() ?? "",
      ResCatIconName: map['ResCatIconName']?.toString() ?? "",
      ResCatIconFilePath: map['ResCatIconFilePath']?.toString() ?? "",
      ResCatIconData: map['ResCatIconData'] ?? Uint8List(0),
      SyncDateTime: DateTime.parse(map['SyncDateTime'] ?? '1900-01-01'));

  TblDkResCategory.fromJson(Map<String, dynamic> json)
      : ResCatId = json['ResCatId'] ?? 0,
        ResOwnerCatId = json['ResOwnerCatId'] ?? 0,
        ResCatVisibleIndex = json['ResCatVisibleIndex'] ?? 0,
        IsMain = json['IsMain'] ?? 0,
        ResCatName = json['ResCatName'] ?? "",
        ResCatNameTm = json['ResCatNameTm'] ?? "",
        ResCatNameRu = json['ResCatNameRu'] ?? "",
        ResCatNameEn = json['ResCatNameEn'] ?? "",
        ResCatDesc = json['ResCatDesc'] ?? "",
        ResCatIconName = json['ResCatIconName'] ?? "",
        ResCatIconFilePath = json['ResCatIconFilePath'] ?? "",
        ResCatIconData = base64Decode(json['ResCatIconData'] ?? ""),
        SyncDateTime = DateTime.parse(json['SyncDateTime'] ?? '1900-01-01');

  TblDkResCategory copyWith({
    int? ResOwnerCatId,
    int? ResCatVisibleIndex,
    int? IsMain,
    String? ResCatName,
    String? ResCatNameTm,
    String? ResCatNameRu,
    String? ResCatNameEn,
    String? ResCatDesc,
    String? ResCatIconName,
    String? ResCatIconFilePath,
    Uint8List? ResCatIconData,
  }) {
    return TblDkResCategory(
        ResCatId: ResCatId,
        ResOwnerCatId: ResOwnerCatId ?? this.ResOwnerCatId,
        ResCatVisibleIndex: ResCatVisibleIndex ?? this.ResCatVisibleIndex,
        IsMain: IsMain ?? this.IsMain,
        ResCatName: ResCatName ?? this.ResCatName,
        ResCatNameTm: ResCatNameTm ?? this.ResCatNameTm,
        ResCatNameRu: ResCatNameRu ?? this.ResCatNameRu,
        ResCatNameEn: ResCatNameEn ?? this.ResCatNameEn,
        ResCatDesc: ResCatDesc ?? this.ResCatDesc,
        ResCatIconName: ResCatIconName ?? this.ResCatIconName,
        ResCatIconFilePath: ResCatIconFilePath ?? this.ResCatIconFilePath,
        ResCatIconData: ResCatIconData ?? this.ResCatIconData,
        SyncDateTime: SyncDateTime);
  }
}
