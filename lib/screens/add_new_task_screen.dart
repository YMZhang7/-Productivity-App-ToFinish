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
  final BuildContext blocContext;
  const AddNewTaskScreen({this.currentTask, @required this.blocContext});
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
  TextEditingController _tagController = TextEditingController();
  bool multipleTimers = false;
  List<Task> subtimers = [];
  String oldTag = '';

  @override
  void initState() {
    if (widget.currentTask != null){
      _textEditingController.text = widget.currentTask.description;
      title = "Edit Task";
      buttonLabel = "UPDATE";
      timeRequired = widget.currentTask.time;
      oldTag = widget.currentTask.tag;
    }
    super.initState();
  }

  @override
  void dispose(){
    _textEditingController.dispose();
    _tagController.dispose();
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
                      children: [
                        Text('Tag: ', style: TextStyle(fontSize: 20.0),),
                        SizedBox(width: 30.0,),
                        Container(
                          width: 150.0,
                          height: 50.0,
                          child: TextField(
                            controller: _tagController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.clear_rounded), 
                                onPressed: () => _textEditingController.clear(),
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
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
                    multipleTimers ? MultiTimerWidget(addNewTask: (task){
                      subtimers.add(task);
                      timeRequired += task.time;
                    },) : timeSpecificationWidget(),

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
                        Task newTask = new Task(dateTime: t, description: description, tag: _tagController.text, time: timeRequired, timeElapsed: 0, isCompleted: false, hasSubTimers: multipleTimers);
                        BlocProvider.of<TodoBloc>(widget.blocContext).add(AddTask(task: newTask, subtasks: subtimers));
                        BlocProvider.of<TagsBloc>(widget.blocContext).add(AddTag(tag: _tagController.text));
                        Navigator.pop(context);
                      } else {
                        widget.currentTask.description = description;
                        if (timeRequired > widget.currentTask.timeElapsed){
                          widget.currentTask.time = timeRequired;
                          if (_tagController.text != oldTag){
                            widget.currentTask.tag = _tagController.text;
                            BlocProvider.of<TagsBloc>(context).add(DeleteTag(tag: oldTag));
                            BlocProvider.of<TagsBloc>(context).add(AddTag(tag: _tagController.text));
                          } 
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

  // Widget multiTimerWidget(){
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Container(
  //         color: Colors.red,
  //         height: 20.0,
  //       )
  //     ],
  //   );
  // }

}

class MultiTimerWidget extends StatefulWidget {
  final Function(Task) addNewTask;
  const MultiTimerWidget({@required this.addNewTask});

  @override
  _MultiTimerWidgetState createState() => _MultiTimerWidgetState();
}

class _MultiTimerWidgetState extends State<MultiTimerWidget> {
  List<Task> subTasks = [];
  TextEditingController _textEditingController = TextEditingController();
  int timeSpecified = 0;
  
  @override
  void dispose() {
    this._textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      child: Column(
        children: [
          subTasks.length > 0 ? Expanded(
            child: ListView.builder(
              itemCount: subTasks.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(subTasks[index].description + index.toString()),
                  background: Container(
                    padding: EdgeInsets.all(20.0),
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.delete)
                      ],
                    ),
                  ),
                  child: Container(
                    height: 70.0,
                    padding: EdgeInsets.all(20.0),
                    margin: EdgeInsets.only(bottom: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: Theme.of(context).colorScheme.colour1,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.5),
                          blurRadius: 10.0,
                          spreadRadius: 0.0,
                          offset: Offset(
                            5.0, // Move to right 10  horizontally
                            5.0, // Move to bottom 10 Vertically
                          ),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(subTasks[index].description, style: TextStyle(fontSize: 18.0),),
                        Text(timeConverter(subTasks[index].time), style: TextStyle(fontSize: 18.0),),
                      ],
                    ),
                  ),
                  onDismissed: (direction) {
                    print('delete subtimer');
                    setState(() {
                      subTasks.removeAt(index);
                    });
                    for (Task sub in subTasks){
                      print(sub.description);
                    }
                  },
                );
              },
            ),
          ) : Container(
            child: Center(
              child: Text('No sub-timer added yet.'),
            ),
          ),
          TextButton(
            onPressed: (){
              print('add new task');
              showDialog(
                context: context, 
                builder: (BuildContext context){
                  return Container(
                    height: 100.0,
                    child: AlertDialog(
                      title: Text('New sub-timer'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: [
                            Text('Description'),
                            TextField(
                              controller: _textEditingController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                helperText: '* Required',
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.clear_rounded), 
                                  onPressed: () => _textEditingController.clear(),
                                )
                              ),
                            ),
                            Text('How long does it take?'),
                            TimePicker(onTimeSelectedChange: (time){
                              timeSpecified = time;
                            }),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(onPressed: (){
                          timeSpecified = 0;
                          Navigator.of(context).pop();
                        }, child: Text('Cancel')),
                        TextButton(
                          onPressed: (){
                            if (_textEditingController.text.length != 0){
                              DateTime dt = new DateTime.now();
                              String t = dt.year.toString() + " " + dt.month.toString() + " " + dt.day.toString();
                              Task newTask = new Task(dateTime: t, description: _textEditingController.text, tag: '', time: timeSpecified, timeElapsed: 0, isCompleted: false, hasSubTimers: false);
                              setState(() {
                                subTasks.add(newTask);
                              });
                              widget.addNewTask(newTask);
                              timeSpecified = 0;
                              _textEditingController.clear();
                              Navigator.of(context).pop();
                            }
                          }, 
                          child: Text('OK')
                        ),
                      ],
                    ),
                  );
                }
              );
            }, 
            child: Text('Add')
          )
        ],
      ),
    );
  }
}