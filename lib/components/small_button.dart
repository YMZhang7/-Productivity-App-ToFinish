import 'package:flutter/material.dart';

import '../custom_colour_scheme.dart';

class SmallButton extends StatelessWidget {
  final IconData icon;
  const SmallButton({@required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45.0,
      height: 45.0,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.colour2,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.8),
            blurRadius: 8.0,
            spreadRadius: 0.0,
            offset: Offset(
              5.0, // Move to right 10  horizontally
              5.0, // Move to bottom 10 Vertically
            ),
          ),
        ],
      ),
      child: Icon(icon, size: 30.0, color: Colors.white),
    );
  }
}