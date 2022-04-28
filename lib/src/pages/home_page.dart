import 'package:diary/src/componets/diary_card.dart';
import 'package:diary/src/componets/page_banner.dart';
import 'package:diary/src/componets/schedule_card.dart';
import 'package:diary/src/componets/todo_card.dart';
import 'package:diary/src/constants.dart';
import 'package:diary/src/providers/bottom_navigation_provider.dart';
import 'package:diary/src/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<HomeProvider>(context, listen: false).loadSchedule();
    Provider.of<HomeProvider>(context, listen: false).loadTodo();
    Provider.of<HomeProvider>(context, listen: false).loadDiary();
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Container(
          padding: EdgeInsets.only(top: statusBarHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              PageBanner(navigations: Navigations.Home),
              HomeTabViewWidget()
            ],
          )),
    );
  }
}

class HomeTabViewWidget extends StatelessWidget {
  const HomeTabViewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (_, provider, __) {
      return DefaultTabController(
          initialIndex: provider.currentIndex,
          length: 3,
          child: Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                TabBar(
                  labelColor: Colors.black,
                  indicatorColor: const Color(0xffEEC2C3),
                  tabs: const [
                    Tab(
                      text: "Schedule",
                    ),
                    Tab(
                      text: "Todo",
                    ),
                    Tab(
                      text: "Diary",
                    ),
                  ],
                  onTap: (index) {
                    provider.changeIndex(index);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Provider.of<BottomNavigationProvider>(context,
                                  listen: false)
                              .updateCurrentPage(provider.currentIndex + 1);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: colorPalete.last,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12))),
                          child: Text(
                            "See All",
                            style: TextStyle(color: Colors.grey[800]),
                          ),
                        )),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        provider.todaySchedule.isEmpty
                            ? emptyView(kEmptySchedule)
                            : ScheduleCardListView(
                                isHome: true,
                                selectDate: provider.selectDateTime,
                                schedules: provider.todaySchedule),
                        provider.todayTodo.isEmpty
                            ? emptyView(kEmptyTodo)
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: provider.todayTodo.length,
                                itemBuilder: (context, index) => TodoCard(
                                    isHome: true,
                                    todo: provider.todayTodo[index])),
                        provider.todayDiary == null
                            ? emptyView(kEmptyDiary)
                            : ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: 1,
                                itemBuilder: (context, index) => DiaryCard(
                                      diary: provider.todayDiary!,
                                      isHome: true,
                                    ))
                      ]),
                )
              ],
            ),
          ));
    });
  }

  Widget emptyView(String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          LineIcons.box,
          size: 100,
          color: Colors.grey[800],
        ),
        Text(
          title,
          style:
              TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
