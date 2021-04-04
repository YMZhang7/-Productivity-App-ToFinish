import 'package:ToFinish/models/Task.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();
  @override
  List<Object> get props => [];
}

class LoadTasks extends TodoEvent {}

class AddTask extends TodoEvent {
  final Task task;
  final List<Task> subtasks;
  const AddTask ({@required this.task, @required this.subtasks});

  @override
  List<Object> get props => [task];
  @override
  String toString() => 'AddTask { task: $task }';
}

class UpdateTask extends TodoEvent {
  final Task task;
  const UpdateTask ({@required this.task});

  @override
  List<Object> get props => [task];
  @override
  String toString() => 'UpdateTask { task: $task }';
}

class DeleteTask extends TodoEvent {
  final Task task;

  const DeleteTask(this.task);

  @override
  List<Object> get props => [task];

  @override
  String toString() => 'DeleteTask { task: $task }';
}

class CreateSubTasks extends TodoEvent {
  final String tableName;
  final List<Task> subtimers;

  const CreateSubTasks({@required this.tableName, @required this.subtimers});

  @override
  List<Object> get props => [tableName, subtimers];

  @override
  String toString() => 'CreateSubTasks { tableName: $tableName, subtimers: $subtimers }';
}

class GetSubTasks extends TodoEvent {
  final int id;
  const GetSubTasks({@required this.id});

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'GetSubTasks { id: $id }';
}