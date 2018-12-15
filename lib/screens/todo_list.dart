import 'dart:async';
import 'package:flutter/material.dart';
import 'package:minimal_todo/models/todo.dart';
import 'package:minimal_todo/utils/db_helper.dart';
import 'package:minimal_todo/screens/todo_create.dart';
import 'package:sqflite/sqflite.dart';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TodoListState();
  }
}

class TodoListState extends State<TodoList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Todo> todoList;
  var _count = 0;

  @override
  Widget build(BuildContext context) {
    if (todoList == null) {
      todoList = List<Todo>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
        title: Text(
          'Minimal Todo',
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.white70,
            fontSize: 32.0,
          ),
        ),
      ),
      body: getTodoListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => routeListPage(
            Todo(
              '',
              '',
              2,
            ),
            'Add Todo'),
        child: Icon(Icons.create),
        tooltip: 'Add Todo',
      ),
    );
  }

  ListView getTodoListView() {
    return ListView.builder(
      itemCount: _count,
      itemBuilder: (BuildContext context, int position) => Card(
            color: Colors.white,
            elevation: 4.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    getPriorityColor(this.todoList[position].priority),
                child: Icon(Icons.event_note),
              ),
              title: Text(
                this.todoList[position].title,
                style: TextStyle(fontSize: 20.0),
              ),
              subtitle: Text(this.todoList[position].description),
              trailing: IconButton(
                icon: Icon(Icons.remove_circle_outline),
                onPressed: () => _deleteTodo(context, todoList[position]),
              ),
              onTap: () => routeListPage(this.todoList[position], 'Edit Todo'),
            ),
          ),
    );
  }

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.deepPurple;
        break;
      case 2:
        return Colors.purple;
        break;
      default:
        return Colors.purple;
    }
  }

  void _deleteTodo(BuildContext context, Todo todo) async {
    int result = await databaseHelper.deleteTodo(todo.id);
    if (result != 0) {
      _showSnackBar(context, 'Bravo! Task Accomplished!');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String msg) {
    final snackbar = SnackBar(
      content: Text(msg),
      backgroundColor: Colors.deepPurpleAccent,
    );
    Scaffold.of(context).showSnackBar(snackbar);
  }

  void routeListPage(Todo todo, String title) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateTodo(todo, title),
      ),
    );
    if (result == true) updateListView();
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDB();
    dbFuture.then((database) {
      Future<List<Todo>> todoListFuture = databaseHelper.getTodoList();
      todoListFuture.then((todoList) {
        setState(() {
          this.todoList = todoList;
          this._count = todoList.length;
        });
      });
    });
  }
}
