import 'package:flutter/material.dart';

class AnimationBox extends StatefulWidget {
  final Widget child;
  final int total;
  const AnimationBox({@required this.child, @required this.total});
  @override
  _AnimationBoxState createState() => _AnimationBoxState();
}

class _AnimationBoxState extends State<AnimationBox> with TickerProviderStateMixin{
  AnimationController _controller;
  
  Animation _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000)
    );
    _controller.forward();
    _animation = Tween(
      begin: 0.0, 
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCirc,
      )
    );
  } 

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child
    );
  }
}