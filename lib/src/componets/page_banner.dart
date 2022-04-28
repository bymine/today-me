import 'package:diary/src/componets/bottom_sheet_function.dart';
import 'package:diary/src/componets/custom_input_field.dart';
import 'package:diary/src/constants.dart';
import 'package:diary/src/data_utils.dart';
import 'package:diary/src/providers/bottom_navigation_provider.dart';
import 'package:diary/src/providers/calendar_provider.dart';
import 'package:diary/src/providers/diary_provider.dart';
import 'package:diary/src/providers/home_provider.dart';
import 'package:diary/src/providers/todo_proivder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PageBanner extends StatelessWidget {
  final Navigations navigations;
  const PageBanner({Key? key, required this.navigations}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: kPageBannerPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    navigations.name,
                    style: const TextStyle(fontSize: kPageBannerTitle),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  if (navigations == Navigations.Home) ...[
                    Consumer<HomeProvider>(builder: (_, provider, __) {
                      return _pageBannerDateText(date: provider.selectDateTime);
                    }),
                  ] else if (navigations == Navigations.Schedule) ...[
                    Consumer<CalendarlProvider>(builder: (_, provider, __) {
                      return _pageBannerDateText(date: provider.focusedDay);
                    }),
                  ] else if (navigations == Navigations.Todo) ...[
                    Consumer<TodoProvider>(builder: (_, provider, __) {
                      return _pageBannerDateText(date: provider.focusedDay);
                    }),
                  ] else ...[
                    Consumer<DiaryProvider>(builder: (_, provider, __) {
                      return _pageBannerDateText(date: provider.focusedDay);
                    }),
                  ]
                ],
              ),
            ),
            Visibility(
              visible: navigations != Navigations.Home,
              child: GestureDetector(
                onTap: () {
                  _pageBannerButtonFunction(
                      context: context, navigations: navigations);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: ShapeDecoration(
                      shape: const StadiumBorder(), color: colorPalete.last),
                  child: navigations != Navigations.Diary
                      ? Text(
                          "+ Add ${navigations.name}",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        )
                      : Text(
                          Provider.of<DiaryProvider>(context)
                                  .selectedEvents
                                  .isEmpty
                              ? "+ Add ${navigations.name}"
                              : "Edit ${navigations.name}",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                ),
              ),
            )
          ],
        ));
  }

  RichText _pageBannerDateText({required DateTime date}) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black, fontSize: 14),
        text: DateFormat('EEEE, ').format(date),
        children: [
          TextSpan(
              text: DateFormat('d MMMM').format(date),
              style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }

  void _pageBannerButtonFunction(
      {required BuildContext context, required Navigations navigations}) {
    switch (navigations) {
      case Navigations.Home:
        break;

      case Navigations.Schedule:
        scheduleBottomSheet(context, null);
        break;
      case Navigations.Todo:
        todoBottomSheet(context, null);
        break;
      case Navigations.Diary:
        addEditDiaryFun(
            context,
            Provider.of<DiaryProvider>(context, listen: false)
                    .selectedEvents
                    .isEmpty
                ? true
                : false);
        break;
    }
  }
}
