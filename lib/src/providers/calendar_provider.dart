import 'dart:collection';
import 'package:diary/src/data_utils.dart';
import 'package:diary/src/models/db_helper.dart';
import 'package:diary/src/models/schedule.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarlProvider extends ChangeNotifier {
  static const _scheduleTable = "schedules";

  // variable

  final _eventsMap = LinkedHashMap<DateTime, List<Schedule>>(
    equals: isSameDay,
    hashCode: DataUtils.getHashCode,
  );

  List<Schedule> _selectedEvents = [];

  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  int newColorIdx = 0;

  //get method
  LinkedHashMap<DateTime, List<Schedule>> get event => _eventsMap;
  List<Schedule> get selectedEvents => _selectedEvents;
  DateTime? get selectedDay => _selectedDay;
  DateTime get focusedDay => _focusedDay;
  DateTime? get ragneStart => _rangeStart;
  DateTime? get ragneEnd => _rangeEnd;
  RangeSelectionMode get rangeSelectionMode => _rangeSelectionMode;

  TextEditingController titleController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  int colorIdx = 0;

  CalendarlProvider() {
    _selectedDay = _focusedDay;
    _loadSchedules(DateTime.now());
  }

  // db load
  void _loadSchedules(DateTime inital) async {
    var data = await DBHelper().getAll(_scheduleTable);
    var loadData = data.map((e) => Schedule.fromJson(e)).toList();

    _eventsMap.clear();

    for (var event in loadData) {
      List<Schedule> list =
          _eventsMap[DataUtils.getDateUtc(event.startDate)] ?? [];
      list.add(event);
      _eventsMap[DataUtils.getDateUtc(event.startDate)] = list;
    }

    notifyListeners();
    getEventsForDay(inital);
  }

  void addScheduleSetting() {
    titleController.clear();
    notesController.clear();
    startTime = TimeOfDay.now();
    endTime = TimeOfDay(hour: startTime.hour + 2, minute: 0);
    newColorIdx = 0;
  }

  void editSetting(Schedule schedule) {
    titleController.text = schedule.title;
    notesController.text = schedule.body;
    newColorIdx = schedule.color;
    startTime = DataUtils.formatTimeOdDay(schedule.startTime);
    endTime = DataUtils.formatTimeOdDay(schedule.endTime);
  }

  // db insert
  void addEvent(BuildContext context) async {
    Schedule schedule = Schedule(
        title: titleController.text,
        startDate: DataUtils.getHashCode(_focusedDay),
        body: notesController.text,
        startTime: startTime.format(context),
        endTime: endTime.format(context),
        color: newColorIdx);
    await DBHelper().insert(_scheduleTable, schedule.toMap());
    addScheduleSetting();
    _loadSchedules(_focusedDay);
  }

  // db delete
  void deleteSchedule(Schedule schedule) async {
    await DBHelper().delete(_scheduleTable, schedule).then(
        (value) => _loadSchedules(DataUtils.getDateUtc(schedule.startDate)));
  }

  void updateSchedule(Schedule schedule, context) async {
    Schedule updateSchedule = Schedule(
        id: schedule.id,
        title: titleController.text,
        startDate: DataUtils.getHashCode(_focusedDay),
        body: notesController.text,
        startTime: startTime.format(context),
        endTime: endTime.format(context),
        color: newColorIdx);
    await DBHelper().update(_scheduleTable, updateSchedule);
    onDaySelected(_focusedDay, _focusedDay);

    _loadSchedules(_focusedDay);
  }

  void changeColor(int index) {
    newColorIdx = index;
    notifyListeners();
  }

  void changeDate(DateTime date) {
    onDaySelected(date, date);
  }

  void changeTime(TimeOfDay time, bool isStart) {
    if (isStart) {
      startTime = time;
    } else {
      endTime = time;
    }
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _rangeSelectionMode = RangeSelectionMode.toggledOff;
      _rangeStart = null;
      _rangeEnd = null;
    }
    getEventsForDay(_focusedDay);
  }

  void onRangeSelected(DateTime? start, DateTime? end, DateTime focusdDay) {
    _selectedDay = null;
    _focusedDay = focusdDay;
    _rangeStart = start;
    _rangeEnd = end;
    _rangeSelectionMode = RangeSelectionMode.toggledOn;

    if (start != null && end != null) {
      getEventsForRange(start, end);
    } else if (start != null) {
      getEventsForDay(start);
    } else if (end != null) {
      getEventsForDay(end);
    }
  }

  List<Schedule> getEventsForDay(DateTime day) {
    _selectedEvents = _eventsMap[day] ?? [];
    _selectedEvents.sort((a, b) {
      var compare = DataUtils.formatTimeOdDay(a.startTime)
          .hour
          .compareTo(DataUtils.formatTimeOdDay(b.startTime).hour);
      if (compare == 0) {
        return DataUtils.formatTimeOdDay(a.startTime)
            .minute
            .compareTo(DataUtils.formatTimeOdDay(b.startTime).minute);
      } else {
        return compare;
      }
    });
    notifyListeners();
    return _selectedEvents;
  }

  List<Schedule> initalEventLoader(DateTime day) {
    return _eventsMap[day] ?? [];
  }

  List<Schedule> getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);
    _selectedEvents = {for (var d in days) ...getEventsForDay(d)}.toList();
    notifyListeners();
    return _selectedEvents;
  }

  List<DateTime> daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
      (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }

  List<Schedule> getEvents(DateTime day) {
    return _eventsMap[day] ?? [];
  }
}
