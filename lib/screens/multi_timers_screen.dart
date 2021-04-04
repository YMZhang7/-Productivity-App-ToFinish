import 'package:ToFinish/blocs/blocs.dart';
import 'package:ToFinish/components/components.dart';
import 'package:ToFinish/models/Task.dart';
import 'package:ToFinish/models/Ticker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MultiTimersScreen extends StatelessWidget {
  final BuildContext blocContext;
  final Task task;
  const MultiTimersScreen({@required this.blocContext, @required this.task});

  @override
  Widget build(BuildContext context) {
    List<int> subtimerTimeElapsed = [];
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black), 
          onPressed: () {
            print('Total time elapsed: ' + subtimerTimeElapsed.toString());
            int totalTimeElapsed = subtimerTimeElapsed.fold(0, (previousValue, element) => previousValue + element);
            task.timeElapsed = totalTimeElapsed;
            BlocProvider.of<TodoBloc>(blocContext).add(UpdateTask(task: task));
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(task.description, style: TextStyle(fontSize: 30.0),),
            SizedBox(height: 50.0,),
            Expanded(
              child: BlocBuilder<SubtimersBloc, SubtimersState>(
                builder: (context, state){
                  if (state is SubtasksLoadInProcess){
                    print('load subtasks...');
                    BlocProvider.of<SubtimersBloc>(context).add(LoadSubtimers(id: task.id));
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is SubtasksLoadFailure){
                    return Center(
                      child: Text('Something went wrong'),
                    );
                  } else if (state is SubtasksLoadSuccess){
                    for (int i = 0; i < state.tasks.length; i++){
                      subtimerTimeElapsed.add(state.tasks[i].timeElapsed);
                    }
                    List<Widget> subtimerWidgets = [];
                    for (int i = 0; i < state.tasks.length; i++){
                      Task subtimer = state.tasks[i];
                      subtimerWidgets.add(
                        BlocProvider(
                          create: (context) => TimerBloc(ticker: Ticker(), task: subtimer),
                          child: SubTimerListTile(
                            blocContext: blocContext, 
                            task: subtimer, 
                            parentTask: task,
                            getTimeElapsed: (elapsed){
                              subtimerTimeElapsed[i] = elapsed;
                            },
                          )
                        ),
                      );
                    }
                    return ListView(
                      children: subtimerWidgets,
                    );
                  } else {
                    return Container(width: 0.0, height: 0.0,);
                  }
                }
              )
            )
          ],
        ),
      ),
    );
  }
}