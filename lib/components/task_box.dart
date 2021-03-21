import 'package:ToFinish/blocs/blocs.dart';
import 'package:ToFinish/models/Task.dart';
import 'package:ToFinish/models/Timer.dart';
import 'package:ToFinish/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../custom_colour_scheme.dart';
import '../functions.dart' as utility;


class TaskBox extends StatelessWidget{
  final Task task;
  const TaskBox({@required this.task});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (taskboxContext) => 
            BlocProvider.value(
              value: context.bloc<TodoBloc>(),
              child: BlocProvider(
                create: (context) => TimerBloc(ticker: Timer(), task: task),
                child: TimersScreen(task: task)),
              ),
            )
        );
      },
      child: Container(
        width: 150.0,
        height: 150.0,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.colour1,
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
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
        child: Stack(
          children: [
            Center(child: Text(utility.timeConverter(task.time - task.timeElapsed), style: TextStyle(fontSize: 20.0),)),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {   
                double widthOfText = constraints.maxWidth * 0.7;  
                return Center(
                  child: Container(
                    width: widthOfText,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Center(child: Text(task.description, style: TextStyle(fontSize: 15.0), overflow: TextOverflow.ellipsis,),),
                      ],
                    ),
                  ),
                );
              }
            )
          ],
        ),
      ),
    );
  }
}