import 'dart:async';

import 'package:ToFinish/database/database.dart';
import 'package:ToFinish/models/Task.dart';
import 'package:bloc/bloc.dart';
import '../blocs.dart';


class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TasksLoadInProgress());
  DBHelper dbHelper = DBHelper();

  @override
  void onTransition(Transition<TodoEvent, TodoState> transition) {
    print(transition);
    super.onTransition(transition);
  }

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
        List<Task> tasks = await dbHelper.getTodos();
        yield TasksLoadInProgress();
        yield TasksLoadSuccess(tasks);
      } catch (_){
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
      print(_);
      yield TasksLoadFailure();
    }
  }

  Stream<TodoState> _mapAddTaskToState(AddTask event) async*{
    if (state is TasksLoadSuccess){
      try {
        await dbHelper.addTodo(event.task);
        List<Task> tasks = List.from((state as TasksLoadSuccess).tasks)..add(event.task);
        yield TasksLoadInProgress();
        yield TasksLoadSuccess(tasks);
      } catch (_){
        print(_);
        yield TasksLoadFailure();
      }
    }
  }

  Stream<TodoState> _mapDeleteTaskToState(DeleteTask event) async*{
    if (state is TasksLoadSuccess){
      try {
        await dbHelper.deleteTodo(event.task.id);
        List<Task> tasks = List.from((state as TasksLoadSuccess).tasks)..remove(event.task);
        yield TasksLoadInProgress();
        yield TasksLoadSuccess(tasks);
      } catch (_){
        print(_);
        yield TasksLoadFailure();
      }
    }
  }
}
