import 'package:json_annotation/json_annotation.dart';

part 'widget.g.dart';

enum WidgetType {
  @JsonValue(0)
  music,
  @JsonValue(1)
  poll,
  @JsonValue(2)
  stopWatch,
  @JsonValue(3)
  rate,
  @JsonValue(4)
  location,
  @JsonValue(5)
  code,
  @JsonValue(6)
  question,
  @JsonValue(7)
  answer,
}

@JsonSerializable()
class Widget {
  String title;
  String body;
  String data;
  WidgetType type;

  Widget({
    required this.title,
    required this.body,
    required this.data,
    required this.type,
  });

  factory Widget.fromJson(Map<String, dynamic> json) => _$WidgetFromJson(json);

  Map<String, dynamic> toJson() => _$WidgetToJson(this);
}
