import 'package:Six/DataBase/BDFirebase.dart';
import 'package:Six/Init/InitApp.dart';
import 'package:Six/Models/Statics.dart';
import 'package:Six/Objectos/AudioMap.dart';
import 'package:Six/Objectos/Video.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../Const/ConstNames.dart';
import '../Services/AuthService.dart';

class FirebaseDocuments extends GetxController{

  late String _use = "";
  late FirebaseFirestore _db;

  var isSaveInFirebase = false.obs;
  var isLoadDocuments = false.obs;

  static const String labelFirebaseDocuments = "_Documents";
  static const String labelFirebaseDocumentsCollection = "_Documents_Private";
  static const String labelFirebaseDocumentsPublicCollection = "_Documents_Public";

  static const String labelMoviesNameDocument ="_labelMoviesNameDocument";
  static const String labelMoviesLinkDocument ="_labelMoviesLinkDocument";

  static const String labelLinksDocument ="_labelLinksDocument";
  static const String labelMoviesDocument ="_labelMoviesDocument";
  static const String labelIdUserOwnerDocument ="_labelIdUserOwner";
  static const String labelIsPublicDocument ="_labelIsPublicDocument";
  static const String labelTextDocument ="_TextDocument";
  static const String labelNameDocument ="_nameDocument";
  static const String labelNameDocumentDate ="_dateCreate";

  late List<Map<String,DocumentSnapshot>> mapFilter =  <Map<String,DocumentSnapshot>>[];

  FirebaseDocuments() {_getBd();}

  _getBd() async {
    final userLogin = AuthService.user?.uid;
    if (userLogin != null) {
      _use = userLogin;
    }
    _db = DBFirebase.fireStore;
    setFindDocumentsInFireBase();
  }

  Map<String, dynamic> _getMapSave(AudioMap newAudioMap){
    return{
      labelIdUserOwnerDocument: newAudioMap.idUser,
      labelIsPublicDocument: newAudioMap.isPublic,
      labelNameDocument: newAudioMap.nameSave,
      labelTextDocument: newAudioMap.audioToText,
      labelNameDocumentDate: Timestamp.fromDate(DateTime.now()),
      labelMoviesDocument:_generatorListMovies(newAudioMap),
      labelLinksDocument:_generatorListLink(newAudioMap),
    };
  }

  Map<String,dynamic> _generatorListMovies(AudioMap audioMap){
    Map<String,dynamic> list = {};

    for (var element in audioMap.movies) {
      list["${element.nameVideo}:${element.idOrLink}"] = {
        labelMoviesLinkDocument: element.idOrLink,
        labelMoviesNameDocument: element.nameVideo
      };
    }

    return list;
  }

  Map<String,dynamic> _generatorListLink(AudioMap audioMap){
    Map<String,dynamic> list = {};

    for (var element in audioMap.links) {
      list["${element.nameVideo}:${element.idOrLink}"] = {
        labelMoviesLinkDocument: element.idOrLink,
        labelMoviesNameDocument: element.nameVideo
      };
    }

    return list;
  }

  List<Video> getMoviesListFromMap(Map<String,dynamic> temp){
    List<Video> movies = [];
    temp.forEach((key, value) {
      movies.add(Video(value[labelMoviesNameDocument], value[labelMoviesLinkDocument]));
    });

    return movies;
  }

  Future<bool> setSaveNewDocument(AudioMap newAudioMap) async {
    if(!isSaveInFirebase.value) {
      isSaveInFirebase.value = true;
      try {
        await _db.collection(_use).doc(labelFirebaseDocuments).collection(labelFirebaseDocumentsCollection).doc(newAudioMap.getNameToSave()).set(
              _getMapSave(newAudioMap)).timeout(const Duration(seconds: 60));

        if(newAudioMap.isPublic){
          await _db.collection(_use).doc(labelFirebaseDocuments).collection(labelFirebaseDocumentsPublicCollection).doc(newAudioMap.getNameToSave()).set(
              _getMapSave(newAudioMap)).timeout(const Duration(seconds: 60));
        }

        isSaveInFirebase.value = false;

        return true;
      } catch (e, stackTrace) {
        forceErrorNoticeWithLegend(
            navigatorKey.currentContext!, labelErrorSaveFirebaseDocuments);
        isSaveInFirebase.value = false;
        return false;
      }
    }
    return false;
  }

  Future<bool> setEditeDocument(AudioMap newAudioMap) async {
    if(!isSaveInFirebase.value) {
      isSaveInFirebase.value = true;
      try {
        await _db.collection(_use).doc(labelFirebaseDocuments).collection(labelFirebaseDocumentsCollection).doc(newAudioMap.getNameToSave()).update(
            _getMapSave(newAudioMap)).timeout(const Duration(seconds: 60));

        if(newAudioMap.isPublic){
          await _db.collection(_use).doc(labelFirebaseDocuments).collection(labelFirebaseDocumentsPublicCollection).doc(newAudioMap.getNameToSave()).set(
              _getMapSave(newAudioMap)).timeout(const Duration(seconds: 60));
        }else{
          await _db.collection(_use).doc(labelFirebaseDocuments).collection(labelFirebaseDocumentsPublicCollection).
          doc(newAudioMap.getNameToSave()).delete().timeout(const Duration(seconds: 60));
        }

        isSaveInFirebase.value = false;

        return true;
      } catch (e) {
        forceErrorNoticeWithLegend(
            navigatorKey.currentContext!, labelErrorSaveFirebaseDocuments);
        isSaveInFirebase.value = false;
        return false;
      }
    }
    return false;
  }

  Future<bool> removeDocument(AudioMap newAudioMap) async{
    isSaveInFirebase.value = true;
    try{

      await _db.collection(_use).doc(labelFirebaseDocuments).collection(labelFirebaseDocumentsPublicCollection).
      doc(newAudioMap.getNameToSave()).delete().timeout(const Duration(seconds: 60));

      await newAudioMap.thisReferenceFirebase.reference.delete().timeout(const Duration(seconds: 60));

      isSaveInFirebase.value = false;
      return true;
    }catch(e){
      forceErrorNoticeWithLegend(navigatorKey.currentContext!, labelErrorRemoveFirebaseDocuments);
      isSaveInFirebase.value = false;
      return false;
    }
  }

  setFindDocumentsInFireBase() async{
    if(isLoadDocuments.value){
      return;
    }

    mapFilter.clear();
    isLoadDocuments.value = true;

    if(await checkHasNetNotContext()){
      try {
        QuerySnapshot results = await _db.collection(_use).doc(
            labelFirebaseDocuments).collection(labelFirebaseDocumentsCollection).get().timeout(const Duration(seconds: 60));

        for (var element in results.docs) {
          Map<String, DocumentSnapshot> temp = {};
          temp[element.get(labelNameDocument).toString().toUpperCase()] = element;
          temp[element.get(labelNameDocumentDate).toString().toUpperCase()] = element;
          mapFilter.add(temp);

        }}catch(e,stackTrace){
        isLoadDocuments.value = false;
        forceErrorNoticeWithLegend(navigatorKey.currentContext!, labelErrorFindDocumentsFirebaseDocuments);
      }}

    isLoadDocuments.value = false;
    update();
  }

  List<AudioMap> getFilterAudioMapTextFilter(String filter) {
     List<AudioMap> clients = [];

    try {
      for (var element in mapFilter) {
        bool has = false;
        for (var element1 in element.keys) {
          if(!has) {
            if (element.keys.toString().contains(filter)) {
              Map<String,dynamic> map = element[element1]?.data() as Map<String,dynamic>;
              AudioMap newClient = AudioMap(
                map.containsKey(labelNameDocument) ? map[labelNameDocument] : "",
                map.containsKey(labelTextDocument) ? map[labelTextDocument] : "",
                map.containsKey(labelNameDocumentDate) ? getDateTimeWithSeconds((map[labelNameDocumentDate] as Timestamp).toDate())  : "",
                map.containsKey(labelIsPublicDocument) ? map[labelIsPublicDocument] : false,
                map.containsKey(labelIdUserOwnerDocument) ? map[labelIdUserOwnerDocument] : "",
                getMoviesListFromMap(map.containsKey(labelMoviesDocument) ? map[labelMoviesDocument] : {}),
                getMoviesListFromMap(map.containsKey(labelLinksDocument) ? map[labelLinksDocument] : {}),
                thisReferenceFirebase: element[element.keys.first],
              );
              clients.add(newClient);
              has = true;
            }
          }
        }
      }

    } catch (e,stackTrace) {
      forceErrorNoticeWithLegend(navigatorKey.currentContext!, labelErrorGetListWithFilterFirebaseDocuments);
    }

    return clients;
  }

  List<AudioMap> getFilterAudioMap() {
     List<AudioMap> clients = [];

    try {
      for (var element in mapFilter) {

        Map<String,dynamic> map = element[element.keys.first]?.data() as Map<String,dynamic>;

        AudioMap newClient = AudioMap(
          map.containsKey(labelNameDocument) ? map[labelNameDocument] : "",
          map.containsKey(labelTextDocument) ? map[labelTextDocument] : "",
          map.containsKey(labelNameDocumentDate) ? getDateTimeWithSeconds((map[labelNameDocumentDate] as Timestamp).toDate()) : "",
          map.containsKey(labelIsPublicDocument) ? map[labelIsPublicDocument] : false,
          map.containsKey(labelIdUserOwnerDocument) ? map[labelIdUserOwnerDocument] : "",
          getMoviesListFromMap(map.containsKey(labelMoviesDocument) ? map[labelMoviesDocument] : {}),
          getMoviesListFromMap(map.containsKey(labelLinksDocument) ? map[labelLinksDocument] : {}),
          thisReferenceFirebase: element[element.keys.first],
        );

        clients.add(newClient);
      }
    } catch (e,stackTrace) {
      forceErrorNoticeWithLegend(navigatorKey.currentContext!, labelErrorGetListWithFilterFirebaseDocuments);
    }

    return clients;
  }
}