import 'package:json_annotation/json_annotation.dart';
part 'model_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class ModelResp {
  bool status;
  String message, name, email, type, privacy;
  int amount;

  ModelResp(
      {this.status,
      this.message,
      this.name,
      this.email,
      this.type,
      this.privacy,
      this.amount});

  factory ModelResp.fromJson(Map<String, dynamic> data) =>
      _$ModelRespFromJson(data);

  Map<String, dynamic> toJson() => _$ModelRespToJson(this);
}
