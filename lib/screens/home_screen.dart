import 'package:ToFinish/blocs/blocs.dart';
import 'package:ToFinish/components/components.dart';
import 'package:ToFinish/components/small_button.dart';
import 'package:ToFinish/components/tasks_list.dart';
import 'package:ToFinish/functions.dart';
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
    return Scaffold(
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state){
          if (state is TasksLoadSuccess){
            int countUndone = 0;
            int timeLeft = 0;
            for (int i = 0; i < state.tasks.length; i++){
              if (!state.tasks[i].isCompleted){
                countUndone += 1;
                timeLeft += state.tasks[i].time - state.tasks[i].timeElapsed;
              }
            }
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: SmallButton(icon: Icons.list),
                          onTap: () => BlocProvider.of<ScreensBloc>(context).add(ListButtonPressed()),
                        ),
                        SizedBox(width: 15.0,),
                        GestureDetector(
                          child: SmallButton(icon: Icons.grid_view),
                          onTap: () => BlocProvider.of<ScreensBloc>(context).add(GridButtonPressed()),
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
                          Text(state.tasks.length.toString() + ' tasks in total, '+ countUndone.toString() + ' tasks left', style: Theme.of(context).textTheme.headline2),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Container(
                      height: 300.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            offset: Offset(2.0, 2.0),
                            blurRadius: 8.0
                          )
                        ]
                      ),
                      child: TasksList(controller: _scrollController, tasks: state.tasks, headerRequired: false, showCompleted: completedTasksVisible)
                    ),
                    SizedBox(height: 40.0,),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        children: [
                          Text(timeConverter(timeLeft) + ' left until finishing', style: Theme.of(context).textTheme.headline2,),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ),
                    // SizedBox(
                    //   height: 5.0,
                    // ),
                    Container(
                      height: 180.0,
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
      if (!completedTasksVisible && tasks[i].isCompleted){
        continue;
      } else {
        res.add(
          Center(child: TaskBox(task: tasks[i]))
        );
        res.add(SizedBox(width: 10.0,));
      }
    }
    return res;
  }
}