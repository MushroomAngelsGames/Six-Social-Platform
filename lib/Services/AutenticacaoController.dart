import 'package:Six/Init/InitApp.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../Const/ConstNames.dart';
import '../Models/Statics.dart';
import 'AuthService.dart';

class AutenticacaoController extends GetxController {
  final email = TextEditingController();
  final keycode = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final playerSound = AudioCache();
  var title = 'Bem vindo!'.obs;
  var buttonFirst = 'ENTRAR'.obs;
  var isLogin = true.obs;
  var isLoading = false.obs;

  ///Inicializar Classe.
  @override
  onInit() {
    super.onInit();
    ever(isLogin, (visible) {
      title.value = visible != null ? 'Bem vindo' : 'Crie sua conta';
      buttonFirst.value = visible != null ? 'ENTRAR' : 'Registre-se';
      formKey.currentState?.reset();
    });
  }

  ///Efetuar Login.
  login() async {

    playerSound.play(nameClipBut,isNotification: true,volume: 0.5);
    isLoading.value = true;

    bool hasConnet = await _checkHasInternet();

    if(!hasConnet) {
      isLoading.value = false;
      return;
    }

    await AuthService.login(email.text, keycode.text);
    isLoading.value = false;
  }

  ///Verifciar Internete.
  Future<bool> _checkHasInternet() async{
    bool resultConnect = false;

    try{
       resultConnect = await InternetConnectionChecker().hasConnection;
      if(resultConnect) {
        return true;
      } else {
        _getErrorConnect(labelErrorNotNet);
      }
      
    }catch(e) {
      _getErrorConnect(e.toString());
    }
    return resultConnect;

  }

  ///Avisar Error.
  _getErrorConnect(String  e){
    forceErrorNoticeWithLegend(navigatorKey.currentContext!, labelDescriptionErrorLogin + e);
  }
}