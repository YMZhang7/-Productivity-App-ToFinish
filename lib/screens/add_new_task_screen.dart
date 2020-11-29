import 'package:ToFinish/blocs/blocs.dart';
import 'package:ToFinish/models/Task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ToFinish/components/components.dart';
import '../custom_colour_scheme.dart';

class AddNewTaskScreen extends StatefulWidget{
  Task currentTask;
  AddNewTaskScreen({this.currentTask});
  @override
  _AddNewTaskScreenState createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  String description = "";
  int timeRequired = 0;
  bool isEmpty = false;
  TextEditingController _textEditingController = TextEditingController();
  String title = "New Task";
  String buttonLabel = "Add";

  @override
  void initState() {
    if (widget.currentTask != null){
      _textEditingController.text = widget.currentTask.description;
      title = "Edit Task";
      buttonLabel = "Update";
    }
    super.initState();
  }

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
                  Text(title, style: TextStyle(fontSize: 30.0),),
                  SizedBox(height: 30.0,),
                  Text('Description:', style: TextStyle(fontSize: 20.0)),
                  SizedBox(height: 10.0,),
                  TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      helperText: isEmpty ? 'This field cannot be empty' : '',
                    ),
                    onChanged: (value) {
                      if (_textEditingController.text.length != 0){
                        setState(() {
                          isEmpty = false;
                        });
                      } else {
                        setState(() {
                          isEmpty = true;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 30.0,),
                  Text('How long does it take?', style: TextStyle(fontSize: 20.0)),
                ],
              ),
              SizedBox(height: 30.0,),
              Text('Hour|Minute|Second', style: TextStyle(fontSize: 20.0),),
              SizedBox(height: 20.0,),
              // Time Picker
              TimePicker(onTimeSelectedChange: (value) => timeRequired = value, task: widget.currentTask,),
              
              // Container(
              //   child: new TimePickerSpinner(
              //     isShowSeconds: true,
              //     normalTextStyle: TextStyle(
              //       fontSize: 24,
              //       color: Colors.grey
              //     ),
              //     highlightedTextStyle: TextStyle(
              //       fontSize: 24,
              //       color: Colors.black
              //     ),
              //     spacing: 50,
              //     itemHeight: 50,
              //     isForce2Digits: true,
              //     onTimeChange: (time) {
              //       setState(() {
              //         timeRequired = time.hour * 3600 + time.minute * 60 + time.second;
              //       });
              //     },
              //   )
              // ),
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
                  child: Center(child: Text(buttonLabel, style: TextStyle(fontSize: 18.0),)),
                ),
                onTap: (){
                  if (_textEditingController.text.length == 0){
                    setState(() {
                      isEmpty = true;
                      // AlertDialog(title: Text('Description cannot be empty'),);
                      print('empty');
                      print(isEmpty);
                    });
                  } else {
                    description = _textEditingController.text;
                    DateTime dt = new DateTime.now();
                    String t = dt.year.toString() + " " + dt.month.toString() + " " + dt.day.toString();
                    if (widget.currentTask == null){
                      Task newTask = new Task(dateTime: t, description: description, time: timeRequired, timeElapsed: 0, isCompleted: false);
                      BlocProvider.of<TodoBloc>(context).add(AddTask(task: newTask));
                      BlocProvider.of<ScreensBloc>(context).add(BackButtonPressed());
                    } else {
                      widget.currentTask.description = description;
                      if (timeRequired > widget.currentTask.timeElapsed){
                        widget.currentTask.time = timeRequired;
                      } else {
                        // TODO: if the time set is less than time elapsed
                      }
                      BlocProvider.of<TodoBloc>(context).add(UpdateTask(task: widget.currentTask));
                      BlocProvider.of<ScreensBloc>(context).add(BackButtonPressed());
                      
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}