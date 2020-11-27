import 'package:flutter/material.dart';

class AnimationListTile extends StatefulWidget {
  final AnimationController controller;
  final Widget child;
  final int index;
  final int total;
  const AnimationListTile({@required this.controller, @required this.child, @required this.index, @required this.total});
  @override
  _AnimationListTileState createState() => _AnimationListTileState();
}

class _AnimationListTileState extends State<AnimationListTile> with TickerProviderStateMixin{
  // AnimationController _animationController;
  Animation<Offset> _offsetAnimation;
  @override
  void initState() {
    // _animationController = AnimationController(
    //   duration: const Duration(seconds: 1),
    //   vsync: this,
    // );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent:widget.controller,
      curve: Interval(
        (widget.index-1) / widget.total, widget.index/widget.total,
        curve: Curves.easeOutCirc, 
      ),
    ));
    // _animationController.forward();
    super.initState();
  }
  // @override
  // void dispose() {
  //   _animationController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: widget.child,
    );
  }
}