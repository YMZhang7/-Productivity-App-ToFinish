import 'package:flutter/material.dart';
import '../models/Task.dart';
import 'components.dart';
import '../custom_colour_scheme.dart';

class TasksList extends StatelessWidget {
  final ScrollController controller;
  final List<Task> tasks;
  const TasksList({@required this.controller, @required this.tasks});

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      children: getTiles(context, tasks),
    );
  }

  List<Widget> getTiles(BuildContext context, List<Task> tasks){
    List<Widget> tiles = [];
    tiles.add(
      Center(
        child: Icon(Icons.arrow_upward),
      )
    );
    tiles.add(
      Container(
        height: 50.0,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.colour4.withOpacity(.8),
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