import 'package:Six/General/App/BottomNavigation.dart';
import 'package:Six/Init/InitApp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Const/ConstNames.dart';
import '../General/App/ListWithTextSaveScreen.dart';
import '../Models/Statics.dart';

class AuthService extends GetxController {

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static late Rx<User?> _firebaseUser;
  static bool userIsAuthenticated = false;

  static bool errorLogin = false;

  @override
  void onInit() {
    super.onInit();
    restartValue();
    errorLogin = false;
  }

  ///Restaurar
  static restartValue(){
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.authStateChanges());
    checkLogin();
  }

  ///Verificar Login e Avisar se Ouver Error.
  static void checkLogin(){
    if (_firebaseUser != null) {
      userIsAuthenticated = true;
    } else {
      userIsAuthenticated = false;
    }
  }
   static User? get user => _firebaseUser.value;
   AuthService get to => Get.find<AuthService>();

   ///Avisar Error.
   showSnack(String title, String error) {
    Get.snackbar(
      title,
      error,
      backgroundColor: Colors.grey[900],
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  ///Logar
  static login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (defaultTargetPlatform == TargetPlatform.android) {
        restartValue();
        _executeLoginOrLogOut(navigatorKey.currentContext!, const BottomNavigation());
      }

      } catch (e) {
      errorLogin = true;
      forceErrorNoticeWithLegend(navigatorKey.currentContext!,labelErrorFirebaseCreateUser);
    }
  }

  ///Recuperar Login
  static Future<String> checkCodePasswordResetEmail(String code) async {
    try {
      return await _auth.verifyPasswordResetCode(code);
    } catch (e) {
      forceErrorNoticeWithLegend(navigatorKey.currentContext!,e.toString());
      return "";
    }
  }

  ///Recuperar Login
  static Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      forceErrorNoticeWithLegend(navigatorKey.currentContext!,e.toString());
      return false;
    }
    return false;
  }



  ///Create login
  static Future<bool> createNewUser(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if(credential.user != null){
        restartValue();
        return true;
      }

    } catch (e) {
      forceErrorNoticeWithLegend(navigatorKey.currentContext!,e.toString());
      return false;
    }
    return false;
  }


  ///Deslogar
  static void logout() async {
    try {
      await _auth.signOut();

     // _executeLoginOrLogOut(FirstScreen.contextBuilder,AutenticacaoPage());
      restartValue();
    } catch (e) {
     // setSnackBar(LabelNameErroLogOut,5,Icons.warning_amber_outlined);
    }
  }

  ///fechar Telas e Logar ou deslogar.
  static void _executeLoginOrLogOut(BuildContext context,Widget router){
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => router));
  }

}