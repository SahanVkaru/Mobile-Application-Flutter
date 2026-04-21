import 'package:flutter/material.dart';
import 'package:project4/todo.dart';
import 'package:project4/todo_detail_screen.dart';

class TodoScreen extends StatelessWidget {
  final List<Todo> todos;

  const TodoScreen({super.key, required this.todos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todos')),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(todos[index].title),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TodoDetailScreen(todo: todos[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
