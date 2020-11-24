import 'package:ToFinish/models/Task.dart';
import 'package:equatable/equatable.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();
  @override
  List<Object> get props => [];
}

class LoadTasks extends TodoEvent {}

class AddTask extends TodoEvent {
  final Task task;
  const AddTask ({this.task});

  @override
  List<Object> get props => [task];
  @override
  String toString() => 'AddTask { task: $task }';
}

class UpdateTask extends TodoEvent {
  final Task task;
  const UpdateTask ({this.task});

  @override
  List<Object> get props => [task];
  @override
  String toString() => 'AddTask { task: $task }';
}

class DeleteTask extends TodoEvent {
  final Task task;

  const DeleteTask(this.task);

  @override
  List<Object> get props => [task];

  @override
  String toString() => 'DeleteTask { task: $task }';
}
