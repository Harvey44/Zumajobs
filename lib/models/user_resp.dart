import 'package:json_annotation/json_annotation.dart';
import 'package:zumajobs/models/user.dart';
part 'user_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class UserResp {
  bool status;
  String message, username, type;
  User user;
  User employer;
  User applicant;

  UserResp(
      {this.status,
      this.message,
      this.username,
      this.type,
      this.user,
      this.employer,
      this.applicant});

  factory UserResp.fromJson(Map<String, dynamic> data) =>
      _$UserRespFromJson(data);

  Map<String, dynamic> toJson() => _$UserRespToJson(this);
}
