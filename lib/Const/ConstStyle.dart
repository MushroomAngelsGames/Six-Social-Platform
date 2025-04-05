import 'package:flutter/material.dart';

ThemeData appTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.lightBlue[800],
    elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(
      fixedSize: MaterialStateProperty.all<Size>(const Size(350,55)),
      textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
        fontSize: 14,
      )),
      backgroundColor: MaterialStateProperty.all<Color>(Colors.black54),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      alignment: Alignment.center,
    ))
);

///COLORS
Color colorIconsMenu = Colors.amberAccent;

///TEXTS
TextStyle textStyleTopMenu = const TextStyle(
    fontSize: 20,
    leadingDistribution: TextLeadingDistribution.proportional);

TextStyle optionStyle = const TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

TextStyle textStyleInputs = const TextStyle(fontSize: 12);
TextStyle textStyleInputs2 = const TextStyle(fontSize: 12,color:  Color(0xFF00897B));
TextStyle textStyleValue= const TextStyle(fontSize: 14,color: Colors.amber, fontStyle: FontStyle.italic,fontWeight: FontWeight.bold);
TextStyle textStyleValueSale = const TextStyle( fontSize: 12,color: Colors.green, fontStyle: FontStyle.italic,fontWeight: FontWeight.bold);
TextStyle textStyleNameItem = const TextStyle( fontSize: 14,color: Colors.white, fontWeight: FontWeight.bold);
TextStyle textStyleRed= const TextStyle(fontSize: 16,color: Colors.red, fontWeight: FontWeight.bold);

///BUTTONS
ButtonStyle buttonStyleButMenu = ButtonStyle(
  backgroundColor: MaterialStateProperty.all<Color>(Colors.black38),
  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),

);

ButtonStyle buttonStyleButStop = ButtonStyle(
  backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade900),
  foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
);

ButtonStyle buttonStyleButResume = ButtonStyle(
  backgroundColor: MaterialStateProperty.all<Color>(Colors.green.shade900),
  foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
);

