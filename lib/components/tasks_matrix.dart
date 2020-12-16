import 'package:ToFinish/components/animation_box.dart';
import 'package:ToFinish/models/Task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'task_box.dart';

class TasksMatrix extends StatelessWidget {
  final List<Task> tasks;
  final bool showCompleted;
  const TasksMatrix({@required this.tasks, @required this.showCompleted});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(20.0),
      scrollDirection: Axis.vertical,
      crossAxisCount: 2,
      children: getMatrix(),
      crossAxisSpacing: 30.0,
      mainAxisSpacing: 30.0,
    );
  }

  List<Widget> getMatrix(){
    List<Widget> matrix = [];
    for (int i = 0; i < tasks.length; i++){
      if (showCompleted){
        matrix.add(
          AnimationBox(child: TaskBox(task: tasks[i]), total: tasks.length), 
        );
      } else {
        if (!tasks[i].isCompleted){
          matrix.add(
            AnimationBox(child: TaskBox(task: tasks[i]), total: tasks.length), 
          );
        }
      }
    }
    return matrix;
  }
}