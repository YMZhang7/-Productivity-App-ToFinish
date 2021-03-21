import 'package:ToFinish/blocs/blocs.dart';
import 'package:ToFinish/components/timers_representation_body.dart';
import 'package:ToFinish/screens/add_new_task_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../custom_colour_scheme.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showList = false;
  bool showCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        // color: Colors.red,
        child: Column(
          children: [
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('My Timers', style: Theme.of(context).textTheme.headline1,)
                ]
              )
            ),
            Container(
              height: 30.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Label(text: 'Study',),
                  Label(text: 'Study',),
                  Label(text: 'Study',),
                  Label(text: 'Study',),
                  Label(text: 'Study',),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 20.0),
                // color: Colors.red,
                child: TimersRepresentationBody(showList: showList, showCompleted: showCompleted)
              ),
            ),
            Container(
              height: 80.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      color: Theme.of(context).colorScheme.colour2,
                    ),
                    child: IconButton(icon: Icon(Icons.add, size: 30.0, color: Colors.white,), onPressed: (){
                      print('Add new timer');
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (contextHomescreen){
                            return BlocProvider.value(
                              value: context.bloc<TodoBloc>(),
                              child: AddNewTaskScreen(),
                            );
                          }
                        )
                      );
                    }),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(showList ? Icons.grid_view : Icons.list, size: 30.0, ), 
                        onPressed: (){
                          setState(() {
                            showList = !showList;
                          });
                        }
                      ),
                      SizedBox(width: 20.0,),
                      IconButton(
                        icon: Icon(showCompleted ? 
                          Icons.visibility_off_rounded : 
                          Icons.visibility_rounded, 
                          size: 30.0, 
                        ), 
                        onPressed: (){
                          print('hide hidden items');
                          setState(() {
                            showCompleted = !showCompleted;
                          });
                      }),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Label extends StatelessWidget {
  final String text;
  const Label({@required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.0,
      height: 30.0,
      margin: EdgeInsets.only(right: 10.0),
      child: Center(child: Text(this.text)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
        color: Theme.of(context).colorScheme.colour3,
      ),
    );
  }
}