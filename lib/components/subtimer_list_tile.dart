import 'package:ToFinish/blocs/blocs.dart';
import 'package:ToFinish/database/database.dart';
import 'package:ToFinish/functions.dart';
import 'package:ToFinish/models/Task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubTimerListTile extends StatefulWidget {
  final BuildContext blocContext;
  final Task task;
  final Task parentTask;
  final Function(int) getTimeElapsed;
  // final int tableId;
  const SubTimerListTile({@required this.blocContext, @required this.task, @required this.parentTask, @required this.getTimeElapsed});
  @override
  SubTimerListTileState createState() => SubTimerListTileState();
}

class SubTimerListTileState extends State<SubTimerListTile> {
  int timeLeft = 0; // last timeLeft updated
  int duration = 0;
  DBHelper dbHelper = DBHelper();
  // Update database when:
  // [*] pause button pressed
  // [*] replay button pressed
  // [*] timer completes
  // * back button pressed
  // [*] every 5 seconds
  @override
  void initState() {
    super.initState();
    timeLeft = widget.task.time - widget.task.timeElapsed;
    duration = timeLeft;
    print('Initial timeLeft: ' + timeLeft.toString());
  }
  @override
  void dispose() {
    print('subtimer disposed');
    // update subtimer
    widget.task.timeElapsed = widget.task.time - duration;
    // BlocProvider.of<SubtimersBloc>(context).add(UpdateSubtimer(tableId: widget.parentTask.id, task: widget.task));
    dbHelper.updateSubtimer(widget.parentTask.id, widget.task);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
          padding: EdgeInsets.all(20.0),
          margin: EdgeInsets.only(bottom: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.5),
                blurRadius: 10.0,
                spreadRadius: 0.0,
                offset: Offset(
                  5.0,
                  5.0,
                ),
              )
            ]
          ),
          height: 80.0,
          child: BlocBuilder<TimerBloc, TimerState>(
            builder: (context, state){
              if (state is TimerRunInProgress){
                duration = state.duration;
                widget.getTimeElapsed(widget.task.time - state.duration);
                print('Duration: ' + state.duration.toString());
                if (timeLeft - state.duration == 5){
                  // update database every 5 seconds
                  updateDatabase(state.duration);
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 100.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: Icon(Icons.pause), 
                                onPressed: (){
                                  updateDatabase(state.duration);
                                  BlocProvider.of<TimerBloc>(context).add(TimerPaused());
                                }
                              ),
                            ],
                          ),
                        ),
                        Text(widget.task.description),
                      ],
                    ),
                    Text(timeConverter(state.duration))
                  ],
                );
              } else if (state is TimerRunComplete){
                duration = 0;
                widget.getTimeElapsed(widget.task.time);
                if (!widget.task.isCompleted){
                  widget.task.isCompleted = true;
                  // BlocProvider.of<SubtimersBloc>(context).add(UpdateSubtimer(tableId: widget.parentTask.id, task: widget.task));
                  updateDatabase(0);
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.replay), 
                          onPressed: (){
                            // TODO: update todobloc to reset timer
                            duration = widget.task.time;
                            updateDatabase(widget.task.time);
                            widget.getTimeElapsed(0);
                            BlocProvider.of<TimerBloc>(context).add(TimerReset());
                          }
                        ),
                        Text(widget.task.description),
                      ],
                    ),
                    Text(timeConverter(widget.task.time - widget.task.timeElapsed))
                  ],
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 100.0,
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.play_arrow), 
                                onPressed: (){
                                  BlocProvider.of<TimerBloc>(context).add(TimerStarted(duration: widget.task.time - widget.task.timeElapsed));
                                }
                              ),
                              IconButton(
                                icon: Icon(Icons.replay), 
                                onPressed: (){
                                  // widget.task.timeElapsed = 0;
                                  duration = widget.task.time;
                                  updateDatabase(widget.task.time);
                                  widget.getTimeElapsed(0);
                                  BlocProvider.of<TimerBloc>(context).add(TimerReset(task: widget.task));
                                }
                              ),
                            ],
                          ),
                        ),
                        Text(widget.task.description),
                      ],
                    ),
                    Text(timeConverter(widget.task.time - widget.task.timeElapsed))
                  ],
                );
              }
            },
          )
    );
  }

  Future updateDatabase(int duration) async{
    widget.task.timeElapsed = widget.task.time - duration;
    
    // use dbhelper instead of bloc so that the state won't change
    await dbHelper.updateSubtimer(widget.parentTask.id, widget.task);
    timeLeft = duration;
  }
}