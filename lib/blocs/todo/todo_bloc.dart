import 'dart:async';

import 'package:ToFinish/database/database.dart';
import 'package:ToFinish/models/Task.dart';
import 'package:bloc/bloc.dart';
import '../blocs.dart';


class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TasksLoadInProgress());
  DBHelper dbHelper = DBHelper();

  // @override
  // void onTransition(Transition<TodoEvent, TodoState> transition) {
  //   print(transition);
  //   super.onTransition(transition);
  // }

  @override
  Stream<TodoState> mapEventToState(
    TodoEvent event,
  ) async* {
    if (event is LoadTasks){
      yield* _mapLoadTasksToState();
    } else if (event is AddTask){
      yield* _mapAddTaskToState(event);
    } else if (event is DeleteTask){
      yield* _mapDeleteTaskToState(event);
    } else if (event is UpdateTask){
      yield* _mapUpdateTaskToState(event);
    }
  }

  Stream<TodoState> _mapUpdateTaskToState(UpdateTask event) async*{
    if (state is TasksLoadSuccess){
      try {
        await dbHelper.updateTodo(event.task);
        // if (event.oldTag != ''){
        //   await dbHelper.updateTag(event.oldTag, event.task.tag);
        // }
        List<Task> tasks = await dbHelper.getTodos();
        yield TasksLoadInProgress();
        yield TasksLoadSuccess(tasks);
      } catch (_){
        print('Error in _mapUpdateTaskToState');
        print(_);
        yield TasksLoadFailure();
      }
    }
  }

  Stream<TodoState> _mapLoadTasksToState() async* {
    try{
      final tasks = await dbHelper.getTodos();
      print(tasks.length);
      yield TasksLoadInProgress();
      yield TasksLoadSuccess(tasks);
    } catch (_){
      print('Error in mapLoadTasksToState: ');
      print(_);
      yield TasksLoadFailure();
    }
  }

  Stream<TodoState> _mapAddTaskToState(AddTask event) async*{
    if (state is TasksLoadSuccess){
      try {
        Task newTask = await dbHelper.addTodo(event.task);
        if (event.subtasks.length > 0){
          await dbHelper.addSubTimers(newTask.id.toString(), event.subtasks);
        }
        List<Task> tasks = List.from((state as TasksLoadSuccess).tasks)..add(newTask);
        yield TasksLoadInProgress();
        yield TasksLoadSuccess(tasks);
      } catch (_){
        print('Error in mapAddTaskToState');
        print(_);
        yield TasksLoadFailure();
      }
    }
  }

  Stream<TodoState> _mapDeleteTaskToState(DeleteTask event) async*{
    if (state is TasksLoadSuccess){
      try {
        await dbHelper.deleteTodo(event.task.id);
        // await dbHelper.deleteTag(event.task.tag);
        List<Task> tasks = List.from((state as TasksLoadSuccess).tasks)..remove(event.task);
        yield TasksLoadInProgress();
        yield TasksLoadSuccess(tasks);
      } catch (_){
        print('Error in _mapDeleteTaskToState: ');
        print(_);
        yield TasksLoadFailure();
      }
    }
  }


  // Stream<TodoState> _mapCreateSubTasksToState(CreateSubTasks event) async*{
  //   if (state is TasksLoadSuccess){
  //     try {
  //       List<Task> subtimers = await dbHelper.addSubTimers(event.tableName, event.subtimers);
  //       List<Task> tasks = List.from((state as TasksLoadSuccess).tasks)..addAll(subtimers);
  //       yield TasksLoadInProgress();
  //       yield TasksLoadSuccess(tasks);
  //     } catch (_){
  //       print('Error in _mapCreateSubTasksToState: ');
  //       print(_);
  //       yield TasksLoadFailure();
  //     }
  //   }
  // }
}
