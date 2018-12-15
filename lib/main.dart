import 'package:flutter/material.dart';
import 'screens/todo_list.dart';

void main() => runApp(MinimalTodoApp());

class MinimalTodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.orange,
      theme: ThemeData(
        primaryColor: Colors.purple,
        fontFamily: 'Montserrat',
        accentColor: Colors.deepPurpleAccent,
        cursorColor: Colors.purple,
      ),
      debugShowCheckedModeBanner: false,
      title: 'Minimal Todo',
      home: TodoList(),
    );
  }
}
