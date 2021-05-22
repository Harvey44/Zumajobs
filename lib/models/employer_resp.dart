import 'package:json_annotation/json_annotation.dart';
import 'package:zumajobs/models/user.dart';
part 'employer_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class EmployerResp {
  bool status;
  String message, type;
  List<User> employers;

  EmployerResp({
    this.status,
    this.message,
    this.type,
    this.employers,
  });

  factory EmployerResp.fromJson(Map<String, dynamic> data) =>
      _$EmployerRespFromJson(data);

  Map<String, dynamic> toJson() => _$EmployerRespToJson(this);
}
