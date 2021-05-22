// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModelResp _$ModelRespFromJson(Map<String, dynamic> json) {
  return ModelResp(
    status: json['status'] as bool,
    message: json['message'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    type: json['type'] as String,
    privacy: json['privacy'] as String,
    amount: json['amount'] as int,
  );
}

Map<String, dynamic> _$ModelRespToJson(ModelResp instance) => <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'name': instance.name,
      'email': instance.email,
      'type': instance.type,
      'privacy': instance.privacy,
      'amount': instance.amount,
    };
