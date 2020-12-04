import 'package:ToFinish/models/Task.dart';
import 'package:meta/meta.dart';



abstract class ScreensEvent {}

class TaskBoxPressed extends ScreensEvent{
  Task task;
  TaskBoxPressed({@required this.task});
}

class ListButtonPressed extends ScreensEvent {}

class GridButtonPressed extends ScreensEvent {}

class ForwardButtonPressed extends ScreensEvent {
  Task task;
  ForwardButtonPressed({@required this.task});
}

class BackButtonPressed extends ScreensEvent {}

class AddButtonPressed extends ScreensEvent {}

class EditTask extends ScreensEvent {
  Task task;
  EditTask({@required this.task});
}

class ReloadTimerScreen extends ScreensEvent{
  Task task;
  ReloadTimerScreen({@required this.task});
}
