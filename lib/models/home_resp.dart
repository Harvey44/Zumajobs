import 'package:json_annotation/json_annotation.dart';
import 'package:zumajobs/models/vacancy.dart';
import 'package:zumajobs/models/user.dart';
part 'home_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class HomeResp {
  bool status;
  String message, fullname, type, link, amount;
  List<Vacancy> vacancy;
  List<User> applicants;
  User applicant, employer;

  HomeResp(
      {this.status,
      this.message,
      this.fullname,
      this.type,
      this.link,
      this.amount,
      this.vacancy,
      this.applicants,
      this.applicant,
      this.employer});

  factory HomeResp.fromJson(Map<String, dynamic> data) =>
      _$HomeRespFromJson(data);

  Map<String, dynamic> toJson() => _$HomeRespToJson(this);
}
