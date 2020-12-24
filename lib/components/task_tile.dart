import 'package:ToFinish/blocs/blocs.dart';
import 'package:ToFinish/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/Task.dart';
import '../custom_colour_scheme.dart';

class TaskTile extends StatefulWidget {
  final Task task;
  final Function(int) toDelete;
  const TaskTile({@required this.task, @required this.toDelete});
  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Dismissible(
          key: Key(widget.task.id.toString()),
          onDismissed: (direction){
            setState(() {
              if (direction == DismissDirection.startToEnd){
                BlocProvider.of<ScreensBloc>(context).add(EditTask(task: widget.task));
              } else {
                widget.toDelete(widget.task.id);
                BlocProvider.of<TodoBloc>(context).add(DeleteTask(widget.task));
              }
            });
          },
          child: GestureDetector(
            onTap: () => BlocProvider.of<ScreensBloc>(context).add(TaskBoxPressed(task: widget.task)),
            child: Container(
              height: 90.0,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.colour4,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                boxShadow: [BoxShadow(
                  color: Colors.grey.withOpacity(.5),
                  blurRadius: 10.0,
                  spreadRadius: 0.0,
                  offset: Offset(
                    5.0, // Move to right 10  horizontally
                    5.0, // Move to bottom 10 Vertically
                  ),
                )],
              ),
              child: checkBoxTile(),
            ),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(Icons.delete_outline, color: Colors.white,),
              ),
            ),
          ),
          background: Container(
            color: Colors.green,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(Icons.edit, color: Colors.white,),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget checkBoxTile(){
    List<Widget> textsShowing = [
      Text(widget.task.description, style: TextStyle(fontSize: 20.0,), overflow: TextOverflow.ellipsis,),
      SizedBox(height: 10.0,),
    ];
    if (widget.task.isCompleted){
      textsShowing.add(
        Text('Task completed using ' + timeConverter(widget.task.timeElapsed))
      );
      textsShowing.add(
        SizedBox(height: 2.0,)
      );
      textsShowing.add(
        Text('Original goal: ' + timeConverter(widget.task.time))
      );
    } else {
      textsShowing.add(
        Text('Goal: finish within ' + timeConverter(widget.task.time))
      );
      textsShowing.add(
        SizedBox(height: 2.0,)
      );
      textsShowing.add(
        Text(timeConverter(widget.task.time - widget.task.timeElapsed) + ' left')
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Checkbox(
            value: widget.task.isCompleted, 
            onChanged: (value){
              setState(() {
                widget.task.isCompleted = !widget.task.isCompleted;
                BlocProvider.of<TodoBloc>(context).add(UpdateTask(task: widget.task));
              });
            },
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 5.0, bottom: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: textsShowing,
            ),
          ),
        )
      ],
    );
  }
}