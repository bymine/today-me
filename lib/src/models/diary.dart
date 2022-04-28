class Diary {
  int? id;
  int standDate;
  String title;
  String body;

  Diary({
    required this.standDate,
    required this.title,
    required this.body,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'diary_id': id,
      'diary_title': title,
      'diary_body': body,
      'diary_start_date': standDate,
    };
  }

  factory Diary.fromJson(Map<String, dynamic> json) {
    return Diary(
        id: json['diary_id'],
        standDate: json['diary_start_date'],
        title: json['diary_title'],
        body: json['diary_body']);
  }
}
