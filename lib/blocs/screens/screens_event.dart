import 'package:ToFinish/models/Task.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';



abstract class ScreensEvent extends Equatable{}

class TaskBoxPressed extends ScreensEvent{
  Task task;
  TaskBoxPressed({@required this.task});
  @override
  List<Object> get props => [task];
}

class ListButtonPressed extends ScreensEvent {
  @override
  List<Object> get props => [];
}

class GridButtonPressed extends ScreensEvent {
  @override
  List<Object> get props => [];
}

class HomeButtonPressed extends ScreensEvent {
  @override
  List<Object> get props => [];
}

class ForwardButtonPressed extends ScreensEvent {
  Task task;
  ForwardButtonPressed({@required this.task});
  @override
  List<Object> get props => [];
}

class BackButtonPressed extends ScreensEvent {
  @override
  List<Object> get props => [];
}

class AddButtonPressed extends ScreensEvent {
  @override
  List<Object> get props => [];
}

class EditTask extends ScreensEvent {
  Task task;
  EditTask({@required this.task});
  @override
  List<Object> get props => [task];
}

class ReloadTimerScreen extends ScreensEvent{
  Task task;
  ReloadTimerScreen({@required this.task});
  @override
  List<Object> get props => [task];
}
