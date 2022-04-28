import 'package:diary/src/componets/page_banner.dart';
import 'package:diary/src/componets/schedule_card.dart';
import 'package:diary/src/constants.dart';
import 'package:diary/src/models/schedule.dart';
import 'package:diary/src/providers/bottom_navigation_provider.dart';
import 'package:diary/src/providers/calendar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalednarPage extends StatelessWidget {
  const CalednarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageBanner(navigations: Navigations.Schedule),
            const ScheduleCalendar(),
            Consumer<CalendarlProvider>(builder: (_, provider, __) {
              if (provider.ragneStart != null && provider.ragneEnd != null) {
                return rangeModeCardView(provider);
              }
              return ScheduleCardListView(
                  isHome: false,
                  selectDate: provider.focusedDay,
                  schedules: provider.selectedEvents);
            })
          ],
        ),
      ),
    );
  }

  Column rangeModeCardView(CalendarlProvider provider) {
    return Column(
      children: List.generate(
          provider.daysInRange(provider.ragneStart!, provider.ragneEnd!).length,
          (index) {
        DateTime currentDate = provider.daysInRange(
            provider.ragneStart!, provider.ragneEnd!)[index];
        List<Schedule> currentList = provider.getEvents(currentDate);
        if (currentList.isNotEmpty) {
          return ScheduleCardListView(
              isHome: false, selectDate: currentDate, schedules: currentList);
        }
        return Container();
      }),
    );
  }
}

class ScheduleCalendar extends StatelessWidget {
  const ScheduleCalendar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Consumer<CalendarlProvider>(builder: (_, provider, __) {
        return TableCalendar<Schedule>(
            rowHeight: 50,
            headerVisible: false,
            daysOfWeekHeight: 20,
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: provider.focusedDay,
            selectedDayPredicate: (day) => isSameDay(provider.selectedDay, day),
            rangeStartDay: provider.ragneStart,
            rangeEndDay: provider.ragneEnd,
            rangeSelectionMode: provider.rangeSelectionMode,
            eventLoader: provider.initalEventLoader,
            startingDayOfWeek: StartingDayOfWeek.monday,
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
              outsideDaysVisible: true,
            ),
            onDaySelected: provider.onDaySelected,
            onRangeSelected: provider.onRangeSelected);
      }),
    );
  }
}
