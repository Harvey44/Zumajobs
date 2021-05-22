import 'package:json_annotation/json_annotation.dart';
part 'vacancy.g.dart';

@JsonSerializable(explicitToJson: true)
class Vacancy {
  String position,
      description,
      logo,
      experience,
      salary,
      location,
      company,
      duration,
      email;
  bool remote;

  Vacancy(
      {this.position,
      this.description,
      this.logo,
      this.salary,
      this.experience,
      this.location,
      this.company,
      this.duration,
      this.email,
      this.remote});

  factory Vacancy.fromJson(Map<String, dynamic> data) =>
      _$VacancyFromJson(data);

  Map<String, dynamic> toJson() => _$VacancyToJson(this);
}
