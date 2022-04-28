import 'package:diary/src/models/diary.dart';
import 'package:flutter/material.dart';

class DiaryCard extends StatelessWidget {
  final bool isHome;

  final Diary diary;
  const DiaryCard({Key? key, required this.diary, required this.isHome})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            diary.title,
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            diary.body,
            style: const TextStyle(fontSize: 16, height: 1.5),
          )
        ],
      ),
    );
  }
}
