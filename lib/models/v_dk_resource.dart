// ignore_for_file: non_constant_identifier_names

class VDkResource {
  final int ResId;
  final String ResGuid;
  final int ResCatId;
  final double SalePrice;
  final String ResName;
  final String ResNameTm;
  final String ResNameRu;
  final String ResNameEn;
  final String ResDesc;
  final String ResFullDesc;
  final String ImageFilePath;
  VDkResource({
      required this.ResId,
      required this.ResGuid,
      required this.ResCatId,
      required this.SalePrice,
      required this.ResName,
      required this.ResNameTm,
      required this.ResNameRu,
      required this.ResNameEn,
      required this.ResDesc,
      required this.ResFullDesc,
      required this.ImageFilePath});

  static VDkResource fromMap(Map<String,dynamic> map){
    return VDkResource(
        ResId: map["ResId"] ?? 0,
        ResGuid:map["ResGuid"]?.toString() ?? "",
        ResCatId:map["ResCatId"] ?? 0,
        SalePrice:map["ResPriceValue"] ?? 0,
        ResName:map["ResName"]?.toString() ?? "",
        ResNameTm:map["ResNameTm"]?.toString() ?? "",
        ResNameRu:map["ResNameRu"]?.toString() ?? "",
        ResNameEn:map["ResNameEn"]?.toString() ?? "",
        ResDesc:map["ResDesc"]?.toString() ?? "",
        ResFullDesc:map["ResFullDesc"]?.toString() ?? "",
        ImageFilePath:map["FilePath"] ?? "",
    );
  }
  VDkResource copyWith({
    int? ResId,
    String? ResGuid,
    String? ResName,
    String? ResNameTm,
    String? ResNameRu,
    String? ResNameEn,
    String? ResDesc,
    String? ResFullDesc,
    double? SalePrice,
    int? ResCatId,
    String? ImageFilePath,
  }) {
    return VDkResource(
      ResId:ResId ?? this.ResId,
      ResGuid:ResGuid ?? this.ResGuid,
      ResName:ResName ?? this.ResName,
      ResNameTm:ResNameTm ?? this.ResNameTm,
      ResNameRu:ResNameRu ?? this.ResNameRu,
      ResNameEn:ResNameEn ?? this.ResNameEn,
      ResCatId: ResCatId ?? this.ResCatId,
      ResDesc: ResDesc ?? this.ResDesc,
      ResFullDesc: ResFullDesc ?? this.ResFullDesc,
      SalePrice: SalePrice ?? this.SalePrice,
      ImageFilePath:ImageFilePath ?? this.ImageFilePath,
    );
  }
}
