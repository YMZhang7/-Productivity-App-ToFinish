import 'package:ToFinish/components/tasks_matrix.dart';
import 'package:ToFinish/models/Timer.dart';
import 'package:ToFinish/screens/add_new_task_screen.dart';
import 'package:ToFinish/screens/home_screen.dart';
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
          BlocProvider(create: (context) => TodoBloc(),)
        ], 
        child: TimerSquaresScreen(),
      ),
    );
  }
}

class TimerSquaresScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        // color: Colors.red,
        child: Column(
          children: [
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('My Timers', style: Theme.of(context).textTheme.headline1,)
                ]
              )
            ),
            Container(
              height: 30.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Label(text: 'Study',),
                  Label(text: 'Study',),
                  Label(text: 'Study',),
                  Label(text: 'Study',),
                  Label(text: 'Study',),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 30.0),
                height: 500.0,
                // color: Colors.red,
                child: TasksMatrix(showCompleted: true)
              ),
            ),
            Container(
              // color: Colors.red,
              height: 80.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      color: Theme.of(context).colorScheme.colour2,
                    ),
                    child: IconButton(icon: Icon(Icons.add, size: 30.0, color: Colors.white,), onPressed: (){}),
                  ),
                  Row(
                    children: [
                      IconButton(icon: Icon(Icons.list, size: 30.0, ), onPressed: (){}),
                      SizedBox(width: 20.0,),
                      IconButton(icon: Icon(Icons.visibility_rounded, size: 30.0, ), onPressed: (){}),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Label extends StatelessWidget {
  final String text;
  const Label({@required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.0,
      height: 30.0,
      margin: EdgeInsets.only(right: 10.0),
      child: Center(child: Text(this.text)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
        color: Theme.of(context).colorScheme.colour3,
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
            child: TimerScreen(task: state.task),
          );
        } else if (state is InLTimerScreen){
          return BlocProvider(
            create: (context) => TimerBloc(ticker: Timer(), task: state.task),
            child: TimerScreen(task: state.task),
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