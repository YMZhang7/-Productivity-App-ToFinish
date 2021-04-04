import 'package:ToFinish/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubTimersList extends StatefulWidget {
  final int id;
  const SubTimersList({@required this.id});

  @override
  _SubTimersListState createState() => _SubTimersListState();
}

class _SubTimersListState extends State<SubTimersList> {
  @override
  void initState() {
    BlocProvider.of<TodoBloc>(context).add(GetSubTasks(id: widget.id));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      color: Colors.green,
      child: BlocBuilder<SubtimersBloc, SubtimersState>(
        builder: (context, state) {
          if (state is SubtasksLoadFailure){
            return Center(
              child: Text('Something went wrong.'),
            );
          } else if (state is SubtasksLoadInProcess){
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SubtasksLoadSuccess){
            print(state.tasks);
            return ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index){
                return ListTile(
                  title: Text(state.tasks[index].description),
                );
              }
            );
          } else {
            return Container(width: 0.0, height: 0.0,);
          }
        },
      )
    );
  }
}