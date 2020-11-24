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
    for (int i = 0; i < tasks.length; i++){
      tiles.add(TaskTile(task: tasks[i]));
      tiles.add(Divider(height: 1.0,));
    }
    return tiles;
  }
}