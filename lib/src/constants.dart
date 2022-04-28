import 'package:flutter/material.dart';

final kFirstDay = DateTime(2022, 1, 1);
final kLastDay = DateTime(2025, 12, 31);

List<Color> colorPalete = [
  const Color(0xff8B89EC),
  const Color(0xffEC89AD),
  const Color(0xffAFEC89),
  const Color(0xffEC89E2),
  const Color(0xff89ECE0),
  const Color(0xffDEEC89),
  const Color(0xffEEC2C3),
];

const EdgeInsets kPageBannerPadding = EdgeInsets.all(20);
const double kPageBannerTitle = 30.0;

const String kEmptySchedule = "No Schedule for today";
const String kEmptyTodo = "No Todo list for today";
const String kEmptyDiary = "No Diary for today";
