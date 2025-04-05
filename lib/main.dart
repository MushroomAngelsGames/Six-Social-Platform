// @dart=2.9
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Const/ConstStyle.dart';
import 'General/AutenticacaoPage.dart';
import 'Init/App_Settigs.dart';
import 'Init/InitApp.dart';

void main() {
  initAppAndConfigure();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AppSettings()),
    ],
    child: MaterialApp(
        navigatorKey: navigatorKey,
        home: AutenticacaoPage(),
        theme: appTheme),
  ),);
}

