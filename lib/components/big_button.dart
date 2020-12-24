import 'package:flutter/material.dart';
import '../custom_colour_scheme.dart';

class BigButton extends StatelessWidget {
  final String label;
  const BigButton({@required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.colour2,
        borderRadius: BorderRadius.all(Radius.circular(15.0))
      ),
      child: Center(child: Text(label, style: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold))),
    );
  }
}