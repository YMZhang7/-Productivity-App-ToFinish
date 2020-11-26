import 'package:ToFinish/components/components.dart';
import 'package:ToFinish/models/Timer.dart';
import 'package:ToFinish/screens/add_new_task_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/blocs.dart';
import 'screens/screens.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: BlocProvider(
      //   create: (context) => ScreensBloc(),
      //   child: AllScreens(),
      // ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ScreensBloc(),
          ),
          BlocProvider(create: (context) => TodoBloc(),)
        ], 
        child: AllScreens(),
      ),
    );
  }
}

class AllScreens extends StatefulWidget {
  @override
  _AllScreensState createState() => _AllScreensState();
}

class _AllScreensState extends State<AllScreens> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScreensBloc, ScreensState>(
      builder: (context, state){
        if (state is InTimersListScreen){
          return TimersListScreen();
        } else if (state is InTLTimerScreen){
          return BlocProvider(
            create: (context) => TimerBloc(ticker: Timer(), task: state.task),
            child: TimerScreen(task: state.task),
          );
        } else if (state is InLTimerScreen){
          return BlocProvider(
            create: (context) => TimerBloc(ticker: Timer(), task: state.task),
            child: TimerScreen(task: state.task),
          );
        } else if (state is InListScreen){
          return ListScreen();
        } else if (state is InTLAddNewTaskScreen || state is InLAddNewTaskScreen){
          return AddNewTaskScreen();
        } else {
          return Container(height: 0.0,width: 0.0,);
        }
      },
    );
  }
}