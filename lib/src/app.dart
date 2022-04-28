import 'package:diary/src/pages/calendar_page.dart';
import 'package:diary/src/pages/diary_page.dart';
import 'package:diary/src/pages/home_page.dart';
import 'package:diary/src/pages/todo_page.dart';
import 'package:diary/src/providers/bottom_navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _navigationBody(context),
      bottomNavigationBar: _bottomNavigationBarWidget(context),
    );
  }

  Widget _bottomNavigationBarWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(.1),
          )
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12),
          child: GNav(
              selectedIndex:
                  Provider.of<BottomNavigationProvider>(context).currentPage,
              onTabChange: (index) =>
                  Provider.of<BottomNavigationProvider>(context, listen: false)
                      .updateCurrentPage(index),
              rippleColor:
                  Colors.grey[800]!, // tab button ripple color when pressed
              hoverColor: Colors.grey[700]!, // tab button hover color
              haptic: true, // haptic feedback
              tabBorderRadius: 15,
              duration:
                  const Duration(milliseconds: 10), // tab animation duration
              gap: 8, // the tab button gap between icon and text
              color: Colors.grey[800], // unselected icon color
              activeColor: Colors.purple, // selected icon and text color
              iconSize: 24, // tab button icon size
              tabBackgroundColor: Colors.purple
                  .withOpacity(0.1), // selected tab background color
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 5), // navigation bar padding
              tabs: const [
                GButton(
                  icon: LineIcons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: LineIcons.calendar,
                  text: 'Schedule',
                ),
                GButton(
                  icon: LineIcons.list,
                  text: 'Todo',
                ),
                GButton(
                  icon: LineIcons.book,
                  text: 'Diary',
                )
              ]),
        ),
      ),
    );
  }

  Widget _navigationBody(BuildContext context) {
    switch (Navigations
        .values[Provider.of<BottomNavigationProvider>(context).currentPage]) {
      case Navigations.Home:
        return const HomePage();

      case Navigations.Schedule:
        return const CalednarPage();

      case Navigations.Todo:
        return const TodoPage();

      case Navigations.Diary:
        return const DiaryPage();
    }
  }
}
