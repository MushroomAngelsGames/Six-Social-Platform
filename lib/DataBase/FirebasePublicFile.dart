
import 'package:Six/DataBase/BDFirebase.dart';
import 'package:Six/Init/InitApp.dart';
import 'package:Six/Models/Statics.dart';
import 'package:Six/Objectos/AudioMap.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../Const/ConstNames.dart';
import '../Objectos/FileAudioMap.dart';
import '../Objectos/Follower.dart';
import '../Objectos/User.dart';
import '../Services/AuthService.dart';

class FirebasePublicFile extends GetxController{

  late String _use = "";
  late FirebaseFirestore _db;

  var isSaveInFirebase = false.obs;
  var isLoadDocuments = false.obs;

  static const String labelFirebaseDocuments = "_Documents";
  static const String labelFirebaseDocumentsCollection = "_Documents_Private";
  static const String labelFirebaseDocumentsPublicCollection = "_Documents_Public";

  static const String labelLinksDocument ="_labelMoviesDocument";
  static const String labelMoviesDocument ="_labelMoviesDocument";
  static const String labelIdUserOwnerDocument ="_labelIdUserOwnerDocument";
  static const String labelIsPublicDocument ="_labelIsPublicDocument";
  static const String labelTextDocument ="_TextDocument";
  static const String labelNameDocument ="_nameDocument";
  static const String labelNameDocumentDate ="_dateCreate";

  late Map<String,List<Map<String,DocumentSnapshot>>> mapFilter =  {};

  FirebasePublicFile() {_getBd();}

  _getBd() async {
    final userLogin = AuthService.user?.uid;
    if (userLogin != null) {
      _use = userLogin;
    }
    _db = DBFirebase.fireStore;
    setFindFirebasePublicFile();
  }

  setFindFirebasePublicFile() async{
    if(isLoadDocuments.value){
      return;
    }

    mapFilter.clear();
    isLoadDocuments.value = true;

    if(await checkHasNetNotContext()){
      try {
        List<Follower> follower = [];

        DBFirebase.firebaseCreateUsers.myUser.followed.forEach((key, value) {
          follower.add(value);
        });

        await Future.wait(follower.map((e) async{
          QuerySnapshot results = await _db.collection(e.apiId).doc(
              labelFirebaseDocuments).collection(labelFirebaseDocumentsPublicCollection).get().timeout(const Duration(seconds: 60));

          List<Map<String,DocumentSnapshot>> listTemp = [];
          for (var element in results.docs) {
            Map<String, DocumentSnapshot> temp = {};
            temp[element.get(labelNameDocument).toString().toUpperCase()] = element;
            temp[element.get(labelNameDocumentDate).toString().toUpperCase()] = element;
            listTemp.add(temp);
          }

          mapFilter[e.apiId] = listTemp;

        }));

      }catch(e,stackTrace){
        isLoadDocuments.value = false;
        forceErrorNoticeWithLegend(navigatorKey.currentContext!, labelErrorFindDocumentsFirebaseDocuments);
      }}

    isLoadDocuments.value = false;
    update();
  }

  List<FileAudioMap> getFilterAudioMapTextFilter(String filter) {
    List<FileAudioMap> files = [];
      mapFilter.forEach((key1, element) {
        bool has = false;
        for (var element1 in element) {
          element1.forEach((key, value) {
            if(!has) {
              if (key.toString().contains(filter)) {
                Map<String,dynamic> map = value.data() as Map<String,dynamic>;
                AudioMap newClient = AudioMap(
                  map.containsKey(labelNameDocument) ? map[labelNameDocument] : "",
                  map.containsKey(labelTextDocument) ? map[labelTextDocument] : "",
                  map.containsKey(labelNameDocumentDate) ? getDateTimeWithSeconds((map[labelNameDocumentDate] as Timestamp).toDate())  : "",
                  map.containsKey(labelIsPublicDocument) ? map[labelIsPublicDocument] : false,
                  map.containsKey(labelIdUserOwnerDocument) ? map[labelIdUserOwnerDocument] : "",
                  DBFirebase.firebaseDocuments.getMoviesListFromMap(map.containsKey(labelMoviesDocument) ? map[labelMoviesDocument] : {}),
                  DBFirebase.firebaseDocuments.getMoviesListFromMap(map.containsKey(labelLinksDocument) ? map[labelLinksDocument] : {}),
                  thisReferenceFirebase: value,
                );
                List<Users> user = DBFirebase.firebaseCreateUsers.getFilterUsersTextFilter(key1);

                if(user.isNotEmpty) {
                  files.add(FileAudioMap(user.first,newClient));
                }
                has = true;
              }
            }
          });
        }
      });
    try {
    } catch (e,stackTrace) {
      forceErrorNoticeWithLegend(navigatorKey.currentContext!, labelErrorGetListWithFilterFirebaseDocuments);
    }

    return files;
  }

  List<FileAudioMap> getFilterAudioMap() {
    List<FileAudioMap> files = [];

      mapFilter.forEach((key, value) {
        for (var element in value) {
          Map<String,dynamic> map = element[element.keys.first]?.data() as Map<String,dynamic>;

          AudioMap newClient = AudioMap(
            map.containsKey(labelNameDocument) ? map[labelNameDocument] : "",
            map.containsKey(labelTextDocument) ? map[labelTextDocument] : "",
            map.containsKey(labelNameDocumentDate) ? getDateTimeWithSeconds((map[labelNameDocumentDate] as Timestamp).toDate()) : "",
            map.containsKey(labelIsPublicDocument) ? map[labelIsPublicDocument] : false,
            map.containsKey(labelIdUserOwnerDocument) ? map[labelIdUserOwnerDocument] : "",
            DBFirebase.firebaseDocuments.getMoviesListFromMap(map.containsKey(labelMoviesDocument) ? map[labelMoviesDocument] : {}),
            DBFirebase.firebaseDocuments.getMoviesListFromMap(map.containsKey(labelLinksDocument) ? map[labelLinksDocument] : {}),
            thisReferenceFirebase: element[element.keys.first],
          );
          List<Users> user = DBFirebase.firebaseCreateUsers.getFilterUsersTextFilter(key);

          if(user.isNotEmpty) {
            files.add(FileAudioMap(user.first,newClient));
          }

        }
      });

    try {
    } catch (e,stackTrace) {
      forceErrorNoticeWithLegend(navigatorKey.currentContext!, labelErrorGetListWithFilterFirebaseDocuments);
    }

    return files;
  }
}