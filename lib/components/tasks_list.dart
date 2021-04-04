import 'package:ToFinish/blocs/blocs.dart';
import 'package:ToFinish/components/animation_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/Task.dart';
import 'components.dart';
import '../custom_colour_scheme.dart';

class TasksList extends StatefulWidget {
  final List<Task> tasks;
  final bool showCompleted;
  final String tag;
  const TasksList({@required this.tasks, @required this.showCompleted, @required this.tag});

  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  @override
Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(0.0),
      scrollDirection: Axis.vertical,
      children: getTiles(context, widget.tasks),
    );
  }

  List<Widget> getTiles(BuildContext context, List<Task> tasks){
    List<Widget> tiles = [];
    for (int i = 0; i < tasks.length; i++){
      if (widget.tag == 'all' || widget.tag == tasks[i].tag){
        if (!widget.showCompleted && tasks[i].isCompleted){
          continue;
        } else {
          tiles.add(
            AnimationListTile(
              child: TaskTile(
                task: tasks[i],
                toDelete: (value){
                  for (int i = 0; i < tasks.length; i++){
                    if (tasks[i].id == value){
                      setState(() {
                        tasks.removeAt(i);
                      });
                      break;
                    }
                  }
                },
              ), 
              index: i + 1, 
              total: tasks.length,
            )
          );
          tiles.add(SizedBox(height: 5.0,));
        }
      }
    }
    return tiles;
  }
}