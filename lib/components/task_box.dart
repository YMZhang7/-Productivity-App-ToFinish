import 'package:ToFinish/blocs/blocs.dart';
import 'package:ToFinish/models/Task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../custom_colour_scheme.dart';
import '../functions.dart' as utility;

class TaskBox extends StatelessWidget {
  final Task task;
  const TaskBox({@required this.task});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        BlocProvider.of<ScreensBloc>(context).add(TaskBoxPressed(task: task));
      },
      child: Card(
        child: Container(
          width: 150.0,
          height: 150.0,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.colour3,
          ),
          child: Stack(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(child: Text(utility.timeConverter(task.time - task.timeElapsed), style: TextStyle(fontSize: 20.0),)),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(child: Text(task.description, style: TextStyle(fontSize: 15.0),)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}