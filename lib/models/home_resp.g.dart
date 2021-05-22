// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeResp _$HomeRespFromJson(Map<String, dynamic> json) {
  return HomeResp(
    status: json['status'] as bool,
    message: json['message'] as String,
    fullname: json['fullname'] as String,
    type: json['type'] as String,
    link: json['link'] as String,
    amount: json['amount'] as String,
    vacancy: (json['vacancy'] as List)
        ?.map((e) =>
            e == null ? null : Vacancy.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    applicants: (json['applicants'] as List)
        ?.map(
            (e) => e == null ? null : User.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    applicant: json['applicant'] == null
        ? null
        : User.fromJson(json['applicant'] as Map<String, dynamic>),
    employer: json['employer'] == null
        ? null
        : User.fromJson(json['employer'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$HomeRespToJson(HomeResp instance) => <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'fullname': instance.fullname,
      'type': instance.type,
      'link': instance.link,
      'amount': instance.amount,
      'vacancy': instance.vacancy?.map((e) => e?.toJson())?.toList(),
      'applicants': instance.applicants?.map((e) => e?.toJson())?.toList(),
      'applicant': instance.applicant?.toJson(),
      'employer': instance.employer?.toJson(),
    };
