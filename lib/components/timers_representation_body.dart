import 'package:ToFinish/blocs/blocs.dart';
import 'package:ToFinish/components/tasks_list.dart';
import 'package:ToFinish/components/tasks_matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimersRepresentationBody extends StatelessWidget {
  final bool showList;
  final bool showCompleted;
  final String tag;
  const TimersRepresentationBody({@required this.showList, @required this.showCompleted, @required this.tag});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state){
        if (state is TasksLoadInProgress){
          BlocProvider.of<TodoBloc>(context).add(LoadTasks());
          print('Task load in progress');
          return CircularProgressIndicator();
        } else if (state is TasksLoadFailure){
          return Center(
            child: Text('Something went wrong'),
          );
        } else if (state is TasksLoadSuccess){
          if (showList){
            return TasksList(tasks: state.tasks, showCompleted: this.showCompleted, tag: tag);
          } else {
            return TasksMatrix(tasks: state.tasks, showCompleted: this.showCompleted, tag: tag);
          }
        } else {
          return Container(width: 0.0, height: 0.0,);
        }
      }
    );
  }
}