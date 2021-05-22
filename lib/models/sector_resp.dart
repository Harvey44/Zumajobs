import 'package:json_annotation/json_annotation.dart';
import 'package:zumajobs/models/sector.dart';
part 'sector_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class SectorResp {
  bool status;
  String message, type;
  List<Sector> sector;

  SectorResp({
    this.status,
    this.message,
    this.type,
    this.sector,
  });

  factory SectorResp.fromJson(Map<String, dynamic> data) =>
      _$SectorRespFromJson(data);

  Map<String, dynamic> toJson() => _$SectorRespToJson(this);
}
