enum WidgetType {
  music,
  poll,
  stopWatch,
  rate,
  location,
  code,
  question,
  answer,
}

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

  factory Widget.fromJson(Map<String, dynamic> json) {
    return Widget(
      title: json['title'],
      body: json['body'],
      data: json['data'],
      type: WidgetType.values[json['type']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'data': data,
      'type': WidgetType.values.indexOf(type),
    };
  }
}
