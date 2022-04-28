class Schedule {
  int? id;
  String title;
  String body;
  int startDate;
  String startTime;
  String endTime;
  int color;

  Schedule(
      {required this.title,
      required this.startDate,
      required this.body,
      required this.startTime,
      required this.endTime,
      required this.color,
      this.id});

  Map<String, dynamic> toMap() {
    return {
      'schedule_id': id,
      'schedule_title': title,
      'schedule_body': body,
      'schedule_start_date': startDate,
      'schedule_start_time': startTime,
      'schedule_end_time': endTime,
      'schedule_color': color
    };
  }

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['schedule_id'],
      title: json['schedule_title'],
      body: json['schedule_body'],
      startDate: json['schedule_start_date'],
      startTime: json['schedule_start_time'],
      endTime: json['schedule_end_time'],
      color: json['schedule_color'],
    );
  }
}
