import 'dart:collection';

import 'package:diary/src/data_utils.dart';
import 'package:diary/src/models/db_helper.dart';
import 'package:diary/src/models/diary.dart';
import 'package:flutter/cupertino.dart';
import 'package:table_calendar/table_calendar.dart';

class DiaryProvider extends ChangeNotifier {
  static const _diaryTable = "diarys";

  final _eventsMap = LinkedHashMap<DateTime, List<Diary>>(
    equals: isSameDay,
    hashCode: DataUtils.getHashCode,
  );
  List<Diary> _selectedEvents = [];

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  LinkedHashMap<DateTime, List<Diary>> get event => _eventsMap;
  List<Diary> get selectedEvents => _selectedEvents;
  DateTime? get selectedDay => _selectedDay;
  DateTime get focusedDay => _focusedDay;

  TextEditingController titleController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  DiaryProvider() {
    _selectedDay = _focusedDay;
    _loadDiary(DateTime.now());
  }

  void _loadDiary(DateTime inital) async {
    var data = await DBHelper().getAll(_diaryTable);
    var loadData = data.map((e) => Diary.fromJson(e)).toList();

    _eventsMap.clear();

    for (var diary in loadData) {
      List<Diary> list =
          _eventsMap[DataUtils.getDateUtc(diary.standDate)] ?? [];
      list.add(diary);
      _eventsMap[DataUtils.getDateUtc(diary.standDate)] = list;
    }

    notifyListeners();
    getEventsForDay(inital);
  }

  void addDiary() async {
    var addDiary = Diary(
        standDate: DataUtils.getHashCode(_focusedDay),
        title: titleController.text,
        body: notesController.text);
    await DBHelper().insert(_diaryTable, addDiary.toMap());
    _loadDiary(focusedDay);
  }

  void updateDiary() async {
    var editDiary = Diary(
        id: selectedEvents.first.id,
        standDate: DataUtils.getHashCode(_focusedDay),
        title: titleController.text,
        body: notesController.text);

    await DBHelper().update(_diaryTable, editDiary);
    _loadDiary(focusedDay);
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    }
    getEventsForDay(_focusedDay);
  }

  List<Diary> getEventsForDay(DateTime day) {
    _selectedEvents = _eventsMap[day] ?? [];
    notifyListeners();
    return _selectedEvents;
  }

  List<Diary> initalEventLoader(DateTime day) {
    return _eventsMap[day] ?? [];
  }

  void sheetSetting(bool isNew) {
    if (isNew) {
      titleController.text = "";
      notesController.text = "";
    } else {
      titleController.text = selectedEvents.first.title;
      notesController.text = selectedEvents.first.body;
    }
  }
}
