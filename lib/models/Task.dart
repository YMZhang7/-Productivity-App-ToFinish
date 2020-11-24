import 'package:flutter/material.dart';

class Task {
  int id;
  int time; // second
  int timeElapsed = 0; // second
  String description;
  String dateTime;
  bool isCompleted = false;
  
  Task({this.id, @required this.time, @required this.timeElapsed,@required this.description, @required this.dateTime, @required this.isCompleted});

  Map<String, dynamic> toMap() => <String, dynamic>{
    'id': id,
    'description': description,
    'time': time,
    'time_elapsed': timeElapsed,
    'date_time': dateTime,
    'is_completed': isCompleted ? 1 : 0,
  };

  factory Task.fromMap(Map<String, dynamic> map) => new Task(
    id: map['id'],
    time: map['time'],
    timeElapsed: map['time_elapsed'],
    description: map['description'],
    dateTime: map['dateTime'],
    isCompleted: map['is_completed'] == 1 ? true : false,
  );
}