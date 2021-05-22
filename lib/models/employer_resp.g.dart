// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employer_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployerResp _$EmployerRespFromJson(Map<String, dynamic> json) {
  return EmployerResp(
    status: json['status'] as bool,
    message: json['message'] as String,
    type: json['type'] as String,
    employers: (json['employers'] as List)
        ?.map(
            (e) => e == null ? null : User.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$EmployerRespToJson(EmployerResp instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'type': instance.type,
      'employers': instance.employers?.map((e) => e?.toJson())?.toList(),
    };
