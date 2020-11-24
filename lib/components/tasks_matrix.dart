import 'package:ToFinish/models/Task.dart';
import 'package:flutter/material.dart';
import 'task_box.dart';

class TasksMatrix extends StatelessWidget {
  final List<Task> tasks;
  const TasksMatrix({@required this.tasks});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 30.0, left: 35.0, right: 35.0),
      children: getMatrix(tasks)
    );
  }

  List<Widget> getMatrix(List<Task> tasks){
    List<Widget> matrix = [];
    if (tasks.length % 2 == 0){
      for (int i = 0; i < tasks.length; i += 2){
        matrix.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TaskBox(task: tasks[i]), // TODO: add content later: i
              TaskBox(task: tasks[i+1]), // i+1
            ],
          )
        );
        matrix.add(SizedBox(height: 30.0,),);
      }
    } else {
      for (int i = 0; i < tasks.length - 1; i += 2){
         matrix.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TaskBox(task: tasks[i]), // TODO: add content later: i
              TaskBox(task: tasks[i+1]), // i+1
            ],
          )
        );
        matrix.add(SizedBox(height: 30.0,),);
      }
      // last element
      matrix.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TaskBox(task: tasks[tasks.length-1]), // length - 1
          ],
        )
      );
    }
    return matrix;
  }
}