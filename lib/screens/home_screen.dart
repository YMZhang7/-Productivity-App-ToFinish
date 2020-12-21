import 'package:ToFinish/blocs/blocs.dart';
import 'package:ToFinish/components/components.dart';
import 'package:ToFinish/components/small_button.dart';
import 'package:ToFinish/components/tasks_list.dart';
import 'package:ToFinish/models/Task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../custom_colour_scheme.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    return Scaffold(
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state){
          if (state is TasksLoadSuccess){
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SmallButton(icon: Icons.list),
                        SizedBox(width: 15.0,),
                        SmallButton(icon: Icons.grid_view),
                      ],
                    ),
                    Text("My Tasks", style: TextStyle(fontSize: 50.0)),
                    Text(state.tasks.length.toString() + ' tasks in total, ? tasks left'),
                    SizedBox(height: 50.0,),
                    Container(
                      height: 300.0,
                      child: TasksList(controller: _scrollController, tasks: state.tasks, headerRequired: false)
                    ),
                    Text('?? : ?? : ?? left until finishing'),
                    SizedBox(
                      height: 50.0,
                    ),
                    Container(
                      height: 160.0,
                      // TODO: prevent the children from resizing in accordance with the parent's size
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: getTaskBoxes(state.tasks),
                      )
                    )
                  ],
                ),
              ),
            );
          } else if (state is TasksLoadInProgress){
            BlocProvider.of<TodoBloc>(context).add(LoadTasks());
            return Center(child: CircularProgressIndicator(),);
          } else if (state is TasksLoadFailure){
            return Center(child: Text('Something went wrong...'),);
          } else {
            return Container(height: 0.0, width: 0.0,);
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, size: 30.0),
        backgroundColor: Theme.of(context).colorScheme.colour2,
        onPressed: () => BlocProvider.of<ScreensBloc>(context).add(AddButtonPressed()),
      ),
    );
  }

  List<Widget> getTaskBoxes(List<Task> tasks){
    List<Widget> res = [];
    for (int i = 0; i < tasks.length; i++){
      res.add(TaskBox(task: tasks[i]));
      res.add(SizedBox(width: 15.0,));
    }
    return res;
  }
}