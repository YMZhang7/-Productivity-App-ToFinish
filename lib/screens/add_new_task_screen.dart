import 'package:ToFinish/blocs/blocs.dart';
import 'package:ToFinish/models/Task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import '../custom_colour_scheme.dart';

class AddNewTaskScreen extends StatefulWidget {
  @override
  _AddNewTaskScreenState createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  String description = "";
  int timeRequired = 0;
  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose(){
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black), 
          onPressed: () => BlocProvider.of<ScreensBloc>(context).add(BackButtonPressed()),
        ),
        elevation: 0.0,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 35.0, right: 35.0, top: 20.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('New Task', style: TextStyle(fontSize: 30.0),),
                  SizedBox(height: 30.0,),
                  Text('Description:', style: TextStyle(fontSize: 20.0)),
                  SizedBox(height: 10.0,),
                  TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 30.0,),
                  Text('How long does it take?', style: TextStyle(fontSize: 20.0)),
                ],
              ),
              SizedBox(height: 30.0,),
              Text('Hour|Minute|Second', style: TextStyle(fontSize: 20.0),),
              SizedBox(height: 20.0,),
              // Time Picker
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
                      timeRequired = time.hour * 3600 + time.minute * 60 + time.second;
                    });
                  },
                )
              ),
              SizedBox(height: 30.0,),
              // Add Button
              GestureDetector(
                child: Container(
                  width: 100.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.colour3,
                    borderRadius: BorderRadius.all(Radius.circular(15.0))
                  ),
                  child: Center(child: Text('Add', style: TextStyle(fontSize: 18.0),)),
                ),
                onTap: (){
                  description = _textEditingController.text;
                  DateTime dt = new DateTime.now();
                  String t = dt.year.toString() + " " + dt.month.toString() + " " + dt.day.toString();
                  Task newTask = new Task(dateTime: t, description: description, time: timeRequired, timeElapsed: 0, isCompleted: false);
                  BlocProvider.of<TodoBloc>(context).add(AddTask(task: newTask));
                  BlocProvider.of<ScreensBloc>(context).add(BackButtonPressed());
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}