// ignore_for_file: non_constant_identifier_names

import 'model.dart';
class TblDkCompany extends Model{
  final int  CId;
  final String CGuid;
  final String CName;
  final String CDesc;
  final String CFullName;
  final String Phone1;
  final String Phone2;
  final String Phone3;
  final String Phone4;
  final String WebAddress;
  final String CEmail;
  final DateTime? SyncDateTime;

  TblDkCompany({
    required this.CId,
    required this.CGuid,
    required this.CName,
    required this.CDesc,
    required this.CFullName,
    required this.Phone1,
    required this.Phone2,
    required this.Phone3,
    required this.Phone4,
    required this.WebAddress,
    required this.CEmail,
    required this.SyncDateTime,
  });

  @override
  Map<String,dynamic> toMap()=>{
    "CId":CId,
    "CGuid":CGuid,
    "CName":CName,
    "CDesc":CDesc,
    "CFullName":CFullName,
    "Phone1":Phone1,
    "Phone2":Phone2,
    "Phone3":Phone3,
    "Phone4":Phone4,
    "WebAddress":WebAddress,
    "CEmail":CEmail,
    "SyncDateTime":(SyncDateTime!=null) ? SyncDateTime?.millisecondsSinceEpoch : null,
  };

  static TblDkCompany fromMap(Map<String,dynamic> map)=>
      TblDkCompany(
        CId: map['CId'] ?? 0,
        CGuid: map['CGuid'] ?? "",
        CName: map['CName'] ?? "",
        CDesc: map['CDesc'] ?? "",
        CFullName: map['CFullName'] ?? "",
        Phone1: map['Phone1'] ?? "",
        Phone2: map['Phone2'] ?? "",
        Phone3: map['Phone3'] ?? "",
        Phone4: map['Phone4'] ?? "",
        WebAddress: map['WebAddress'] ?? "",
        CEmail: map['CEmail'] ?? "",
        SyncDateTime:(map['SyncDateTime']!=null) ? DateTime.fromMillisecondsSinceEpoch(map['SyncDateTime'] ?? 0) : null,
      );

  TblDkCompany.fromJson(Map<String, dynamic> json)
      : CId = json['CId'] ?? 0,
        CGuid = json['CGuid'] ?? "",
        CName = json['CName'] ?? "",
        CDesc = json['CDesc'] ?? "",
        CFullName = json['CFullName'] ?? "",
        Phone1 = json['Phone1'] ?? "",
        Phone2 = json['Phone2'] ?? "",
        Phone3 = json['Phone3'] ?? "",
        Phone4 = json['Phone4'] ?? "",
        WebAddress = json['WebAddress'] ?? "",
        CEmail = json['CEmail'] ?? "",
        SyncDateTime =(json['SyncDateTime']!=null) ? DateTime.parse(json['SyncDateTime']) : null;
}