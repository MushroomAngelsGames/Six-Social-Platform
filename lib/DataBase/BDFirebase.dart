import 'package:Six/DataBase/FirebaseCreateUsers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../Models/CreatePdf.dart';
import 'FirebaseDocuments.dart';
import 'FirebasePublicFile.dart';

class DBFirebase{
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static final FirebaseDocuments firebaseDocuments = Get.put(FirebaseDocuments());
  static final CreatePdf createPdf = Get.put(CreatePdf());
  static final FirebaseCreateUsers firebaseCreateUsers = Get.put(FirebaseCreateUsers());
  static final FirebasePublicFile firebasePublicFile  = Get.put(FirebasePublicFile());
}