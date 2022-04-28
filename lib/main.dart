import 'package:diary/src/providers/calendar_provider.dart';
import 'package:diary/src/models/db_helper.dart';
import 'package:diary/src/app.dart';
import 'package:diary/src/providers/bottom_navigation_provider.dart';
import 'package:diary/src/providers/diary_provider.dart';
import 'package:diary/src/providers/home_provider.dart';
import 'package:diary/src/providers/todo_proivder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => BottomNavigationProvider(),
          ),
          ChangeNotifierProvider(create: (_) => DBHelper()),
          ChangeNotifierProvider(
            create: (_) => CalendarlProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => TodoProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => DiaryProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => HomeProvider(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: '오늘의 나',
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
                titleTextStyle: TextStyle(color: Colors.black),
                iconTheme: IconThemeData(color: Colors.black),
                backgroundColor: Colors.transparent,
                elevation: 0),
            primarySwatch: Colors.blue,
          ),
          home: const App(),
        ));
  }
}
