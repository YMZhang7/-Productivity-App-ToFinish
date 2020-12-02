import 'package:ToFinish/blocs/blocs.dart';
import 'package:ToFinish/components/time_picker.dart';
import 'package:ToFinish/models/Task.dart';
import 'package:ToFinish/screens/add_new_task_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../functions.dart' as utility;
import '../custom_colour_scheme.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class TimerScreen extends StatefulWidget {
  final Task task;
  const TimerScreen({@required this.task});

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid = AndroidInitializationSettings('flutter_devs');
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
    return TimerScreen(task: widget.task,);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios, color: Colors.black,), 
                          onPressed: (){
                            BlocProvider.of<ScreensBloc>(context).add(BackButtonPressed());
                          }
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                  // Task Description
                  Text(widget.task.description, style: TextStyle(fontSize: 20.0),),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                  // Task goal
                  Text('Goal: finish within ' + utility.timeConverter(widget.task.time)),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.07,),
                  // Timer
                  BlocBuilder<TimerBloc, TimerState>(
                    builder: (context, state) {
                      widget.task.timeElapsed = widget.task.time - state.duration;
                      BlocProvider.of<TodoBloc>(context).add(UpdateTask(task: widget.task));
                      return createTimer(context, state.duration, widget.task.time);
                    }
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                  // Buttons
                  SafeArea(
                    child: BlocBuilder<TimerBloc, TimerState>(
                      builder: (context, state){
                        if (state is TimerInitial){
                          return createButtonRow(context, 1);
                        } else if (state is TimerRunInProgress){
                          return createButtonRow(context, 2);
                        } else if (state is TimerRunPause){
                          return createButtonRow(context, 3);
                        } else if (state is TimerRunComplete){
                          print('vibrate');
                          showNotification();
                          // HapticFeedback.mediumImpact();
                          return createButtonRow(context, 4);
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
      
    );
  }

  showNotification() async {
    var android = AndroidNotificationDetails('id', 'channel ', 'description',
      priority: Priority.high, 
      importance: Importance.max
    );
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
      0, 'Flutter devs', 'Flutter Local Notification Demo', platform,
      payload: 'Welcome to the Local Notification demo'); 
  }

  Widget createButtonRow(BuildContext context, int state){
    int timeUpdated = widget.task.time;
    if (state == 1){
      // initial state
      String text = "start";
      if (widget.task.time > widget.task.timeElapsed){
        text = "continue";
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => BlocProvider.of<TimerBloc>(context).add(TimerStarted(duration: widget.task.time - widget.task.timeElapsed)),
            child: createButton(context, text)
          )
        ],
      );
    } else if (state == 2){
      // running
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => BlocProvider.of<TimerBloc>(context).add(TimerPaused()),
            child: createButton(context, 'pause')
          ),
        ],
      );
    } else if (state == 3){
      // paused
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () => BlocProvider.of<TimerBloc>(context).add(TimerResumed()),
            child: createButton(context, 'resume')
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context, 
                builder: (context){
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    // color: Colors.green,
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
                            RaisedButton(
                              child: Text('update'),
                              onPressed: (){
                                Navigator.of(context).pop();
                                if (widget.task.time != timeUpdated){
                                  setState(() {
                                    widget.task.time = timeUpdated;
                                  });
                                  BlocProvider.of<TodoBloc>(context).add(UpdateTask(task: widget.task));
                                }
                              }
                            )
                          ],
                        )
                      ],
                    ),
                  );
                }
              );
            },
            child: createButton(context, 'add time')
          ),
        ],
      );
    } else if (state == 4){
      // completed
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              widget.task.isCompleted = true;
              BlocProvider.of<TodoBloc>(context).add(UpdateTask(task: widget.task));
              BlocProvider.of<ScreensBloc>(context).add(BackButtonPressed());
            },
            child: createButton(context, 'complete')
          ),
          GestureDetector(
            onTap: () {
              showBottomSheet(
                context: context, 
                builder: (context){
                  return TimeEdittor();
                }
              );
            },
            child: createButton(context, 'add time')
          ),
        ],
      );
    } else {
      return Row();
    }
  }

  Widget createButton(BuildContext context, String text){
    return Container(
      width: 100.0,
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
    print(utility.timeConverter(92));
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
              value: (totalTime-time)/totalTime, // need to be changed
              backgroundColor: Theme.of(context).colorScheme.colour3,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          // time numbers
          Center(child: Text(utility.timeConverter(time), style: TextStyle(fontSize: 30.0),)),
        ]
      ),
    );
  }
}

class TimeEdittor extends StatefulWidget {
  @override
  _TimeEdittorState createState() => _TimeEdittorState();
}

class _TimeEdittorState extends State<TimeEdittor> {
  int timeAdded = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
        child: Column(
          children: [
            SizedBox(height: 30.0,),
            Text('Hour|Minute|Second', style: TextStyle(fontSize: 20.0),),
            SizedBox(height: 20.0,),
            Container(
              child: new TimePickerSpinner(
                // is24HourMode: false,
                isShowSeconds: true,
                normalTextStyle: TextStyle(
                  fontSize: 24,
                  color: Colors.grey
                ),
                highlightedTextStyle: TextStyle(
                  fontSize: 24,
                  color: Colors.black
                ),
                spacing: 50,
                itemHeight: 50,
                isForce2Digits: true,
                onTimeChange: (time) {
                  setState(() {
                    timeAdded = time.hour * 3600 + time.minute * 60 + time.second;
                  });
                },
              )
            ),
            SizedBox(height: 30.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('cancel'),
                ),
                RaisedButton(
                  onPressed: (){
                    // update time
                    print('time added: ' + timeAdded.toString());
                    Navigator.pop(context);
                  },
                  child: Text('update'),
                ),
              ],
            )
          ],
        ),
    );
  }
}