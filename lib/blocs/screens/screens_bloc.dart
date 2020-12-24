import 'dart:async';

import 'package:bloc/bloc.dart';

import '../blocs.dart';

class ScreensBloc extends Bloc<ScreensEvent, ScreensState> {
  ScreensBloc() : super(InTimersListScreen()); // set which screen is the homescreen

  //  @override
  // void onTransition(Transition<ScreensEvent, ScreensState> transition) {
  //   print(transition);
  //   super.onTransition(transition);
  // }

  @override
  Stream<ScreensState> mapEventToState(
    ScreensEvent event,
  ) async* {
    if (event is TaskBoxPressed){
      yield InTLTimerScreen(task: event.task);
    } else if (event is ListButtonPressed){
      yield InListScreen();
    } else if (event is HomeButtonPressed){
      yield InTimersListScreen();
    } else if(event is GridButtonPressed){
      yield InTimersMatrixScreen();
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
      } else if (state is InTLEditNewTaskScreen){
        yield InTimersListScreen();
      } else if (state is InLEditNewTaskScreen){
        yield InListScreen();
      } else if (state is InTMAddNewTaskScreen){
        yield InTimersMatrixScreen();
      }
    } else if (event is AddButtonPressed){
      if (state is InTimersListScreen){
        yield InTLAddNewTaskScreen();
      } else if (state is InListScreen){
        yield InLAddNewTaskScreen();
      } else if (state is InTimersMatrixScreen){
        yield InTMAddNewTaskScreen();
      }
    } else if (event is EditTask){
      if (state is InTimersListScreen){
        yield InTLEditNewTaskScreen(task: event.task);
      } else if (state is InListScreen){
        yield InLEditNewTaskScreen(task: event.task);
      }
    } else if (event is ReloadTimerScreen){
      if (state is InTLTimerScreen){
        yield InTLTimerScreen(task: event.task);
      } else if (state is InLTimerScreen){
        yield InLTimerScreen(task: event.task);
      }
    }
  }
}
