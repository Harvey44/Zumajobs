import 'package:json_annotation/json_annotation.dart';
part 'register_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class RegisterResp {
  String key;

  RegisterResp({this.key});

  factory RegisterResp.fromJson(Map<String, dynamic> data) =>
      _$RegisterRespFromJson(data);

  Map<String, dynamic> toJson() => _$RegisterRespToJson(this);
}
