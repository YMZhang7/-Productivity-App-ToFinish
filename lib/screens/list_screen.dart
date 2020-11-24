import 'package:ToFinish/blocs/screens/screens_bloc.dart';
import 'package:ToFinish/components/components.dart';
import 'package:ToFinish/models/Task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/blocs.dart';
import '../custom_colour_scheme.dart';

class ListScreen extends StatelessWidget {
  // final List<Task> tasks;
  // const ListScreen({@required this.tasks});

  @override
  Widget build(BuildContext context) {
    // // retrieve from database
    // Task task1 = new Task(time: 120, timeElapsed: 0, description: 'task1', dateTime: new DateTime.now(), isCompleted: false);
    // Task task2 = new Task(time: 120, timeElapsed: 0, description: 'task2', dateTime: new DateTime.now(), isCompleted: false);
    // Task task3 = new Task(time: 120, timeElapsed: 0, description: 'task3', dateTime: new DateTime.now(), isCompleted: false);
    // Task task4 = new Task(time: 120, description: 'task4', timeElapsed: 0, dateTime: new DateTime.now(), isCompleted: false);
    // List<Task> tasks = [task1, task2, task3, task4];
    return Scaffold(
      appBar: AppBar(
        title: Text("Mona's Day", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.grid_view, color: Colors.black,), 
            onPressed: () => BlocProvider.of<ScreensBloc>(context).add(GridButtonPressed()),
          )
        ],
        elevation: 0.0,
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TasksLoadInProgress){
            BlocProvider.of<TodoBloc>(context).add(LoadTasks());
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TasksLoadSuccess){
            return Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: getTaskTiles(state.tasks),
              )
            );
          } else if (state is TasksLoadFailure){
            return Center(
              child: Text('Something went wrong'),
            );
          } else {
            return Container(height: 0.0, width: 0.0,);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          BlocProvider.of<ScreensBloc>(context).add(AddButtonPressed());
        }, 
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.colour4,
      ),
    );
  }

  List<Widget> getTaskTiles(List<Task>tasks){
    List<Widget> tiles = [];
    if (tasks.length == 0){
      tiles.add(
        Center(child: Text('Nothing for now. Take a break!'),)
      );
    } else {
      for (int i = 0; i < tasks.length; i++){
        tiles.add(TaskTile(task: tasks[i],));
        tiles.add(Divider(height: 5.0,));
      }
    }
    return tiles;
  }
}