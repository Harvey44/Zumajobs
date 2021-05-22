// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vacancy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vacancy _$VacancyFromJson(Map<String, dynamic> json) {
  return Vacancy(
    position: json['position'] as String,
    description: json['description'] as String,
    logo: json['logo'] as String,
    salary: json['salary'] as String,
    experience: json['experience'] as String,
    location: json['location'] as String,
    company: json['company'] as String,
    duration: json['duration'] as String,
    email: json['email'] as String,
    remote: json['remote'] as bool,
  );
}

Map<String, dynamic> _$VacancyToJson(Vacancy instance) => <String, dynamic>{
      'position': instance.position,
      'description': instance.description,
      'logo': instance.logo,
      'experience': instance.experience,
      'salary': instance.salary,
      'location': instance.location,
      'company': instance.company,
      'duration': instance.duration,
      'email': instance.email,
      'remote': instance.remote,
    };
