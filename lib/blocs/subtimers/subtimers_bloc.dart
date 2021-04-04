import 'dart:async';
import 'package:ToFinish/database/database.dart';
import 'package:ToFinish/models/Task.dart';
import 'package:bloc/bloc.dart';
import '../blocs.dart';


class SubtimersBloc extends Bloc<SubtimersEvent, SubtimersState> {
  SubtimersBloc() : super(SubtasksLoadInProcess());
  DBHelper dbHelper = DBHelper();

  // @override
  // void onTransition(Transition<TodoEvent, TodoState> transition) {
  //   print(transition);
  //   super.onTransition(transition);
  // }

  @override
  Stream<SubtimersState> mapEventToState(
    SubtimersEvent event,
  ) async* {
    if (event is LoadSubtimers){
      yield* _mapLoadSubtimersToState(event);
    } else if (event is UpdateSubtimer){
      yield* _mapUpdateSubtimerToState(event);
    }
  }

  Stream<SubtimersState> _mapLoadSubtimersToState(LoadSubtimers event) async*{
    try {
      List<Task> tasks = await dbHelper.getSubTimers(event.id);
      yield SubtasksLoadInProcess();
      yield SubtasksLoadSuccess(tasks: tasks);
    } catch(_){
      print ('Error in _mapGetSubTasksToState: ');
      print(_);
      yield SubtasksLoadFailure();
    }
  }

  Stream<SubtimersState> _mapUpdateSubtimerToState(UpdateSubtimer event) async*{
    try{
      if (state is SubtasksLoadSuccess){
        yield SubtasksLoadInProcess();
        await dbHelper.updateSubtimer(event.tableId, event.task);
        List<Task> subtasks = await dbHelper.getSubTimers(event.tableId);
        yield SubtasksLoadSuccess(tasks: subtasks);
      }
    } catch(_){
      print('Error in _mapUpdateSubtimerToState: ');
      print(_);
      yield SubtasksLoadFailure();
    }
  }
}
