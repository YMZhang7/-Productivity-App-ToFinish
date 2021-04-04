import 'package:flutter/material.dart';

class Task {
  int id;
  int time; // second
  int timeElapsed = 0; // second
  String description;
  String tag;
  String dateTime;
  bool isCompleted = false;
  bool hasSubTimers;
  
  Task({this.id, @required this.time, @required this.timeElapsed,@required this.description, @required this.tag, @required this.dateTime, @required this.isCompleted, @required this.hasSubTimers});

  Map<String, dynamic> toMap() => <String, dynamic>{
    'description': description,
    'tag': tag,
    'time': time,
    'time_elapsed': timeElapsed,
    'date_time': dateTime,
    'is_completed': isCompleted ? 1 : 0,
    'subtimers': hasSubTimers ? 1 : 0,
  };

  factory Task.fromMap(Map<String, dynamic> map) => new Task(
    id: map['id'],
    time: map['time'],
    timeElapsed: map['time_elapsed'],
    description: map['description'],
    tag: map['tag'],
    dateTime: map['dateTime'],
    isCompleted: map['is_completed'] == 1 ? true : false,
    hasSubTimers: map['subtimers'] == 1 ? true : false
  );
}