import 'package:diary/src/componets/diary_card.dart';
import 'package:diary/src/componets/page_banner.dart';
import 'package:diary/src/constants.dart';
import 'package:diary/src/providers/bottom_navigation_provider.dart';
import 'package:diary/src/providers/diary_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class DiaryPage extends StatelessWidget {
  const DiaryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageBanner(navigations: Navigations.Diary),
            const DiaryCalendar(),
            Consumer<DiaryProvider>(builder: (_, provider, __) {
              if (provider.selectedEvents.isNotEmpty) {
                return DiaryCard(
                  isHome: false,
                  diary: provider.selectedEvents.first,
                );
              }
              return Container();
            })
          ],
        ),
      ),
    );
  }
}

class DiaryCalendar extends StatelessWidget {
  const DiaryCalendar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Consumer<DiaryProvider>(
        builder: (_, provider, __) {
          return TableCalendar(
            rowHeight: 50,
            daysOfWeekHeight: 20,
            headerVisible: false,
            calendarFormat: CalendarFormat.week,
            focusedDay: provider.focusedDay,
            firstDay: kFirstDay,
            lastDay: kLastDay,
            selectedDayPredicate: (day) => isSameDay(provider.selectedDay, day),
            eventLoader: provider.initalEventLoader,
            daysOfWeekStyle: const DaysOfWeekStyle(
                weekendStyle: TextStyle(color: Colors.red)),
            calendarStyle: const CalendarStyle(
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
          );
        },
      ),
    );
  }
}
