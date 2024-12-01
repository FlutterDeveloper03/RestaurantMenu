// ignore_for_file: non_constant_identifier_names

import 'model.dart';

class TblDkResPriceGroup extends Model {
  final int ResPriceGroupId;
  final String ResPriceGroupName;
  final String ResPriceGroupDesc;
  final DateTime? SyncDateTime;

  TblDkResPriceGroup({
    required this.ResPriceGroupId,
    required this.ResPriceGroupName,
    required this.ResPriceGroupDesc,
    required this.SyncDateTime,
  });

  Map<String, dynamic> toMap() => {
        "ResPriceGroupId": ResPriceGroupId,
        "ResPriceGroupName": ResPriceGroupName,
        "ResPriceGroupDesc": ResPriceGroupDesc,
        "SyncDateTime": (SyncDateTime != null) ? SyncDateTime.toString() : null,
      };

  static TblDkResPriceGroup fromMap(Map<String, dynamic> map) {
    return TblDkResPriceGroup(
      ResPriceGroupId: map["ResPriceGroupId"] ?? 0,
      ResPriceGroupName: map["ResPriceGroupName"]?.toString() ?? "",
      ResPriceGroupDesc: map["ResPriceGroupDesc"]?.toString() ?? "",
      SyncDateTime: DateTime.parse(map["SyncDateTime"] ?? '1900-01-01'),
    );
  }
}
