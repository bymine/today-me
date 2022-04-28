import 'package:diary/src/models/schedule.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DataUtils {
  static DateTime schduleDateForamtDateTime(String date) {
    int year = int.parse(date.split('/')[0]);
    int month = int.parse(date.split('/')[1]);
    int day = int.parse(date.split('/')[2]);

    return DateTime(year, month, day);
  }

  static int schduleDateForamtHashCode(String date) {
    int year = int.parse(date.split('/')[0]);
    int month = int.parse(date.split('/')[1]);
    int day = int.parse(date.split('/')[2]);

    return getHashCode(DateTime(year, month, day));
  }

  static String toDate(DateTime date) {
    return DateFormat("yyyy/MM/dd").format(date);
  }

  static String toDateAppBar(DateTime date) {
    return DateFormat('yyyy년 M월 d일').format(date);
  }

  static String toTime(DateTime date) {
    return DateFormat("hh:mm a").format(date);
  }

  static String formatTodoTime(DateTime date) {
    return date.toString().split(' ').first;
  }

  static String formatScheduleBanner(DateTime date) {
    return DateFormat("EEEE d", 'ko').format(date);
  }

  static String formatRangeSchedule(DateTime date) {
    return DateFormat('M/d').format(date);
  }

  // String --> TimeOfDay ex) 06:00 AM-> TimeOfDay(06:00)
  static TimeOfDay formatTimeOdDay(String time) {
    return TimeOfDay.fromDateTime(DateFormat.jm().parse(time));
  }

  // TimeOfDay --> String ex) TimeOfDay(06:00) -> 06:00 AM
  static String foramtTimetoString(TimeOfDay time) {
    DateTime now = DateTime.now();
    var formatDate =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(formatDate);
  }

  static String formatStartToEndTimeString(Schedule schedule) {
    return schedule.startTime + " ~ " + schedule.endTime;
  }

  // static String formatScheduleCardDate(Schedule schedule) {
  //   if (schedule.startDate == schedule.endDate) {
  //     return formatScheduleBanner(getDateUtc(schedule.startDate));
  //   } else {
  //     return formatRangeSchedule(getDateUtc(schedule.startDate)) +
  //         " ~ " +
  //         formatRangeSchedule(getDateUtc(schedule.endDate));
  //   }
  // }

  // static String formatScheduleCardTime(Schedule schedule) {
  //   if (schedule.startDate == schedule.endDate) {
  //     return schedule.startTime + " ~ " + schedule.endTime;
  //   } else {
  //     return schedule.startTime + " ~ " + schedule.endTime;
  //   }
  // }

  static int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  static DateTime getDateUtc(int hashCode) {
    int day = hashCode ~/ 1000000;
    int month = (hashCode % 1000000) ~/ 10000;
    int year = (hashCode % 1000000) % 10000;

    return DateTime.utc(year, month, day);
  }
}
