import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ToFinish/components/components.dart';
import '../blocs/blocs.dart';
import '../custom_colour_scheme.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  ScrollController _scrollController;

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
          return Scaffold(
            appBar: AppBar(
              title: Text("To-Do", style: TextStyle(color: Colors.black),),
              backgroundColor: Colors.white,
              actions: [
                IconButton(
                  icon: Icon(Icons.grid_view, color: Colors.black,), 
                  onPressed: () => BlocProvider.of<ScreensBloc>(context).add(GridButtonPressed()),
                )
              ],
              elevation: 0.0,
            ),
            body: Container(
              padding: EdgeInsets.all(10.0),
              child: TasksList(controller: _scrollController, tasks: state.tasks, headerRequired: false,),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                BlocProvider.of<ScreensBloc>(context).add(AddButtonPressed());
              }, 
              child: Icon(Icons.add),
              backgroundColor: Theme.of(context).colorScheme.colour4,
            )
          );
        } else {
          return Container(width: 0.0, height: 0.0,);
        }
      }
    );
  }
}