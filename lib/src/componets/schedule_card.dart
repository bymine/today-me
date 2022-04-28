import 'package:diary/src/componets/bottom_sheet_function.dart';
import 'package:diary/src/constants.dart';
import 'package:diary/src/data_utils.dart';
import 'package:diary/src/models/schedule.dart';
import 'package:diary/src/providers/calendar_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class ScheduleCardListView extends StatelessWidget {
  final bool isHome;
  final DateTime selectDate;
  final List<Schedule> schedules;
  const ScheduleCardListView(
      {Key? key,
      required this.selectDate,
      required this.schedules,
      required this.isHome})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (schedules.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isHome) DateLine(selectDate: selectDate),
          TimeLine(
            schedules: schedules,
            isStart: true,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              return ScheduleCard(
                isHome: isHome,
                schedule: schedules[index],
              );
            },
          ),
          TimeLine(
            schedules: schedules,
            isStart: false,
          ),
        ],
      );
    } else {
      return DateLine(selectDate: selectDate);
    }
  }
}

class TimeLine extends StatelessWidget {
  const TimeLine({
    Key? key,
    required this.isStart,
    required this.schedules,
  }) : super(key: key);

  final List<Schedule> schedules;
  final bool isStart;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 20, right: 20, top: 10, bottom: !isStart ? 20 : 0),
      child: Row(
        children: [
          Text(isStart ? schedules.first.startTime : schedules.last.endTime),
          const SizedBox(
            width: 20,
          ),
          const Expanded(
              child: Divider(
            thickness: 1,
          )),
        ],
      ),
    );
  }
}

class DateLine extends StatelessWidget {
  const DateLine({
    Key? key,
    required this.selectDate,
  }) : super(key: key);

  final DateTime selectDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 12),
      child: RichText(
        text: TextSpan(
          text: DateFormat('d, ').format(selectDate),
          style: const TextStyle(color: Colors.black, fontSize: 20),
          children: [
            TextSpan(
                text: DateFormat('EEE').format(selectDate),
                style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                    fontSize: 16))
          ],
        ),
      ),
    );
  }
}

class ScheduleCard extends StatelessWidget {
  final bool isHome;
  final Schedule schedule;
  const ScheduleCard({
    Key? key,
    required this.isHome,
    required this.schedule,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 60, bottom: 10, right: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 2,
                spreadRadius: 2)
          ],
          color: colorPalete[schedule.color]),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DataUtils.formatStartToEndTimeString(schedule),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[800],
                ),
              ),
              Visibility(
                visible: !isHome,
                child: GestureDetector(
                  onTap: () {
                    scheduleBottomSheet(context, schedule);
                    // Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (context) => AddPage(
                    //     date: null,
                    //     schedule: schedule,
                    //   ),
                    // ));
                  },
                  child: Text(
                    "Edit",
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                ),
              )
            ],
          ),
          Text(
            schedule.title,
            style: TextStyle(fontSize: 16, color: Colors.grey[800]),
          ),
          Visibility(
            visible: !isHome,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  schedule.body,
                  style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                ),
                GestureDetector(
                  onTap: () {
                    Provider.of<CalendarlProvider>(context, listen: false)
                        .deleteSchedule(schedule);
                  },
                  child:
                      Icon(LineIcons.trash, size: 20, color: Colors.grey[800]),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
