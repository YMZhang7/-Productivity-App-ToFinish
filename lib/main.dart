import 'package:ToFinish/components/tasks_matrix.dart';
import 'package:ToFinish/models/Timer.dart';
import 'package:ToFinish/screens/add_new_task_screen.dart';
// import 'package:ToFinish/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakelock/wakelock.dart';

import 'blocs/blocs.dart';
import 'screens/screens.dart';
import 'custom_colour_scheme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          helperStyle: TextStyle(
            color: Colors.red,
          ),
        ),
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold, fontFamily: 'DancingScript', color: Colors.black),
          headline2: TextStyle(fontSize: 15.0, color: Colors.black.withOpacity(0.8))
        )
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ScreensBloc(),
          ),
          BlocProvider(
            create: (context) => TodoBloc(),
          )
        ], 
        child: HomeScreen(),
      ),
    );
  }
}



class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScreensBloc, ScreensState>(
      builder: (context, state){
        if (state is InTimersListScreen){
          return HomeScreen();
        } else if (state is InTimersMatrixScreen){
          return TimersMatrixScreen();
        } else if (state is InTLTimerScreen){
          return BlocProvider(
            create: (context) => TimerBloc(ticker: Timer(), task: state.task),
            child: TimersScreen(task: state.task),
          );
        } else if (state is InLTimerScreen){
          return BlocProvider(
            create: (context) => TimerBloc(ticker: Timer(), task: state.task),
            child: TimersScreen(task: state.task),
          );
        } else if (state is InListScreen){
          return ListScreen();
        } else if (state is InTLAddNewTaskScreen || state is InLAddNewTaskScreen || state is InTMAddNewTaskScreen){
          return AddNewTaskScreen();
        } else if (state is InTLEditNewTaskScreen){
          return AddNewTaskScreen(currentTask: state.task,);
        } else if (state is InLEditNewTaskScreen){
          return AddNewTaskScreen(currentTask: state.task,);
        } else {
          return Container(height: 0.0,width: 0.0,);
        }
      },
    );
  }
}