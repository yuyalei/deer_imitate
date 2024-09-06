import 'package:flutter/material.dart';
class MyCard extends  StatelessWidget{
  final Widget child;
  final Color? color;
  final Color? shadowColor;

  MyCard({required this.child, this.color, this.shadowColor});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = color?? Colors.white;
    final Color sColor = shadowColor ?? Colors.red;
    return DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(color: sColor,offset: const Offset(0.0, 2.0),blurRadius: 8)
          ]
        ),
      child: child,
    );
  }

}