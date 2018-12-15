import 'package:flutter/material.dart';
import 'package:minimal_todo/models/todo.dart';
import 'package:minimal_todo/utils/db_helper.dart';
import 'package:intl/intl.dart';

class CreateTodo extends StatefulWidget {
  final String appBarTitle;
  final Todo todo;
  CreateTodo(this.todo, this.appBarTitle);
  @override
  State<StatefulWidget> createState() {
    return CreateTodoState(this.todo, this.appBarTitle);
  }
}

class CreateTodoState extends State<CreateTodo> {
  String appBarTitle;
  Todo todo;
  CreateTodoState(this.todo, this.appBarTitle);
  static var _priorities = ['High', 'Low'];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DatabaseHelper helper = DatabaseHelper();

  routeHomePage() {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    titleController.text = todo.title;
    descriptionController.text = todo.description;

    return WillPopScope(
      onWillPop: () => routeHomePage(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          elevation: 0,
          title: Text(
            appBarTitle,
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => routeHomePage(),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: todoInfo(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _save(),
          tooltip: 'Save',
          child: Icon(Icons.done),
        ),
      ),
    );
  }

  Widget todoInfo() {
    return ListView(
      children: <Widget>[
        ListTile(
          title: DropdownButton(
            disabledHint: Container(),
            items: _priorities
                .map(
                  (String selectedItem) => DropdownMenuItem<String>(
                        value: selectedItem,
                        child: Text(
                          selectedItem,
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                )
                .toList(),
            value: getPriorityAsString(todo.priority),
            onChanged: (selectedItem) =>
                setState(() => updatePriorityAsInt(selectedItem)),
          ),
        ),
        getTextWidget('What to you want to do?', 'Title', titleController, 30,
            1, updateTitle),
        getTextWidget('Add a description', 'About Task', descriptionController,
            140, 2, updateDescription),
      ],
    );
  }

  Widget getTextWidget(
      String hintText,
      String labelText,
      TextEditingController editingController,
      int maxLength,
      int maxLine,
      Function func) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: TextField(
        onChanged: (value) => func(),
        maxLength: maxLength,
        maxLines: maxLine,
        controller: editingController,
        decoration: InputDecoration(
          errorStyle: TextStyle(
            color: Colors.redAccent,
            fontSize: 16.0,
          ),
          hintText: hintText,
          labelText: labelText,
        ),
      ),
    );
  }

  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0]; // 'High'
        break;
      case 2:
        priority = _priorities[1]; // 'Low'
        break;
    }
    return priority;
  }

  // Convert the String priority in the form of integer before saving it to Database
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        todo.priority = 1;
        break;
      case 'Low':
        todo.priority = 2;
        break;
    }
  }

  // Update the title of Note object
  void updateTitle() {
    todo.title = titleController.text;
  }

  // Update the description of Note object
  void updateDescription() {
    todo.description = descriptionController.text;
  }

  // Save data to database
  void _save() async {
    routeHomePage();

    todo.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (todo.id != null) {
      // Case 1: Update operation
      result = await helper.updateTodo(todo);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertTodo(todo);
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Tasks Added Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Tasks');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
