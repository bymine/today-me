import 'package:diary/src/data_utils.dart';
import 'package:diary/src/models/db_helper.dart';
import 'package:diary/src/models/diary.dart';
import 'package:diary/src/models/schedule.dart';
import 'package:diary/src/models/todo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  static const _scheduleTable = "schedules";
  static const _todoTable = "todos";
  static const _diaryTable = "diarys";

  DateTime selectDateTime = DateTime.now();
  List<Schedule> _schedule = [];
  List<Todo> _todo = [];
  List<Diary> _diary = [];

  List<Schedule> get todaySchedule => _schedule;
  List<Todo> get todayTodo => _todo;
  Diary? get todayDiary => _diary.isEmpty ? null : _diary.first;

  int _index = 0;
  int get currentIndex => _index;

  HomeProvider() {
    loadDiary();
    loadTodo();
    loadSchedule();
  }

  void loadDiary() async {
    var data = await DBHelper()
        .getByDate(_diaryTable, DataUtils.getHashCode(selectDateTime));
    _diary = data.map((e) => Diary.fromJson(e)).toList();
    notifyListeners();
  }

  void loadTodo() async {
    var data = await DBHelper()
        .getByDate(_todoTable, DataUtils.getHashCode(selectDateTime));
    _todo = data.map((e) => Todo.fromJson(e)).toList();
    _todo.sort((a, b) {
      var compare = DataUtils.formatTimeOdDay(a.createTime)
          .hour
          .compareTo(DataUtils.formatTimeOdDay(b.createTime).hour);
      if (compare == 0) {
        return DataUtils.formatTimeOdDay(a.createTime)
            .minute
            .compareTo(DataUtils.formatTimeOdDay(b.createTime).minute);
      } else {
        return compare;
      }
    });
    notifyListeners();
  }

  void loadSchedule() async {
    var data = await DBHelper()
        .getByDate(_scheduleTable, DataUtils.getHashCode(selectDateTime));
    _schedule = data.map((e) => Schedule.fromJson(e)).toList();
    notifyListeners();
  }

  void changeIndex(int index) {
    _index = index;
    notifyListeners();
  }
}
