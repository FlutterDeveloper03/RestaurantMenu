// ignore_for_file: non_constant_identifier_names

import 'model.dart';

class TblDkResPrice extends Model{
  final int ResPriceId;
  final int ResPriceGroupId;
  final int CurrencyId;
  final int ResId;
  final String ResPriceRegNo;
  final double ResPriceValue;
  final DateTime? PriceStartDate;
  final DateTime? PriceEndDate;
  final DateTime? SyncDateTime;

  TblDkResPrice({
    required this.ResPriceId,
    required this.ResPriceGroupId,
    required this.CurrencyId,
    required this.ResId,
    required this.ResPriceRegNo,
    required this.ResPriceValue,
    required this.PriceStartDate,
    required this.PriceEndDate,
    required this.SyncDateTime,
  });

  Map<String,dynamic> toMap()=>{
    "ResPriceId":ResPriceId,
    "ResPriceGroupId":ResPriceGroupId,
    "CurrencyId":CurrencyId,
    "ResId":ResId,
    "ResPriceRegNo":ResPriceRegNo,
    "ResPriceValue":ResPriceValue,
    "PriceStartDate":PriceStartDate?.millisecondsSinceEpoch ?? 0,
    "PriceEndDate":PriceEndDate?.millisecondsSinceEpoch ?? 0,
    "SyncDateTime":SyncDateTime?.millisecondsSinceEpoch,
  };

  static TblDkResPrice fromMap(Map<String,dynamic> map)=>
    TblDkResPrice(
        ResPriceId:map["ResPriceId"] ?? 0,
        ResPriceGroupId:map["ResPriceGroupId"] ?? 0,
        CurrencyId:map["CurrencyId"] ?? 0,
        ResId:map["ResId"] ?? 0,
        ResPriceRegNo:map["ResPriceRegNo"] ?? "",
        ResPriceValue:map["ResPriceValue"] ?? 0,
        PriceStartDate:DateTime.fromMillisecondsSinceEpoch(map["PriceStartDate"] ?? 0),
        PriceEndDate:DateTime.fromMillisecondsSinceEpoch(map["PriceEndDate"] ?? 0),
        SyncDateTime:DateTime.fromMillisecondsSinceEpoch(map["SyncDateTime"]),
    );



  Map<String, dynamic> toJson() =>
      {
        "ResPriceId":ResPriceId,
        "ResPriceGroupId":ResPriceGroupId,
        "CurrencyId":CurrencyId,
        "ResId":ResId,
        "ResPriceRegNo":ResPriceRegNo,
        "ResPriceValue":ResPriceValue,
        "PriceStartDate":PriceStartDate?.toIso8601String(),
        "PriceEndDate":PriceEndDate?.toIso8601String(),
        "SyncDateTime":SyncDateTime?.toIso8601String(),
      };

  TblDkResPrice.fromJson(Map<String, dynamic> json)
      : ResPriceId = json["ResPriceId"] ?? 0,
        ResPriceGroupId = json["ResPriceGroupId"] ?? 0,
        CurrencyId = json["CurrencyId"] ?? 0,
        ResId = json["ResId"] ?? 0,
        ResPriceRegNo = json["ResPriceRegNo"] ?? "",
        ResPriceValue = json["ResPriceValue"] ?? 0,
        PriceStartDate = (json["PriceStartDate"]!=null) ? DateTime.parse(json["PriceStartDate"]) : null,
        PriceEndDate = (json["PriceEndDate"]!=null) ? DateTime.parse(json["PriceEndDate"]) : null,
        SyncDateTime = (json["SyncDateTime"]!=null) ? DateTime.parse(json["SyncDateTime"]) : null;
}