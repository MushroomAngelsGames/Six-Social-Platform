
import 'package:Six/Objectos/Follower.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'FilesPublics.dart';

class Users{

  String apiId ="";
  String urlImage ="";
  String nameUserLogin ="";
  String nameUser = "";
  String sortLegendUser ="";
  String legendUser ="";
  late DocumentSnapshot thisReferenceFirebase;

  Map<String,Follower> follower = {};
  Map<String,Follower> followed = {};



  Users(this.apiId,this.nameUserLogin,this.nameUser,this.urlImage,this.legendUser,this.sortLegendUser,this.follower,this.followed,{DocumentSnapshot? thisReferenceFirebase}){
    if(thisReferenceFirebase != null){
      this.thisReferenceFirebase = thisReferenceFirebase;
    }
  }



  Users.fromNull(){
    apiId ="";
    urlImage ="";
    nameUserLogin ="";
    nameUser ="";
    sortLegendUser ="";
    legendUser= "";
    follower = {};
    followed = {};
  }


}