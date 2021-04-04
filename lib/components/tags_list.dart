import 'package:ToFinish/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../custom_colour_scheme.dart';

class TagsList extends StatefulWidget {
  final String selected;
  final Function(String) changeSelected;
  const TagsList({@required this.selected, @required this.changeSelected});
  @override
  _TagsListState createState() => _TagsListState();
}

class _TagsListState extends State<TagsList> {
  @override
  void initState() {
    BlocProvider.of<TagsBloc>(context).add(LoadTags());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print('Creating TagsList');
    return BlocBuilder<TagsBloc, TagsState>(
      builder: (context, state){
        if (state is TagsLoadInProgress){
          print('Loading tags...');
          // BlocProvider.of<TagsBloc>(context).add(LoadTags());
          return CircularProgressIndicator();
        } else if (state is TagsLoadFailure){
          return Container(
            height: 30.0,
            child: Center(
              child: Text('Tags loading failed'),
            ),
          );
        } else if (state is TagsLoadSuccess){
          print('Tags load success');
          return Container(
            height: 30.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: getTagLabels(state.tags)
            ),
          );
        } else {
          print('Nothing got');
          return Container(width: 0.0, height: 0.0,);
        }
      },
    );
  }

  List<Widget> getTagLabels(List<String> tags){
    print(' In getTagLabels');
    print(tags);
    List<Widget> res = [];
    res.add(
      GestureDetector(
        onTap: () => widget.changeSelected('all'),
        child: Label(text: 'all', selected: widget.selected == 'all',),
      )
    );
    if (tags.length > 0){
      for (String tag in tags){
        res.add(
          GestureDetector(
            onTap: () => widget.changeSelected(tag),
            child: Label(text: tag, selected: widget.selected == tag,),
          )
        );
      }
    }
    print('tags: ' + tags.length.toString());
    return res;
  }
}

class Label extends StatelessWidget {
  final String text;
  final bool selected;
  const Label({@required this.text, @required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.0,
      height: 30.0,
      margin: EdgeInsets.only(right: 10.0),
      child: Center(
        child: Text(this.text, style: TextStyle(color: selected ? Colors.white : Colors.black),)
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
        color: selected ? Theme.of(context).colorScheme.colour2 : Theme.of(context).colorScheme.colour3,
      ),
    );
  }
}