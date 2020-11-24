import 'package:ToFinish/models/Task.dart';
import 'package:meta/meta.dart';


abstract class ScreensState {}

class InTimersListScreen extends ScreensState {}

class InTLTimerScreen extends ScreensState {
  Task task;
  InTLTimerScreen({@required this.task});
}

class InLTimerScreen extends ScreensState {
  Task task;
  InLTimerScreen({@required this.task});
}

class InListScreen extends ScreensState {}

class InTLAddNewTaskScreen extends ScreensState {}

class InLAddNewTaskScreen extends ScreensState {}