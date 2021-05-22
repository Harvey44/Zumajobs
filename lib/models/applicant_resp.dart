import 'package:json_annotation/json_annotation.dart';
import 'package:zumajobs/models/user.dart';
part 'applicant_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class ApplicantResp {
  bool status;
  String message, type, link;
  List<User> applicant;

  ApplicantResp({
    this.status,
    this.message,
    this.type,
    this.link,
    this.applicant,
  });

  factory ApplicantResp.fromJson(Map<String, dynamic> data) =>
      _$ApplicantRespFromJson(data);

  Map<String, dynamic> toJson() => _$ApplicantRespToJson(this);
}
