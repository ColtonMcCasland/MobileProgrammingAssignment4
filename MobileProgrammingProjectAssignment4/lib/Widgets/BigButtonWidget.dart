import 'package:flutter/material.dart';


class BigButtonWidget extends StatelessWidget{

  final String text;
  final GestureTapCallback onPressed;

  BigButtonWidget({this.text ,this.onPressed});

  @override
    Widget build(BuildContext context) {
      return 
      Container
      (
        margin: EdgeInsets.only(top: 30),
        width: 300,
        child: 
        RawMaterialButton
        (
          padding: EdgeInsets.only(top: 25,bottom: 25),
          fillColor:Colors.lightGreenAccent,
          splashColor:Colors.white,
          child: Text(text),
          onPressed: onPressed,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
        ),
      );
    }
}