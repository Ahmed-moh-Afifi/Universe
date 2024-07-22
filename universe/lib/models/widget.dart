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
}
