// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'applicant_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicantResp _$ApplicantRespFromJson(Map<String, dynamic> json) {
  return ApplicantResp(
    status: json['status'] as bool,
    message: json['message'] as String,
    type: json['type'] as String,
    link: json['link'] as String,
    applicant: (json['applicant'] as List)
        ?.map(
            (e) => e == null ? null : User.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ApplicantRespToJson(ApplicantResp instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'type': instance.type,
      'link': instance.link,
      'applicant': instance.applicant?.map((e) => e?.toJson())?.toList(),
    };
