import 'dart:async';

import 'package:bloc/bloc.dart';

import '../blocs.dart';

class ScreensBloc extends Bloc<ScreensEvent, ScreensState> {
  ScreensBloc() : super(InTimersListScreen()); // set which screen is the homescreen

  @override
  Stream<ScreensState> mapEventToState(
    ScreensEvent event,
  ) async* {
    if (event is TaskBoxPressed){
      yield InTLTimerScreen(task: event.task);
    } else if (event is ListButtonPressed){
      yield InListScreen();
    } else if (event is GridButtonPressed){
      yield InTimersListScreen();
    } else if (event is ForwardButtonPressed){
      yield InLTimerScreen(task: event.task);
    } else if (event is BackButtonPressed){
      if (state is InTLTimerScreen){
        yield InTimersListScreen();
      } else if (state is InLTimerScreen){
        yield InListScreen();
      } else if (state is InTLAddNewTaskScreen){
        yield InTimersListScreen();
      } else if (state is InLAddNewTaskScreen){
        yield InListScreen();
      }
    } else if (event is AddButtonPressed){
      if (state is InTimersListScreen){
        yield InTLAddNewTaskScreen();
      } else if (state is InListScreen){
        yield InLAddNewTaskScreen();
      }
    }
  }
}
