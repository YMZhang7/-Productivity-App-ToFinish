import 'package:ToFinish/components/animation_box.dart';
import 'package:ToFinish/models/Task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'task_box.dart';

class TasksMatrix extends StatefulWidget {
  final List<Task> tasks;
  const TasksMatrix({@required this.tasks});

  @override
  _TasksMatrixState createState() => _TasksMatrixState();
}

class _TasksMatrixState extends State<TasksMatrix> with TickerProviderStateMixin{
  AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1)
    );
    _controller.forward();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(20.0),
      scrollDirection: Axis.vertical,
      crossAxisCount: 2,
      children: getMatrix(widget.tasks),
      crossAxisSpacing: 30.0,
      mainAxisSpacing: 30.0,
    );
  }

  List<Widget> getMatrix(List<Task> tasks){
    List<Widget> matrix = [];
    for (int i = 0; i < tasks.length; i++){
        matrix.add(
          AnimationBox(child: TaskBox(task: tasks[i]), index: i+1, total: tasks.length, controller: _controller,), 
        );
    }
    return matrix;
  }
}