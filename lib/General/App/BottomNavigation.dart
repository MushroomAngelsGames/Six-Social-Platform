import 'package:Six/General/App/ListWithTextSaveScreen.dart';
import 'package:Six/General/App/SearchScreen.dart';
import 'package:Six/General/App/SettigsScreen.dart';
import 'package:Six/General/App/ViewStudyScreen.dart';
import 'package:flutter/material.dart';
import '../../Const/ConstNames.dart';
import '../../Const/ConstStyle.dart';
import '../../DataBase/BDFirebase.dart';
import '../../Models/NewAppBar.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {

  int _selectedIndex = 0;

  ///Bottom Select
  static const List<Widget> _widgetOptions = <Widget>[
    ListWithTextSaveScreen(),
    ViewStudyScreen(),
    SearchScreen(),
    SettingsScreen()
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DBFirebase.firebaseCreateUsers.setFindUsersInFireBase();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewAppbar().getAppBar(
          appName, textStyleTopMenu, false,context, positionTextCenter: true,isFistScreen: true),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: labelSearch,
            backgroundColor: Colors.black87,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            backgroundColor: Colors.black87,
            label: labelSubscribe,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            backgroundColor: Colors.black87,
            label: labelFiles,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            backgroundColor: Colors.black87,
            label: labelSettings,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: colorIconsMenu,
        onTap: _onItemTapped,
      ),);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
