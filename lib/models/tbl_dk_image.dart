// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:typed_data';

import 'model.dart';

class TblDkImage extends Model {
  final int? ImgId;
  final String ImgGuid;
  final int ResCatId;
  final int CId;
  final int ResId;
  final String FileName;
  final String FileHash;
  final String FilePath;
  final Uint8List Image;
  final DateTime? SyncDateTime;

  TblDkImage({
    required this.ImgId,
    required this.ImgGuid,
    required this.ResCatId,
    required this.CId,
    required this.ResId,
    required this.FileName,
    required this.FileHash,
    required this.FilePath,
    required this.Image,
    required this.SyncDateTime,
  });

  @override
  Map<String, dynamic> toMap() =>
      {
        'ImgId': ImgId,
        'ImgGuid': ImgGuid,
        'ResCatId': ResCatId,
        'CId': CId,
        'ResId': ResId,
        'FileName': FileName,
        'FileHash': FileHash,
        'FilePath': FilePath,
        'Image': Image,
        'SyncDateTime': (SyncDateTime!=null) ? SyncDateTime?.millisecondsSinceEpoch : null,
      };

  static TblDkImage fromMap(Map<String, dynamic> map) =>
      TblDkImage(
          ImgId: map['ImgId'] ?? 0,
          ImgGuid: map['ImgGuid'] ?? "",
          ResCatId: map['ResCatId'] ?? 0,
          CId: map['CId'] ?? 0,
          ResId: map['ResId'] ?? 0,
          FileName: map['FileName']?.toString() ?? "",
          FileHash: map['FileHash']?.toString() ?? "",
          FilePath: map['FilePath']?.toString() ?? "",
          Image: map['Image'] ?? Uint8List(0),
          SyncDateTime: (map['SyncDateTime']!=null) ? DateTime.fromMillisecondsSinceEpoch(map['SyncDateTime'] ?? 0) : null);


  Map<String, dynamic> toJson() =>
      {
        "ImgId": ImgId,
        "ImgGuid": ImgGuid,
        "ResCatId": ResCatId,
        "CId": CId,
        "ResId": ResId,
        "FileName": FileName,
        "FileHash": FileHash,
        "FilePath": FilePath,
        "Image": Image,
        "SyncDateTime": SyncDateTime
      };

  TblDkImage.fromJson(Map<String, dynamic> json)
      : ImgId = json['ImgId'] ?? 0,
        ImgGuid = json['ImgGuid'] ?? "",
        ResCatId = json['ResCatId'] ?? 0,
        CId = json['CId'] ?? 0,
        ResId = json['ResId'] ?? 0,
        FileName = json['FileName']?.toString() ?? "",
        FileHash = json['FileHash']?.toString() ?? "",
        FilePath = json['FilePath']?.toString() ?? "",
        Image=base64Decode(json['Image'] ?? ''),
        SyncDateTime = DateTime.parse(json['SyncDateTime'] ?? '1900-01-01');

  TblDkImage copyWith({
    String? ImgGuid,
    int? ResCatId,
    int? CId,
    int? ResId,
    String? FileName,
    String? FileHash,
    String? FilePath,
    Uint8List? Image,
  }) {
    return TblDkImage(
        ImgId: ImgId,
        ImgGuid: ImgGuid ?? this.ImgGuid,
        ResCatId: ResCatId ?? this.ResCatId,
        CId: CId ?? this.CId,
        ResId: ResId ?? this.ResId,
        FileName: FileName ?? this.FileName,
        FileHash: FileHash ?? this.FileHash,
        FilePath: FilePath ?? this.FilePath,
        Image: Image ?? this.Image,
        SyncDateTime: SyncDateTime);
  }

}
