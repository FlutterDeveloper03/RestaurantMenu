// ignore_for_file: non_constant_identifier_names

import 'package:restaurantmenu/models/model.dart';

class TblDkCartItem extends Model {
  final int ResId;
  final String ResRegNo;
  final String ResName;
  final String ResNameTm;
  final String ResNameRu;
  final String ResNameEn;
  final int ItemCount;
  final int ResPriceGroupId;
  final double ResPriceValue;
  final double ItemPriceTotal;
  final double ResPendingTotalAmount;
  final String ImageFilePath;
  final DateTime? SyncDateTime;

  TblDkCartItem(
      {required this.ResId,
      required this.ResRegNo,
      required this.ResName,
      required this.ResNameTm,
      required this.ResNameRu,
      required this.ResNameEn,
      required this.ItemCount,
      required this.ResPriceGroupId,
      required this.ResPriceValue,
      required this.ItemPriceTotal,
      required this.ResPendingTotalAmount,
      required this.ImageFilePath,
      required this.SyncDateTime});

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'ResId': ResId,
      'ResRegNo': ResRegNo,
      'ResName': ResName,
      'ResNameTm': ResNameTm,
      'ResNameRu': ResNameRu,
      'ResNameEn': ResNameEn,
      'ItemCount': ItemCount,
      'ResPriceGroupId': ResPriceGroupId,
      'ResPriceValue': ResPriceValue,
      'ItemPriceTotal': ItemPriceTotal,
      'ResPendingTotalAmount': ResPendingTotalAmount,
      'ImageFilePath': ImageFilePath,
      'SyncDateTime': SyncDateTime
    };
    return map;
  }

  static TblDkCartItem fromMap(Map<String, dynamic> map) {
    return TblDkCartItem(
        ResId: map['ResId'] ?? 0,
        ResRegNo: map['ResRegNo']?.toString() ?? "",
        ResName: map['ResName']?.toString() ?? "",
        ResNameTm: map['ResNameTm']?.toString() ?? "",
        ResNameRu: map['ResNameRu']?.toString() ?? "",
        ResNameEn: map['ResNameEn']?.toString() ?? "",
        ItemCount: map['ItemCount'] ?? 0,
        ResPriceGroupId: map['ResPriceGroupId'] ?? 0,
        ResPriceValue: map['ResPriceValue'] ?? 0,
        ItemPriceTotal: map['ItemPriceTotal'] ?? 0,
        ResPendingTotalAmount: map['ResPendingTotalAmount'] ?? 0,
        ImageFilePath: map['ImageFilePath'] ?? '',
        SyncDateTime: map['SyncDateTime']);
  }

  TblDkCartItem copyWith({
    int? ResId,
    String? ResRegNo,
    String? ResName,
    String? ResNameTm,
    String? ResNameRu,
    String? ResNameEn,
    int? ItemCount,
    int? ResPriceGroupId,
    double? ResPriceValue,
    double? ItemPriceTotal,
    double? ResPendingTotalAmount,
    String? ImageFilePath,
    DateTime? SyncDateTime,
  }) {
    return TblDkCartItem(
        ResId:ResId ?? this.ResId,
        ResRegNo:ResRegNo ?? this.ResRegNo,
        ResName:ResName ?? this.ResName,
        ResNameTm:ResNameTm ?? this.ResName,
        ResNameRu:ResNameRu ?? this.ResName,
        ResNameEn:ResNameEn ?? this.ResName,
        ItemCount:ItemCount ?? this.ItemCount,
        ResPriceGroupId:ResPriceGroupId ?? this.ResPriceGroupId,
        ResPriceValue:ResPriceValue ?? this.ResPriceValue,
        ItemPriceTotal:ItemPriceTotal ?? this.ItemPriceTotal,
        ResPendingTotalAmount:ResPendingTotalAmount ?? this.ResPendingTotalAmount,
        ImageFilePath:ImageFilePath ?? this.ImageFilePath,
        SyncDateTime:SyncDateTime,
    );
  }
}
