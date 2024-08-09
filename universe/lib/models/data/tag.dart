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

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createDate: DateTime.parse(json['createDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createDate': createDate.toIso8601String(),
    };
  }
}
