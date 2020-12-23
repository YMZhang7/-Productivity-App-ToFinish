import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/components.dart';
import 'package:ToFinish/blocs/blocs.dart';
import '../custom_colour_scheme.dart';

class TimersListScreen extends StatefulWidget {
  @override
  _TimersListScreenState createState() => _TimersListScreenState();
}

class _TimersListScreenState extends State<TimersListScreen> {
  bool completedTasksVisible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To-Do", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: completedTasksVisible ? Icon(Icons.visibility, color: Colors.black,) : Icon(Icons.visibility_off, color: Colors.black,),
            onPressed: (){
              setState(() {
                completedTasksVisible = !completedTasksVisible;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.list, color: Colors.black,), 
            onPressed: () {
              BlocProvider.of<ScreensBloc>(context).add(ListButtonPressed());
            }
          )
        ],
      ),
      body: Stack(
          children:[
            // timers
            BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                if (state is TasksLoadSuccess){
                  return Container(
                    color: Colors.white,
                    child: TasksMatrix(tasks: state.tasks, showCompleted: completedTasksVisible,),
                  );
                } else if (state is TasksLoadInProgress){
                  BlocProvider.of<TodoBloc>(context).add(LoadTasks());
                  return Center(child: CircularProgressIndicator(),);
                } else if (state is TasksLoadFailure){
                  return Center(child: Text('Something went wrong...'),);
                } else {
                  return Container(height: 0.0, width: 0.0,);
                }
              },
            ),
            // bottom sheet
            Container(
              child: DraggableScrollableSheet(
                initialChildSize: 0.2,
                minChildSize: 0.2,
                maxChildSize: 0.5,
                builder: (context, scrollController){
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: BlocBuilder<TodoBloc, TodoState>(
                      builder: (context, state) {
                        if (state is TasksLoadInProgress){
                          BlocProvider.of<TodoBloc>(context).add(LoadTasks());
                          return Center(child: CircularProgressIndicator(),);
                        } else if (state is TasksLoadSuccess){
                          return Padding(
                            padding: const EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
                            child: TasksList(controller: scrollController, tasks: state.tasks, headerRequired: true,showCompleted: true,),
                          );
                        } else if (state is TasksLoadFailure){
                          return Center(child: Text('Something went wrong...'),);
                        } else {
                          return Container(width: 0.0, height: 0.0,);
                        }
                      },
                    ),
                  );
                }
              ),
            ),
          ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          BlocProvider.of<ScreensBloc>(context).add(AddButtonPressed());
        }, 
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.colour4,
      ),
    );
  }
}