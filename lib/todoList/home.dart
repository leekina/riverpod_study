import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpod_example/example/data.dart';
import 'package:riverpod_example/example/todo.dart';

final _currentTodo = Provider<Todo>((ref) => throw UnimplementedError());

class Home2 extends ConsumerWidget {
  Home2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(filteredTodos);
    final textController = TextEditingController();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
          children: [
            Title(),
            TextField(
              controller: textController,
              decoration: InputDecoration(
                labelText: 'What needs to be done?',
              ),
              onSubmitted: (value) {
                textController.clear();
              },
            ),
            SizedBox(height: 42.h),
            const ToolBar(),
            if (todos.isNotEmpty) Divider(height: 0),
            for (var i = 0; i < todos.length; i++) ...[
              if (i > 0) Divider(height: 0),
              ProviderScope(
                overrides: [
                  _currentTodo.overrideWithValue(todos.elementAt(i)),
                ],
                child: TodoItem(),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class TodoItem extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todo = ref.watch(_currentTodo);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
          )
        ],
      ),
      child: ListTile(
        leading: Checkbox(
          value: todo.completed,
          onChanged: (value) {
            ref.read(todoListProvider.notifier).toggle(todo.id);
          },
        ),
        title: Text(todo.description),
      ),
    );
  }
}

class ToolBar extends ConsumerWidget {
  const ToolBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(todoListFilter);
    Color? textColor(TodoListFilter value) {
      return filter == value ? Colors.green : Colors.black;
    }

    return Row(
      children: [
        Expanded(
          child: Text(
            '${ref.watch(uncompletedTodosCount)}item left',
          ),
        ),
        Tooltip(
          message: 'All',
          child: TextButton(
            onPressed: () {
              ref.read(todoListFilter.notifier).state = TodoListFilter.all;
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(
                textColor(TodoListFilter.all),
              ),
            ),
            child: Text('All'),
          ),
        ),
        Tooltip(
          message: 'Active',
          child: TextButton(
            onPressed: () {
              ref.read(todoListFilter.notifier).state = TodoListFilter.active;
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(
                textColor(TodoListFilter.active),
              ),
            ),
            child: Text('Active'),
          ),
        ),
        Tooltip(
          message: 'Completed',
          child: TextButton(
            onPressed: () {
              ref.read(todoListFilter.notifier).state =
                  TodoListFilter.completed;
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(
                textColor(TodoListFilter.completed),
              ),
            ),
            child: Text('Completed'),
          ),
        ),
      ],
    );
  }
}

class Title extends StatelessWidget {
  const Title({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'todos',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color.fromARGB(38, 47, 47, 247),
        fontSize: 100.w,
        fontWeight: FontWeight.w100,
        fontFamily: 'Helvetica Neue',
      ),
    );
  }
}
