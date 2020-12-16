import 'package:ToFinish/components/animation_list_tile.dart';
import 'package:flutter/material.dart';
import '../models/Task.dart';
import 'components.dart';
import '../custom_colour_scheme.dart';

class TasksList extends StatefulWidget {
  final ScrollController controller;
  final List<Task> tasks;
  final bool headerRequired;
  const TasksList({@required this.controller, @required this.tasks, @required this.headerRequired});

  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> with TickerProviderStateMixin{
 

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: widget.controller,
      children: getTiles(context, widget.tasks),
    );
  }

  List<Widget> getTiles(BuildContext context, List<Task> tasks){
    List<Widget> tiles = [];
    if (widget.headerRequired){
      tiles.add(
        Center(
          child: Icon(Icons.arrow_upward),
        )
      );
      tiles.add(
        AnimationListTile(
          child: Container(
            height: 50.0,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.colour3.withOpacity(.9),
              borderRadius: BorderRadius.all(Radius.circular(10.0))
            ),
            child: Center(child: Text('To-Do List', style: TextStyle(fontSize: 20.0),),),
          ),
          index: 1,
          total: tasks.length + 1,
        )
      );
      tiles.add(Divider(height: 5.0,));
      for (int i = 0; i < tasks.length; i++){
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
            index: i + 2, 
            total: tasks.length + 1, 
          )
        );
        tiles.add(SizedBox(height: 5.0,));
      }
    } else {
      for (int i = 0; i < tasks.length; i++){
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
    return tiles;
  }
}