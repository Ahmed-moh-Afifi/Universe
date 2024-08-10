import 'package:json_annotation/json_annotation.dart';

part 'tag.g.dart';

@JsonSerializable()
class Tag {
  int id;
  String name;
  String description;
  DateTime createDate;

  Tag({
    required this.id,
    required this.name,
    required this.description,
    required this.createDate,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  Map<String, dynamic> toJson() => _$TagToJson(this);
}
