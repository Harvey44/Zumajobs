import 'package:json_annotation/json_annotation.dart';
part 'sector.g.dart';

@JsonSerializable(explicitToJson: true)
class Sector {
  String name, description, image;
  int id;

  Sector({this.name, this.description, this.image, this.id});

  factory Sector.fromJson(Map<String, dynamic> data) => _$SectorFromJson(data);

  Map<String, dynamic> toJson() => _$SectorToJson(this);
}
