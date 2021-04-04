import 'package:ToFinish/components/small_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:ToFinish/blocs/blocs.dart';
import 'package:ToFinish/components/time_picker.dart';
import 'package:ToFinish/models/Task.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../custom_colour_scheme.dart';
import '../functions.dart';

class TimersScreen extends StatefulWidget {
  final BuildContext todoBlocContext;
  final Task task;
  const TimersScreen({@required this.todoBlocContext, @required this.task});

  @override
  _TimersScreenState createState() => _TimersScreenState();
}

class _TimersScreenState extends State<TimersScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSettings = InitializationSettings(
      android: initializationSettingsAndroid, 
      iOS: initializationSettingsIOs
    );
    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onSelectNotification: onSelectNotification
    );
  }

  Future onSelectNotification(String payload) async{
    return TimersScreen(task: widget.task, todoBlocContext: widget.todoBlocContext,);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context);
        return null;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black), 
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<TimerBloc, TimerState>(
          builder: (context, state){
            if (widget.task.timeElapsed == widget.task.time){
              BlocProvider.of<TimerBloc>(context).add(CompleteTimer());
            }
            return Center(
              child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    // Return button
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                    // Task Description
                    Text(widget.task.description, style: TextStyle(fontSize: 20.0),),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                    // Task goal
                    Text('Goal: finish within ' + timeConverter(widget.task.time)),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.07,),
                    // Timer
                    BlocBuilder<TimerBloc, TimerState>(
                      builder: (context, state) {
                        widget.task.timeElapsed = widget.task.time - state.duration;
                        BlocProvider.of<TodoBloc>(widget.todoBlocContext).add(UpdateTask(task: widget.task));
                        return createTimer(context, state.duration, widget.task.time);
                      }
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                    // Buttons
                    SafeArea(
                      child: BlocBuilder<TimerBloc, TimerState>(
                        builder: (context, state){
                          if (state is TimerInitial){
                            return Container(
                              child: createButtonRow(context, 1, state),
                              width: MediaQuery.of(context).size.width * 0.7,
                            );
                          } else if (state is TimerRunInProgress){
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: createButtonRow(context, 2, state));
                          } else if (state is TimerRunPause){
                            return Container(
                              child: createButtonRow(context, 3, state),
                              width: MediaQuery.of(context).size.width * 0.7,
                            );
                          } else if (state is TimerRunComplete){
                            if (!widget.task.isCompleted){
                              _showNotification();
                              widget.task.isCompleted = true;
                              BlocProvider.of<TodoBloc>(widget.todoBlocContext).add(UpdateTask(task: widget.task));
                            }
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: createButtonRow(context, 4, state));
                          } else {
                            return Row();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        ),
        
      ),
    );
  }

  Future<void> _showNotification() async {
    var android = AndroidNotificationDetails('id', 'channel ', 'description',
      priority: Priority.high, 
      importance: Importance.max
    );
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
      0, 'Timer Completed', widget.task.description, platform,
      payload: 'Welcome to the Local Notification demo'); 
  }

  Widget createButtonRow(BuildContext context, int state, TimerState timerState){
    if (state == 1){
      // initial state
      String text = "START";
      if (widget.task.timeElapsed != 0){
        text = "CONTINUE";
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => BlocProvider.of<TimerBloc>(context).add(TimerStarted(duration: widget.task.time - widget.task.timeElapsed)),
            child: SmallButton(icon: Icons.play_arrow),
          )
        ],
      );
    } else if (state == 2){
      // running
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () => BlocProvider.of<TimerBloc>(context).add(TimerPaused()),
            child: SmallButton(icon: Icons.pause,),
          ),
          SizedBox(height: 20.0,),
          GestureDetector(
            onTap: () => BlocProvider.of<TimerBloc>(context).add(TimerReset()),
            child: SmallButton(icon: Icons.replay,),
          ),
        ],
      );
    } else if (state == 3){
      // paused
      return Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => BlocProvider.of<TimerBloc>(context).add(TimerResumed()),
              child: SmallButton(icon: Icons.play_arrow,),
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context, 
                  builder: (context){
                    return createBottomTimeEdittor(timerState);
                  }
                );
              },
              child: SmallButton(icon: Icons.add,),
            ),
            GestureDetector(
              onTap: () => BlocProvider.of<TimerBloc>(context).add(TimerReset()),
              child: SmallButton(icon: Icons.replay,),
            ),
          ],
        ),
      );
    } else if (state == 4){
      // completed
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: SmallButton(icon: Icons.check,),
          ),
          GestureDetector(
            onTap: () {
              showBottomSheet(
                context: context, 
                builder: (context){
                  return createBottomTimeEdittor(timerState);
                }
              );
            },
            child: SmallButton(icon: Icons.add,),
          ),
        ],
      );
    } else {
      return Row();
    }
  }

  Widget createBottomTimeEdittor(TimerState state){
    int timeUpdated = widget.task.time;
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        children: [
          SizedBox(height: 20.0,),
          Text('Hour|Minute|Second', style: TextStyle(fontSize: 20.0),),
          SizedBox(height: 10.0,),
          TimePicker(
            task: widget.task,
            onTimeSelectedChange: (value){
              timeUpdated = value;
            },
          ),
          SizedBox(height: 20.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text('update'),
                onPressed: (){
                  if (widget.task.time != timeUpdated){
                    if (timeUpdated < widget.task.timeElapsed){
                      print('hhhh');
                      showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: Text('Warning'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: [
                                  Text('Your goal cannot be less than the time elapsed (' + timeConverter(widget.task.timeElapsed) + ')')
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: Text('Okay'), 
                                onPressed: () => Navigator.of(context).pop()
                              )
                            ],
                          );
                        }
                      );
                    } else {
                      Navigator.of(context).pop();
                      setState(() {
                        widget.task.time = timeUpdated;
                        if (widget.task.time > widget.task.timeElapsed){
                          widget.task.isCompleted = false;
                        } else {
                          widget.task.isCompleted = true;
                        }
                      });
                      BlocProvider.of<TodoBloc>(widget.todoBlocContext).add(UpdateTask(task: widget.task));
                      BlocProvider.of<TimerBloc>(context).add(TimerReset(task: widget.task));
                    } 
                  }
                }
              )
            ],
          )
        ],
      ),
    );
  }

  Widget createButton(BuildContext context, String text){
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      height: 50.0,
      // color: Colors.yellow,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.colour3,
        borderRadius: BorderRadius.all(Radius.circular(15.0))
      ),
      child: Center(child: Text(text, style: TextStyle(fontSize: 18.0),)),
    );
  }

  Widget createTimer(BuildContext context, int time, int totalTime){
    return Container(
      height: MediaQuery.of(context).size.width * 0.6,
      width: MediaQuery.of(context).size.width * 0.6,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.width * 0.8,
            width: MediaQuery.of(context).size.width * 0.8,
            child: CircularProgressIndicator(
              strokeWidth: 30.0,
              value: totalTime == 0 ? 0 : (totalTime-time)/totalTime, // need to be changed
              backgroundColor: Theme.of(context).colorScheme.colour3,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          // time numbers
          Center(child: Text(timeConverter(time), style: TextStyle(fontSize: 30.0),)),
        ]
      ),
    );
  }
}