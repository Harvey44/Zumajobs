import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  bool premium;
  String age,
      degree,
      skills,
      picture,
      cv,
      video,
      phone,
      email,
      logo,
      username,
      fullname,
      about,
      experience,
      first_name,
      last_name,
      country,
      sector_name,
      company_name,
      reg_number,
      company_address,
      type;
  int id, views, applied;
  User(
      {this.age,
      this.degree,
      this.skills,
      this.picture,
      this.cv,
      this.video,
      this.phone,
      this.email,
      this.logo,
      this.username,
      this.fullname,
      this.about,
      this.experience,
      this.first_name,
      this.last_name,
      this.country,
      this.views,
      this.applied,
      this.company_name,
      this.reg_number,
      this.company_address,
      this.premium,
      this.type,
      this.id});

  factory User.fromJson(Map<String, dynamic> data) => _$UserFromJson(data);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
