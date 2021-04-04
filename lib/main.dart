import 'package:ToFinish/components/tasks_matrix.dart';
import 'package:ToFinish/models/Ticker.dart';
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
          ),
          BlocProvider(
            create: (context) => TagsBloc(),
          ),
          // BlocProvider(
          //   create: (context) => SubtimersBloc(),
          // ),
        ], 
        child: HomeScreen(),
      ),
    );
  }
}