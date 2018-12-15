class Todo {
  int _id, _priority;
  String _title, _description, _date;

  Todo(this._title, this._date, this._priority, [this._description]);
  Todo.withID(this._id, this._title, this._date, this._priority,
      [this._description]);

  int get id => _id;
  int get priority => _priority;
  String get title => _title;
  String get description => _description;
  String get date => _date;

  set title(String title) => this._title = title;
  set description(String description) => this._description = description;
  set date(String date) => this._date = _date;
  set priority(int priority) {
    if (priority >= 1 && priority <= 2) this._priority = priority;
  }

  //Convert in to Map fo DB
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) map['id'] = this._id;
    map['priority'] = this._priority;
    map['title'] = this._title;
    map['description'] = this._description;
    map['date'] = this._date;
    return map;
  }

  //Extracting  a Todo() Objects from Map
  Todo.extracData(Map<String, dynamic> map) {
    this._id = map['id'];
    this._priority = map['priority'];
    this._title = map['title'];
    this._description = map['description'];
    this._date = map['date'];
  }
}
