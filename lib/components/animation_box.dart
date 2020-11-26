import 'package:flutter/material.dart';

class AnimationBox extends StatefulWidget {
  final AnimationController controller;
  final Widget child;
  final int index;
  final int total;
  const AnimationBox({@required this.controller, @required this.child, @required this.index, @required this.total});
  @override
  _AnimationBoxState createState() => _AnimationBoxState();
}

class _AnimationBoxState extends State<AnimationBox> with TickerProviderStateMixin{
  Animation<Offset> _offsetAnimation;
  @override
  void initState() {
    super.initState();
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 2.0), 
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: widget.controller,
      curve: Interval(
        (widget.index-1)/widget.total, widget.index/widget.total,
        curve: Curves.easeInOutCubic,
      ),
    ));
    // widget.controller.forward(); // start the animation
  } 
  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: widget.child
    );
  }
}