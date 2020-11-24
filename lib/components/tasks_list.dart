import 'package:flutter/material.dart';
import '../models/Task.dart';
import 'components.dart';

class TasksList extends StatelessWidget {
  final ScrollController controller;
  final List<Task> tasks;
  const TasksList({@required this.controller, @required this.tasks});

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      children: getTiles(tasks),
    );
  }

  List<Widget> getTiles(List<Task> tasks){
    List<Widget> tiles = [];
    tiles.add(
      Container(
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.amber.withOpacity(.3),
          borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
        child: Center(child: Text('To-Do List', style: TextStyle(fontSize: 20.0),),),
      )
    );
    tiles.add(Divider(height: 5.0,));
    for (int i = 0; i < tasks.length; i++){
      tiles.add(TaskTile(task: tasks[i]));
      tiles.add(Divider(height: 5.0,));
    }
    return tiles;
  }
}