import 'package:ToFinish/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../components/components.dart';
import 'package:flutter/material.dart';
import '../custom_colour_scheme.dart';

class TimersListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mona's Day", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: [
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
                    child: TasksMatrix(tasks: state.tasks),
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
                initialChildSize: 0.4,
                minChildSize: 0.2,
                maxChildSize: 0.5,
                builder: (context, scrollController){
                  return Container(
                    decoration: BoxDecoration(
                      // color: Theme.of(context).colorScheme.colour2,
                      color: Colors.transparent,
                      // borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
                    ),
                    child: BlocBuilder<TodoBloc, TodoState>(
                      builder: (context, state) {
                        if (state is TasksLoadInProgress){
                          BlocProvider.of<TodoBloc>(context).add(LoadTasks());
                          return Center(child: CircularProgressIndicator(),);
                        } else if (state is TasksLoadSuccess){
                          return Padding(
                            padding: const EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
                            child: TasksList(controller: scrollController, tasks: state.tasks),
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