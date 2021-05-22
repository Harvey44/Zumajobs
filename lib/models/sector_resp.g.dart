// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sector_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SectorResp _$SectorRespFromJson(Map<String, dynamic> json) {
  return SectorResp(
    status: json['status'] as bool,
    message: json['message'] as String,
    type: json['type'] as String,
    sector: (json['sector'] as List)
        ?.map((e) =>
            e == null ? null : Sector.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SectorRespToJson(SectorResp instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'type': instance.type,
      'sector': instance.sector?.map((e) => e?.toJson())?.toList(),
    };
