import 'package:ToFinish/components/big_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ToFinish/blocs/blocs.dart';
import 'package:ToFinish/functions.dart';
import 'package:ToFinish/models/Task.dart';
import 'package:ToFinish/components/components.dart';
import '../custom_colour_scheme.dart';

class AddNewTaskScreen extends StatefulWidget{
  final Task currentTask;
  const AddNewTaskScreen({this.currentTask});
  @override
  _AddNewTaskScreenState createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  String description = "";
  int timeRequired = 0;
  bool isEmpty = false;
  String title = "New Task";
  String buttonLabel = "CREATE";
  TextEditingController _textEditingController = TextEditingController();
  bool multipleTimers = false;
  List<Task> subtimers = [];

  @override
  void initState() {
    if (widget.currentTask != null){
      _textEditingController.text = widget.currentTask.description;
      title = "Edit Task";
      buttonLabel = "UPDATE";
      timeRequired = widget.currentTask.time;
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
    return WillPopScope(
      onWillPop: (){
        // back key pressed
        Navigator.pop(context);
        return null;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black), 
            onPressed: () => Navigator.pop(context),
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
                    Text(title, style: Theme.of(context).textTheme.headline1),
                    SizedBox(height: 30.0,),
                    Text('Description:', style: TextStyle(fontSize: 20.0)),
                    SizedBox(height: 10.0,),
                    TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        helperText: isEmpty ? 'This field cannot be empty' : '',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear_rounded), 
                          onPressed: () => _textEditingController.clear(),
                        )
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Divide into multiple timers?', style: TextStyle(fontSize: 20.0)),
                        Checkbox(
                          value: multipleTimers, 
                          onChanged: (change){
                            setState(() {
                              multipleTimers = change;
                            });
                          }
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0,),
                    multipleTimers ? multiTimerWidget() : timeSpecificationWidget(),
                    // Text('How long does it take?', style: TextStyle(fontSize: 20.0)),

                  ],
                ),
                SizedBox(height: 30.0,),
                // Add Button
                GestureDetector(
                  child: BigButton(label: buttonLabel),
                  onTap: (){
                    if (_textEditingController.text.length == 0){
                      setState(() {
                        isEmpty = true;
                      });
                    } else {
                      description = _textEditingController.text;
                      DateTime dt = new DateTime.now();
                      String t = dt.year.toString() + " " + dt.month.toString() + " " + dt.day.toString();
                      if (widget.currentTask == null){
                        Task newTask = new Task(dateTime: t, description: description, time: timeRequired, timeElapsed: 0, isCompleted: false);
                        BlocProvider.of<TodoBloc>(context).add(AddTask(task: newTask));
                        Navigator.pop(context);
                      } else {
                        widget.currentTask.description = description;
                        if (timeRequired > widget.currentTask.timeElapsed){
                          widget.currentTask.time = timeRequired;
                          BlocProvider.of<TodoBloc>(context).add(UpdateTask(task: widget.currentTask));
                          Navigator.pop(context);
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context){
                              return AlertDialog(
                                title: Text('Warning'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: [
                                      Text('Your goal cannot be less than the time already elapsed (' + timeConverter(widget.currentTask.timeElapsed) + ')')
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
                            
                        }
                        
                      }
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget timeSpecificationWidget(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('How long does it take?', style: TextStyle(fontSize: 20.0)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(timeConverter(timeRequired), style: TextStyle(fontSize: 17.0),),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.colour2),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)))
              ),
              onPressed: (){
                showDialog(
                  context: context, 
                  builder: (BuildContext context){
                    int newTime = 0;
                    return AlertDialog(
                      title: Text('Time'),
                      content: Container(
                        height: 250.0,
                        child: Column(
                          children: [
                            Text('Hour | Minute | Second', style: TextStyle(fontSize: 18.0),),
                            TimePicker(
                              onTimeSelectedChange: (time){
                                newTime = time;
                              }),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: (){
                            Navigator.of(context).pop();
                          }, 
                          child: Text('Cancel')
                        ),
                        TextButton(
                          onPressed: (){
                            setState(() {
                              timeRequired = newTime;
                            });
                            Navigator.of(context).pop();
                          }, 
                          child: Text('OK')
                        ),
                      ],
                    );
                  }
                );
              }, 
              child: Text('Change')
            )
          ],
        ),
      ],
    );
  }

  Widget multiTimerWidget(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

}