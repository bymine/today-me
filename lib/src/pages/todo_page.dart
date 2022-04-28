import 'package:diary/src/componets/page_banner.dart';
import 'package:diary/src/componets/todo_card.dart';
import 'package:diary/src/constants.dart';
import 'package:diary/src/providers/bottom_navigation_provider.dart';
import 'package:diary/src/providers/todo_proivder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageBanner(navigations: Navigations.Todo),
            const TodoCalendar(),
            _todoViewWayBox(),
            Consumer<TodoProvider>(builder: (_, provider, __) {
              if (provider.isShowAll) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.selectedTodo.length,
                    itemBuilder: (context, index) {
                      return TodoCard(
                          isHome: false, todo: provider.selectedTodo[index]);
                    });
              } else {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.completeTodo.length,
                    itemBuilder: (context, index) {
                      return TodoCard(
                          isHome: false, todo: provider.completeTodo[index]);
                    });
              }
            }),
            const SizedBox(
              height: 16,
            )
          ],
        ),
      ),
    );
  }

  Widget _todoViewWayBox() {
    return Consumer<TodoProvider>(builder: (_, provider, __) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              provider.changeShowMode(true);
            },
            child: Text(
              "All",
              style: provider.isShowAll
                  ? const TextStyle(decoration: TextDecoration.underline)
                  : const TextStyle(
                      color: Colors.grey, decoration: TextDecoration.none),
            ),
          ),
          TextButton(
            onPressed: () {
              provider.changeShowMode(false);
            },
            child: Text(
              "Complete",
              style: provider.isShowAll
                  ? const TextStyle(
                      color: Colors.grey, decoration: TextDecoration.none)
                  : const TextStyle(decoration: TextDecoration.underline),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      );
    });
  }
}

class TodoCalendar extends StatelessWidget {
  const TodoCalendar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(builder: (_, provider, __) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TableCalendar(
          rowHeight: 50,
          daysOfWeekHeight: 20,
          headerVisible: false,
          calendarFormat: CalendarFormat.week,
          focusedDay: provider.focusedDay,
          firstDay: kFirstDay,
          lastDay: kLastDay,
          selectedDayPredicate: (day) => isSameDay(provider.selectedDay, day),
          eventLoader: provider.initalEventLoader,
          daysOfWeekStyle:
              const DaysOfWeekStyle(weekendStyle: TextStyle(color: Colors.red)),
          calendarStyle: const CalendarStyle(
            markersMaxCount: 1,
            selectedDecoration: BoxDecoration(
              color: Color(0xffEEC2C3),
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Color(0xff8B89EC),
              shape: BoxShape.circle,
            ),
          ),
          startingDayOfWeek: StartingDayOfWeek.monday,
          onDaySelected: provider.onDaySelected,
        ),
      );
    });
  }
}
