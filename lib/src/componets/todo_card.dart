import 'package:diary/src/componets/bottom_sheet_function.dart';
import 'package:diary/src/constants.dart';
import 'package:diary/src/models/todo.dart';
import 'package:diary/src/providers/todo_proivder.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class TodoCard extends StatelessWidget {
  final bool isHome;
  final Todo todo;
  const TodoCard({Key? key, required this.isHome, required this.todo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TodoProvider todoProvider =
        Provider.of<TodoProvider>(context, listen: false);
    return Container(
      margin: const EdgeInsets.only(top: 16, left: 20, right: 20),
      decoration: BoxDecoration(
          color: colorPalete[todo.color],
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                spreadRadius: 4)
          ]),
      child: Container(
        margin: const EdgeInsets.only(right: 30),
        padding: isHome
            ? const EdgeInsets.all(8)
            : const EdgeInsets.only(right: 10, top: 10, bottom: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                if (isHome == false) {
                  todo.isComplete = !todo.isComplete;
                  todoProvider.updateTodo(todo, false);
                }
              },
              icon: Icon(
                todo.isComplete ? LineIcons.checkCircle : LineIcons.circle,
                color: const Color(0xffEEC2C3),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.createTime.toString(),
                    maxLines: 1,
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    todo.title,
                    style: TextStyle(
                        decoration: todo.isComplete
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Visibility(
                    visible: !isHome,
                    child: Text(todo.notes,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        )),
                  )
                ],
              ),
            ),
            Visibility(
              visible: !isHome,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                      onTap: () {
                        todoBottomSheet(context, todo);
                      },
                      child: const Text("Edit")),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      onTap: () {
                        todoProvider.deleteTodo(todo);
                      },
                      child: const Icon(
                        LineIcons.trash,
                        size: 20,
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
