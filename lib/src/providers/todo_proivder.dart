import 'dart:collection';

import 'package:diary/src/data_utils.dart';
import 'package:diary/src/models/db_helper.dart';
import 'package:diary/src/models/todo.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class TodoProvider extends ChangeNotifier {
  static const _todoTable = "todos";

  final _todosMap = LinkedHashMap<DateTime, List<Todo>>(
    equals: isSameDay,
    hashCode: DataUtils.getHashCode,
  );

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<Todo> _selectedTodo = [];

  LinkedHashMap<DateTime, List<Todo>> get event => _todosMap;
  List<Todo> get selectedTodo => _selectedTodo;

  List<Todo> get completeTodo =>
      _selectedTodo.where((element) => element.isComplete).toList();
  DateTime? get selectedDay => _selectedDay;
  DateTime get focusedDay => _focusedDay;

  bool isShowAll = true;

  // edit or add data
  int newColorIdx = 0;
  TextEditingController titleController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TimeOfDay newTime = TimeOfDay.now();

  TodoProvider() {
    _selectedDay = _focusedDay;
    loadTodo(DateTime.now());
  }

  void loadTodo(DateTime inital) async {
    var data = await DBHelper().getAll(_todoTable);
    var loadData = data.map((e) => Todo.fromJson(e)).toList();

    _todosMap.clear();

    for (var todo in loadData) {
      List<Todo> list = _todosMap[DataUtils.getDateUtc(todo.createDate)] ?? [];
      list.add(todo);
      _todosMap[DataUtils.getDateUtc(todo.createDate)] = list;
    }
    notifyListeners();
    getEventsForDay(inital);
  }

  void addTodo() async {
    Todo todo = Todo(
        title: titleController.text,
        notes: notesController.text,
        createDate: DataUtils.getHashCode(_focusedDay),
        createTime: DataUtils.foramtTimetoString(newTime),
        color: newColorIdx);
    await DBHelper().insert(_todoTable, todo.toMap());

    addTodoReset();
    loadTodo(DataUtils.getDateUtc(todo.createDate));
  }

  void updateTodo(Todo todo, bool isEdit) async {
    if (isEdit) {
      var editTodo = Todo(
          id: todo.id,
          title: titleController.text,
          notes: notesController.text,
          createDate: DataUtils.getHashCode(_focusedDay),
          createTime: DataUtils.foramtTimetoString(newTime),
          color: newColorIdx);
      await DBHelper().update(_todoTable, editTodo);
    } else {
      await DBHelper().update(_todoTable, todo);
    }
    loadTodo(DataUtils.getDateUtc(todo.createDate));
  }

  void addTodoReset() {
    titleController.clear();
    notesController.clear();
    newTime = TimeOfDay.now();
    newColorIdx = 0;
  }

  void editSetting(Todo todo) {
    titleController.text = todo.title;
    notesController.text = todo.notes;
    newColorIdx = todo.color;
    newTime = DataUtils.formatTimeOdDay(todo.createTime);
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    }
    getEventsForDay(_focusedDay);
  }

  List<Todo> getEventsForDay(DateTime day) {
    _selectedTodo = _todosMap[day] ?? [];
    _selectedTodo.sort((a, b) {
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
    return _selectedTodo;
  }

  List<Todo> initalEventLoader(DateTime day) {
    return _todosMap[day] ?? [];
  }

  void selectTime(TimeOfDay timeOfDay) {
    newTime = timeOfDay;
    notifyListeners();
  }

  void changeColor(int index) {
    newColorIdx = index;
    notifyListeners();
  }

  void changeShowMode(bool mode) {
    isShowAll = mode;
    notifyListeners();
  }

  void deleteTodo(Todo todo) async {
    await DBHelper().delete(_todoTable, todo);
    loadTodo(DataUtils.getDateUtc(todo.createDate));
  }
}
