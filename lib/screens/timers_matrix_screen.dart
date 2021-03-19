import 'package:ToFinish/components/small_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ToFinish/components/components.dart';
import '../blocs/blocs.dart';
import '../custom_colour_scheme.dart';
import '../functions.dart';

class TimersMatrixScreen extends StatefulWidget {
  @override
  _TimersMatrixScreenState createState() => _TimersMatrixScreenState();
}

class _TimersMatrixScreenState extends State<TimersMatrixScreen> {
  ScrollController _scrollController;
  bool completedTasksVisible = true;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is TasksLoadInProgress){
          BlocProvider.of<TodoBloc>(context).add(LoadTasks());
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is TasksLoadFailure){
          return Scaffold(
            body: Center(
              child: Text('Something went wrong'),
            ),
          );
        } else if (state is TasksLoadSuccess){
          int timeLeft = 0;
          for (int i = 0; i < state.tasks.length; i++){
            if (!state.tasks[i].isCompleted){
              timeLeft += state.tasks[i].time - state.tasks[i].timeElapsed;
            }
          }
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: SmallButton(icon: Icons.home),
                          onTap: () => BlocProvider.of<ScreensBloc>(context).add(HomeButtonPressed()),
                        ),
                        SizedBox(width: 15.0,),
                        GestureDetector(
                          child: SmallButton(icon: Icons.list),
                          onTap: () => BlocProvider.of<ScreensBloc>(context).add(ListButtonPressed()),
                        ),
                        SizedBox(width: 15.0,),
                        GestureDetector(
                          child: SmallButton(icon: completedTasksVisible ? Icons.visibility : Icons.visibility_off),
                          onTap: (){
                            setState(() {
                              completedTasksVisible = !completedTasksVisible;
                            });
                          },
                        )
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        children: [
                          Text("My Task", style: Theme.of(context).textTheme.headline1),
                          SizedBox(height: 20.0,),
                          Text(timeConverter(timeLeft) + ' left until finishing', style: Theme.of(context).textTheme.headline2,),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Flexible(
                      child: TasksMatrix(showCompleted: completedTasksVisible)
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                BlocProvider.of<ScreensBloc>(context).add(AddButtonPressed());
              }, 
              child: Icon(Icons.add, size: 30.0),
              backgroundColor: Theme.of(context).colorScheme.colour2,
            )
          );
        } else {
          return Container(width: 0.0, height: 0.0,);
        }
      }
    );
  }
}