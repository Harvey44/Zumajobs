// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    age: json['age'] as String,
    degree: json['degree'] as String,
    skills: json['skills'] as String,
    picture: json['picture'] as String,
    cv: json['cv'] as String,
    video: json['video'] as String,
    phone: json['phone'] as String,
    email: json['email'] as String,
    logo: json['logo'] as String,
    username: json['username'] as String,
    fullname: json['fullname'] as String,
    about: json['about'] as String,
    experience: json['experience'] as String,
    first_name: json['first_name'] as String,
    last_name: json['last_name'] as String,
    country: json['country'] as String,
    views: json['views'] as int,
    applied: json['applied'] as int,
    company_name: json['company_name'] as String,
    reg_number: json['reg_number'] as String,
    company_address: json['company_address'] as String,
    premium: json['premium'] as bool,
    type: json['type'] as String,
    id: json['id'] as int,
  )..sector_name = json['sector_name'] as String;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'premium': instance.premium,
      'age': instance.age,
      'degree': instance.degree,
      'skills': instance.skills,
      'picture': instance.picture,
      'cv': instance.cv,
      'video': instance.video,
      'phone': instance.phone,
      'email': instance.email,
      'logo': instance.logo,
      'username': instance.username,
      'fullname': instance.fullname,
      'about': instance.about,
      'experience': instance.experience,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'country': instance.country,
      'sector_name': instance.sector_name,
      'company_name': instance.company_name,
      'reg_number': instance.reg_number,
      'company_address': instance.company_address,
      'type': instance.type,
      'id': instance.id,
      'views': instance.views,
      'applied': instance.applied,
    };
