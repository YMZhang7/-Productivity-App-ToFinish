import 'package:flutter/material.dart';

class AnimationListTile extends StatefulWidget {
  final Widget child;
  final int index;
  final int total;
  const AnimationListTile({@required this.child, @required this.index, @required this.total});
  @override
  _AnimationListTileState createState() => _AnimationListTileState();
}

class _AnimationListTileState extends State<AnimationListTile> with TickerProviderStateMixin{
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  Animation<double> _opacityAnimation;
  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent:_controller,
      curve: Interval(
        (widget.index-1) / widget.total, widget.index/widget.total,
        curve: Curves.easeOutCirc, 
      ),
    ));
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent:_controller,
      curve: Interval(
        (widget.index-1) / widget.total, widget.index/widget.total,
        curve: Curves.easeOutCirc, 
      ),
    ));
    super.initState();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: widget.child
      ),
    );
  }
}