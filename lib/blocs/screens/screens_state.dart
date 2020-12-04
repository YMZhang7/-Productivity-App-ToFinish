import 'package:ToFinish/models/Task.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';


abstract class ScreensState extends Equatable{
  final Task task;
  const ScreensState({this.task});
  @override
  List<Object> get props => [task];
}

class InTimersListScreen extends ScreensState {}

class InTLTimerScreen extends ScreensState {
  final Task task;
  const InTLTimerScreen({@required this.task}):super(task: task);
  @override
  List<Object> get props => [this.task];
}

class InLTimerScreen extends ScreensState {
  final Task task;
  const InLTimerScreen({@required this.task}):super(task: task);
  @override
  List<Object> get props => [this.task];
}

class InListScreen extends ScreensState {}

class InTLAddNewTaskScreen extends ScreensState {}

class InLAddNewTaskScreen extends ScreensState {}

class InTLEditNewTaskScreen extends ScreensState{
  final Task task;
  const InTLEditNewTaskScreen({@required this.task}):super(task: task);
  @override
  List<Object> get props => [task];
}

class InLEditNewTaskScreen extends ScreensState {
  final Task task;
  const InLEditNewTaskScreen({@required this.task}):super(task: task);
  @override
  List<Object> get props => [this.task];
}