import 'package:ToFinish/models/Task.dart';
import 'package:flutter/material.dart';


class TimePicker extends StatefulWidget {
  Task task;
  Function(int) onTimeSelectedChange;

  TimePicker({this.task, @required this.onTimeSelectedChange});
  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> with TickerProviderStateMixin{
  FixedExtentScrollController _hourController = FixedExtentScrollController();
  FixedExtentScrollController _minController = FixedExtentScrollController();
  FixedExtentScrollController _secController = FixedExtentScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.task != null){
        _hourController.animateToItem((widget.task.time / 3600).floor(), duration: Duration(milliseconds: 500), curve: Curves.bounceIn);
        _minController.animateToItem(((widget.task.time % 3600)/ 60).floor(), duration: Duration(milliseconds: 500), curve: Curves.bounceIn);
        _secController.animateToItem(((widget.task.time % 3600) % 60).floor(), duration: Duration(milliseconds: 500), curve: Curves.bounceIn);
      }
    });
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minController.dispose();
    _secController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      child: Stack(
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              height: 35.0,
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 50.0,
                  child: ListWheelScrollView(
                    physics: FixedExtentScrollPhysics(),
                    controller: _hourController,
                    children: getNumbers(30),
                    itemExtent: 25.0,
                    diameterRatio: 1.5,
                    useMagnifier: true,
                    magnification: 1.7,
                    onSelectedItemChanged: (value) {
                      widget.onTimeSelectedChange(value * 3600 + _minController.selectedItem * 60 + _secController.selectedItem);
                    },
                  ),
                ),
                Container(
                  width: 50.0,
                  child: ListWheelScrollView(
                    physics: FixedExtentScrollPhysics(),
                    controller: _minController,
                    children: getNumbers(59),
                    itemExtent: 25.0,
                    diameterRatio: 1.5,
                    useMagnifier: true,
                    magnification: 1.7,
                    onSelectedItemChanged: (value) {
                      widget.onTimeSelectedChange(value * 60 + _hourController.selectedItem * 3600 + _secController.selectedItem);
                    },
                  ),
                ),
                Container(
                  width: 50.0,
                  child: ListWheelScrollView(
                    physics: FixedExtentScrollPhysics(),
                    controller: _secController,
                    children: getNumbers(59),
                    itemExtent: 25.0,
                    diameterRatio: 1.5,
                    useMagnifier: true,
                    magnification: 1.7,
                    onSelectedItemChanged: (value) {
                      widget.onTimeSelectedChange(value + _hourController.selectedItem * 3600 + _minController.selectedItem * 60);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget timeScroller(int number){
    return Container(
      // height: 300.0,
      width: 50.0,
      child: ListWheelScrollView(
        children: getNumbers(number),
        itemExtent: 25.0,
        diameterRatio: 1.5,
        useMagnifier: true,
        magnification: 1.7,
      ),
    );
  }

  List<Widget> getNumbers(int max){
    List<Widget> result = [];
    for (int i = 0; i <= max; i++){
      result.add(Text(i.toString(), style: TextStyle(fontSize: 20.0),));
    }
    return result;
  }
}