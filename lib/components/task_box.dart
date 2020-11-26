import 'package:ToFinish/blocs/blocs.dart';
import 'package:ToFinish/models/Task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../custom_colour_scheme.dart';
import '../functions.dart' as utility;
import 'dart:math' as math;

class TaskBox extends StatefulWidget {
  final Task task;
  const TaskBox({@required this.task});

  @override
  _TaskBoxState createState() => _TaskBoxState();
}

class _TaskBoxState extends State<TaskBox> with TickerProviderStateMixin{
  AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        BlocProvider.of<ScreensBloc>(context).add(TaskBoxPressed(task: widget.task));
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder:  (BuildContext context, Widget child) {
          return Transform.rotate(
            angle: _controller.value * 2.0 * math.pi,
            child: child,
          );
        },
        child: Container(
          width: 150.0,
          height: 150.0,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.colour3,
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
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(child: Text(utility.timeConverter(widget.task.time - widget.task.timeElapsed), style: TextStyle(fontSize: 20.0),)),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(child: Text(widget.task.description, style: TextStyle(fontSize: 15.0),)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}