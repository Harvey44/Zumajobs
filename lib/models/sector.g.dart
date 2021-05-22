// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sector.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sector _$SectorFromJson(Map<String, dynamic> json) {
  return Sector(
    name: json['name'] as String,
    description: json['description'] as String,
    image: json['image'] as String,
    id: json['id'] as int,
  );
}

Map<String, dynamic> _$SectorToJson(Sector instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'image': instance.image,
      'id': instance.id,
    };
