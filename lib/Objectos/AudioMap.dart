import 'package:cloud_firestore/cloud_firestore.dart';

import 'Video.dart';

class AudioMap{

  String idUser;
  bool isPublic;

  String nameSave;
  String audioToText;
  String dateCreate;

  List<Video> movies = [];
  List<Video> links = [];

  late DocumentSnapshot thisReferenceFirebase;

  AudioMap(this.nameSave,this.audioToText,this.dateCreate,this.isPublic,this.idUser,this.movies,this.links,{DocumentSnapshot? thisReferenceFirebase}){
    if(thisReferenceFirebase != null){
      this.thisReferenceFirebase = thisReferenceFirebase;
    }
  }



  String getNameToSave(){
    return nameSave.replaceAll("/", "-").replaceAll(".", "-");
  }


}