import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier{

  late SharedPreferences _prefs;
  Map<String,String> configString = {
      'User' : '',
      'key': '',
  };

  AppSettings(){
    _startSettings();
  }

  _startSettings() async{
    try {
      await _startPreference();
      await _readLocate();
    }catch(e){}
  }

  Future<void> _startPreference() async{
    try {
      _prefs = await SharedPreferences.getInstance();
    }catch(e){}
  }

  //Ler da Memoria Senha e Email.
  _readLocate() async{
    try {
      configString = {
        'User': _prefs.getString('User') ?? '',
        'key': _prefs.getString('key') ?? '',
      };

      notifyListeners();
    }catch(e){}
  }

  //Salvar Email e Senha.
  setLocale(String user,String key) async{
    try {
      await _prefs.setString("User", user);
      await _prefs.setString('key', key);
      await _readLocate();
    }catch(e){}
  }


}