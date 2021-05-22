import 'package:json_annotation/json_annotation.dart';
import 'package:zumajobs/models/sector.dart';
import 'package:zumajobs/models/user.dart';
import 'package:zumajobs/models/vacancy.dart';
part 'vacancy_resp.g.dart';

@JsonSerializable(explicitToJson: true)
class VacancyResp {
  bool status;
  List<Vacancy> vacancy;
  String message;

  VacancyResp({
    this.status,
    this.message,
    this.vacancy,
  });

  factory VacancyResp.fromJson(Map<String, dynamic> data) =>
      _$VacancyRespFromJson(data);

  Map<String, dynamic> toJson() => _$VacancyRespToJson(this);
}
