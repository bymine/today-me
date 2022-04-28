import 'package:diary/src/componets/custom_input_field.dart';
import 'package:diary/src/constants.dart';
import 'package:diary/src/data_utils.dart';
import 'package:diary/src/models/schedule.dart';
import 'package:diary/src/models/todo.dart';
import 'package:diary/src/providers/calendar_provider.dart';
import 'package:diary/src/providers/diary_provider.dart';
import 'package:diary/src/providers/todo_proivder.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

todoBottomSheet(BuildContext context, Todo? todo) {
  if (todo == null) {
    Provider.of<TodoProvider>(context, listen: false).addTodoReset();
  } else {
    Provider.of<TodoProvider>(context, listen: false).editSetting(todo);
  }
  return showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomInputField(
                          controller: Provider.of<TodoProvider>(context)
                              .titleController,
                          title: todo == null ? "Add Todo" : "Edit Todo",
                          hintTitle: ""),
                      CustomInputField(
                          controller: Provider.of<TodoProvider>(context)
                              .notesController,
                          title: "Notes",
                          hintTitle: ""),
                      CustomInputField(
                          controller: null,
                          readOnly: true,
                          title: "Time",
                          suffixcIcon: IconButton(
                              onPressed: () async {
                                TimeOfDay? _pickerTime = await showTimePicker(
                                  context: context,
                                  initialTime: Provider.of<TodoProvider>(
                                          context,
                                          listen: false)
                                      .newTime,
                                );
                                if (_pickerTime != null) {
                                  Provider.of<TodoProvider>(context,
                                          listen: false)
                                      .selectTime(_pickerTime);
                                }
                              },
                              icon: const Icon(LineIcons.clock)),
                          hintTitle: Provider.of<TodoProvider>(
                            context,
                          ).newTime.format(context)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text('Colors'),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: List.generate(
                                colorPalete.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    Provider.of<TodoProvider>(context,
                                            listen: false)
                                        .changeColor(index);
                                  },
                                  child: Consumer<TodoProvider>(
                                    builder: (_, provider, __) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 16),
                                        child: CircleAvatar(
                                          radius: 14,
                                          backgroundColor:
                                              Provider.of<TodoProvider>(context)
                                                          .newColorIdx ==
                                                      index
                                                  ? Colors.grey
                                                  : Colors.transparent,
                                          child: CircleAvatar(
                                              radius: 10,
                                              backgroundColor:
                                                  colorPalete[index]),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (todo == null) {
                      Provider.of<TodoProvider>(context, listen: false)
                          .addTodo();
                    } else {
                      Provider.of<TodoProvider>(context, listen: false)
                          .updateTodo(todo, true);
                    }

                    Navigator.pop(context);
                  },
                  child: Container(
                    color: const Color(0xff8B89EC),
                    width: double.infinity,
                    height: 60,
                    child: Center(
                        child: Text(
                      todo == null ? "Add Todo" : "Edit Todo",
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    )),
                  ),
                )
              ],
            ),
          ),
        );
      });
}

scheduleBottomSheet(BuildContext context, Schedule? schedule) {
  DateTime date;
  if (schedule == null) {
    Provider.of<CalendarlProvider>(context, listen: false).addScheduleSetting();
  } else {
    date = Provider.of<CalendarlProvider>(context, listen: false)
                .rangeSelectionMode ==
            RangeSelectionMode.toggledOn
        ? Provider.of<CalendarlProvider>(context, listen: false).ragneStart!
        : Provider.of<CalendarlProvider>(context, listen: false).focusedDay;
    Provider.of<CalendarlProvider>(context, listen: false)
        .editSetting(schedule);
  }

  return showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  child: Column(
                    children: [
                      CustomInputField(
                          controller: Provider.of<CalendarlProvider>(context)
                              .titleController,
                          title: "Title",
                          hintTitle: ""),
                      CustomInputField(
                          controller: Provider.of<CalendarlProvider>(context)
                              .notesController,
                          title: "Notes",
                          hintTitle: ""),
                      CustomInputField(
                          controller: null,
                          title: "Date",
                          suffixcIcon: IconButton(
                              onPressed: () {
                                getDateTimeFromUser(
                                    isDate: true,
                                    isStart: null,
                                    context: context);
                              },
                              icon: const Icon(LineIcons.calendar)),
                          hintTitle: DataUtils.toDate(
                              Provider.of<CalendarlProvider>(context)
                                  .focusedDay)),
                      Row(
                        children: [
                          Expanded(
                            child: CustomInputField(
                                controller: null,
                                title: "Start Time",
                                readOnly: true,
                                suffixcIcon: IconButton(
                                    onPressed: () {
                                      getDateTimeFromUser(
                                          isDate: false,
                                          isStart: true,
                                          context: context);
                                    },
                                    icon: const Icon(LineIcons.clock)),
                                hintTitle:
                                    Provider.of<CalendarlProvider>(context)
                                        .startTime
                                        .format(context)),
                          ),
                          Expanded(
                            child: CustomInputField(
                              controller: null,
                              title: "End Time",
                              readOnly: true,
                              suffixcIcon: IconButton(
                                  onPressed: () {
                                    getDateTimeFromUser(
                                        isDate: false,
                                        isStart: false,
                                        context: context);
                                  },
                                  icon: const Icon(LineIcons.clock)),
                              hintTitle: Provider.of<CalendarlProvider>(context)
                                  .endTime
                                  .format(context),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text('Colors'),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: List.generate(
                                colorPalete.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    Provider.of<CalendarlProvider>(context,
                                            listen: false)
                                        .changeColor(index);
                                  },
                                  child: Consumer<TodoProvider>(
                                    builder: (_, provider, __) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 16),
                                        child: CircleAvatar(
                                          radius: 14,
                                          backgroundColor:
                                              Provider.of<CalendarlProvider>(
                                                              context)
                                                          .newColorIdx ==
                                                      index
                                                  ? Colors.grey
                                                  : Colors.transparent,
                                          child: CircleAvatar(
                                              radius: 10,
                                              backgroundColor:
                                                  colorPalete[index]),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (schedule == null) {
                      Provider.of<CalendarlProvider>(context, listen: false)
                          .addEvent(context);
                    } else {
                      Provider.of<CalendarlProvider>(context, listen: false)
                          .updateSchedule(schedule, context);
                    }

                    Navigator.pop(context);
                  },
                  child: Container(
                    color: const Color(0xff8B89EC),
                    width: double.infinity,
                    height: 60,
                    child: Center(
                        child: Text(
                      schedule == null ? "Add Schedule" : "Edit Schedule",
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    )),
                  ),
                )
              ],
            ),
          ),
        );
      });
}

getDateTimeFromUser(
    {required BuildContext context,
    required bool isDate,
    required bool? isStart}) async {
  DateTime? _pickerDate;
  TimeOfDay? _pickerTime;

  if (isDate) {
    _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2024));
    if (_pickerDate != null) {
      Provider.of<CalendarlProvider>(context, listen: false)
          .changeDate(_pickerDate);
    }
  } else {
    _pickerTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (_pickerTime != null) {
      Provider.of<CalendarlProvider>(context, listen: false)
          .changeTime(_pickerTime, isStart!);
    }
  }
}

Future<void> addEditDiaryFun(BuildContext context, bool isNew) {
  Provider.of<DiaryProvider>(context, listen: false).sheetSetting(isNew);

  return showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    child: Consumer<DiaryProvider>(builder: (_, provider, __) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomInputField(
                            controller: null,
                            title: "Date",
                            hintTitle: DataUtils.toDate(provider.focusedDay),
                            readOnly: true,
                          ),
                          CustomInputField(
                            controller: provider.titleController,
                            title: "Title",
                            hintTitle: "Input Title",
                            maxLines: 2,
                          ),
                          CustomInputField(
                            controller: provider.notesController,
                            title: "Notes",
                            hintTitle: "Input Notes",
                            maxLines: 10,
                          ),
                        ],
                      );
                    })),
                GestureDetector(
                  onTap: () {
                    isNew
                        ? Provider.of<DiaryProvider>(context, listen: false)
                            .addDiary()
                        : Provider.of<DiaryProvider>(context, listen: false)
                            .updateDiary();
                    Navigator.pop(context);
                  },
                  child: Container(
                    color: const Color(0xff8B89EC),
                    width: double.infinity,
                    height: 60,
                    child: Center(
                        child: Text(
                      isNew ? "Add Diary" : "Edit Diary",
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    )),
                  ),
                )
              ],
            ),
          ),
        );
      });
}
