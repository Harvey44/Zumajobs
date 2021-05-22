// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserResp _$UserRespFromJson(Map<String, dynamic> json) {
  return UserResp(
    status: json['status'] as bool,
    message: json['message'] as String,
    username: json['username'] as String,
    type: json['type'] as String,
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    employer: json['employer'] == null
        ? null
        : User.fromJson(json['employer'] as Map<String, dynamic>),
    applicant: json['applicant'] == null
        ? null
        : User.fromJson(json['applicant'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UserRespToJson(UserResp instance) => <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'username': instance.username,
      'type': instance.type,
      'user': instance.user?.toJson(),
      'employer': instance.employer?.toJson(),
      'applicant': instance.applicant?.toJson(),
    };
