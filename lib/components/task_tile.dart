import 'package:ToFinish/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/Task.dart';

class TaskTile extends StatefulWidget {
  final Task task;
  const TaskTile({@required this.task});
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
              BlocProvider.of<TodoBloc>(context).add(DeleteTask(widget.task));
            });
          },
          child: Container(
            height: 50.0,
            decoration: BoxDecoration(
              color: Colors.lightGreen.withOpacity(.3),
              borderRadius: BorderRadius.all(Radius.circular(10.0))
            ),
            child: CheckboxListTile(
              value: widget.task.isCompleted, // controls whether the box is checked
              onChanged: (value){
                setState(() {
                  widget.task.isCompleted = !widget.task.isCompleted;
                  BlocProvider.of<TodoBloc>(context).add(UpdateTask(task: widget.task));
                });
              },
              title: Text(widget.task.description),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
          background: Container(
            color: Colors.red,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(Icons.delete_outline, color: Colors.white,),
              ),
            ),
          ),
        ),
        Divider(height: 1.0,)
      ],
    );
  }
}