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
  AnimationController _controller;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 400 * widget.tasks.length),
      vsync: this
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
          controller: _controller,
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
        tiles.add(AnimationListTile(controller: _controller, child: TaskTile(task: tasks[i]), index: i + 2, total: tasks.length + 1,));
        // tiles.add(Divider(height: 5.0,));
        tiles.add(SizedBox(height: 5.0,));
      }
    } else {
      for (int i = 0; i < tasks.length; i++){
        tiles.add(AnimationListTile(controller: _controller, child: TaskTile(task: tasks[i]), index: i + 1, total: tasks.length,));
        // tiles.add(Divider(height: 5.0,));
        tiles.add(SizedBox(height: 5.0,));
      }
    }
    return tiles;
  }
}