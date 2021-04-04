import 'package:ToFinish/blocs/blocs.dart';
import 'package:ToFinish/components/tags_list.dart';
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
  String selectedTag = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
            TagsList(
              selected: selectedTag,
              changeSelected: (selected){
                setState(() {
                  selectedTag = selected;
                });
              },
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 20.0),
                // color: Colors.red,
                child: TimersRepresentationBody(showList: showList, showCompleted: showCompleted, tag: selectedTag,)
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
                          builder: (_){
                            // return BlocProvider.value(
                            //   value: context.bloc<TodoBloc>(),
                            //   child: BlocProvider.value(
                            //     value: context.bloc<TagsBloc>(),
                            //     child: AddNewTaskScreen(),
                            //   ),
                            // );
                            return AddNewTaskScreen(blocContext: context,);
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

