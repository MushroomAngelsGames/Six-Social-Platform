import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:wakelock/wakelock.dart';
import '../DataBase/BDFirebase.dart';
import '../Services/AuthService.dart';

final navigatorKey = GlobalKey<NavigatorState>();
const apiKey ='AIzaSyC-Tf6J98FkOPoNarqOLnfslP_6DQerQZM';
const projectId = 'six-study';

///Inicializar Funçoes Basicas do App
initAppAndConfigure() async{
  try {

    WidgetsFlutterBinding.ensureInitialized();
    Wakelock.enable();

    await Firebase.initializeApp(options:
    const FirebaseOptions(
        apiKey: apiKey,
        authDomain: "six-study.firebaseapp.com",
        projectId: projectId,
        storageBucket: "six-study.appspot.com",
        messagingSenderId: "17074405591",
        appId: "1:17074405591:android:7b31f6508c2a7e1e79f092",
        measurementId: "G-JDQ9GNL0S1"
    ));

    DBFirebase();
    Get.lazyPut((){return AuthService();});

  }catch(e){}
}