// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vacancy_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VacancyResp _$VacancyRespFromJson(Map<String, dynamic> json) {
  return VacancyResp(
    status: json['status'] as bool,
    message: json['message'] as String,
    vacancy: (json['vacancy'] as List)
        ?.map((e) =>
            e == null ? null : Vacancy.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$VacancyRespToJson(VacancyResp instance) =>
    <String, dynamic>{
      'status': instance.status,
      'vacancy': instance.vacancy?.map((e) => e?.toJson())?.toList(),
      'message': instance.message,
    };
