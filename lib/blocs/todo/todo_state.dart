import 'package:ToFinish/components/tasks_list.dart';
import 'package:ToFinish/models/Task.dart';
import 'package:equatable/equatable.dart';

abstract class TodoState extends Equatable {
  const TodoState();
  
  @override
  List<Object> get props => [];
}

class TasksLoadInProgress extends TodoState {}

class TasksLoadSuccess extends TodoState {
  final List<Task> tasks;
  
  const TasksLoadSuccess([this.tasks = const []]);

  @override
  List<Object> get props => [tasks];

  @override
  String toString() => 'TasksLoadSuccess { tasks: $tasks }';
}

class TasksLoadFailure extends TodoState {}
