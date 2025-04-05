
import 'package:Six/DataBase/BDFirebase.dart';
import 'package:Six/Init/InitApp.dart';
import 'package:Six/Models/Statics.dart';
import 'package:Six/Objectos/Follower.dart';
import 'package:Six/Objectos/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../Const/ConstNames.dart';
import '../Services/AuthService.dart';

class FirebaseCreateUsers extends GetxController{

  late String _use = "";
  late FirebaseFirestore _db;

  var isSaveInFirebase = false.obs;
  var isLoadDocuments = false.obs;
  var isSaveFollowers = false.obs;

  static const String labelGlobalUsers = "Global_Users";
  static const String labelFirebaseUsers = "_User";

  static const String labelFollower ="_labelFollower";
  static const String labelFollowed ="_labelFollowed";
  static const String labelNameUserLogin ="_labelNameUserLogin";
  static const String labelApiUserLogin ="labelApiUserLogin";
  static const String labelNameUser ="_labelNameUser";
  static const String labelSortDescription ="_labelSortDescription";
  static const String labelLargeDescription ="_labelLargeDescription";
  static const String labelUrlImage ="_labelUrlImage";
  static const String labelTimeCreate ="_labelTimeCreate";

  late List<Map<String,DocumentSnapshot>> mapFilter =  <Map<String,DocumentSnapshot>>[];

  late Users myUser = Users.fromNull();
  FirebaseCreateUsers() {_getBd();}

  ///Inicializar Firebase.
  _getBd() async {
    final userLogin = AuthService.user?.uid;
    if (userLogin != null) {
      _use = userLogin;
    }
    _db = DBFirebase.fireStore;
    //setFindUsersInFireBase();
  }

  ///add new User
  Future<bool> setSaveNewUser(Users newUser) async {
    if(!isSaveInFirebase.value) {
      isSaveInFirebase.value = true;
      String apiId = _use;

      try {
        await _db.collection(_use).doc(labelFirebaseUsers).set({
          labelApiUserLogin:apiId,
          labelNameUserLogin: newUser.nameUserLogin,
          labelNameUser: newUser.nameUser,
          labelSortDescription: newUser.sortLegendUser,
          labelLargeDescription:  newUser.legendUser,
          labelUrlImage:  newUser.urlImage,
          labelTimeCreate:Timestamp.fromDate(DateTime.now()),
        }).timeout(const Duration(seconds: 60));

        await _db.collection(labelGlobalUsers).doc(apiId).set({
          labelApiUserLogin:apiId,
          labelNameUserLogin: newUser.nameUserLogin,
          labelNameUser: newUser.nameUser,
          labelSortDescription: newUser.sortLegendUser,
          labelLargeDescription:  newUser.legendUser,
          labelUrlImage:  newUser.urlImage,
          labelTimeCreate:Timestamp.fromDate(DateTime.now()),}
        ).timeout(const Duration(seconds: 60));

        isSaveInFirebase.value = false;

        return true;
      } catch (e, stackTrace) {
        forceErrorNoticeWithLegend(
            navigatorKey.currentContext!, labelErrorSaveFirebaseUser + e.toString());
        isSaveInFirebase.value = false;
        return false;
      }
    }
    return false;
  }

  Future<bool> setSaveUpdateUser(Users newUser) async {
    if(!isSaveInFirebase.value) {
      isSaveInFirebase.value = true;
      String apiId = _use;

      try {
        await _db.collection(_use).doc(labelFirebaseUsers).update({
          labelApiUserLogin:apiId,
          labelNameUserLogin: newUser.nameUserLogin,
          labelNameUser: newUser.nameUser,
          labelSortDescription: newUser.sortLegendUser,
          labelLargeDescription:  newUser.legendUser,
          labelUrlImage:  newUser.urlImage,
          labelTimeCreate:Timestamp.fromDate(DateTime.now()),
        }).timeout(const Duration(seconds: 60));

        await _db.collection(labelGlobalUsers).doc(apiId).update({
          labelApiUserLogin:apiId,
          labelNameUserLogin: newUser.nameUserLogin,
          labelNameUser: newUser.nameUser,
          labelSortDescription: newUser.sortLegendUser,
          labelLargeDescription:  newUser.legendUser,
          labelUrlImage:  newUser.urlImage,
          labelTimeCreate:Timestamp.fromDate(DateTime.now()),}
        ).timeout(const Duration(seconds: 60));

        isSaveInFirebase.value = false;

        return true;
      } catch (e, stackTrace) {
        forceErrorNoticeWithLegend(
            navigatorKey.currentContext!, labelErrorSaveFirebaseUser + e.toString());
        isSaveInFirebase.value = false;
        return false;
      }
    }
    return false;
  }

  Future<bool> setSaveNewFollowed(Users followed,Users follower) async{

    try{
      isSaveFollowers.value = true;
     followed.followed[follower.apiId] = Follower(follower.apiId, follower.nameUserLogin);
     follower.follower[followed.apiId] = Follower(followed.apiId, followed.nameUserLogin);

     await _db.collection(_use).doc(labelFirebaseUsers).update({
       labelFollowed: _generatorListFollowed(followed),
     }).timeout(const Duration(seconds: 60));

     await _db.collection(follower.apiId).doc(labelFirebaseUsers).update({
       labelFollower: _generatorListFollower(follower),
     }).timeout(const Duration(seconds: 60));

     await _db.collection(labelGlobalUsers).doc(_use).update({
       labelFollowed: _generatorListFollower(followed),
     }).timeout(const Duration(seconds: 60));

     await _db.collection(labelGlobalUsers).doc(follower.apiId).update({
       labelFollower: _generatorListFollower(follower),
     }).timeout(const Duration(seconds: 60));

     await setFindUsersInFireBase();
      DBFirebase.firebasePublicFile.setFindFirebasePublicFile();
      isSaveFollowers.value = false;
   }catch(e){
     return false;
   }

    return true;
  }

  Future<bool> setSavUnFollowed(Users followed,Users follower) async{

    try{
      isSaveFollowers.value = true;
      followed.followed.remove(follower.apiId);
      follower.follower.remove(followed.apiId);

      await _db.collection(_use).doc(labelFirebaseUsers).update({
        labelFollowed: _generatorListFollowed(followed),
      }).timeout(const Duration(seconds: 60));

      await _db.collection(follower.apiId).doc(labelFirebaseUsers).update({
        labelFollower: _generatorListFollower(follower),
      }).timeout(const Duration(seconds: 60));

      await _db.collection(labelGlobalUsers).doc(_use).update({
        labelFollowed: _generatorListFollower(followed),
      }).timeout(const Duration(seconds: 60));

      await _db.collection(labelGlobalUsers).doc(follower.apiId).update({
        labelFollower: _generatorListFollower(follower),
      }).timeout(const Duration(seconds: 60));

      await setFindUsersInFireBase();
       DBFirebase.firebasePublicFile.setFindFirebasePublicFile();
      isSaveFollowers.value = false;
    }catch(e){
      return false;
    }

    return true;
  }

  ///Buscar Venda no Servidor.
  setFindUsersInFireBase() async{
    if(isLoadDocuments.value){
      return;
    }

    mapFilter.clear();
    isLoadDocuments.value = true;

    if(await checkHasNetNotContext()){
      try {
        QuerySnapshot results = await _db.collection(labelGlobalUsers).get().timeout(const Duration(seconds: 60));

        for (var element in results.docs) {

          Map<String, DocumentSnapshot> temp = {};
          temp[element.get(labelApiUserLogin).toString()] = element;
          temp[element.get(labelNameUser).toString().toUpperCase()] = element;
          temp[element.get(labelNameUserLogin).toString().toUpperCase()] = element;
          mapFilter.add(temp);

        }}catch(e,stackTrace){
        isLoadDocuments.value = false;
        forceErrorNoticeWithLegend(navigatorKey.currentContext!, labelErrorFindDocumentsFirebaseDocuments);
      }}

    await initializeMyUser();
    isLoadDocuments.value = false;
    update();
  }

  Map<String,dynamic> _generatorListFollowed(Users usersNeedList){
    Map<String,dynamic> list = {};

    usersNeedList.followed.forEach((key, value) {
      list[value.nameUserLogin] = {
        labelApiUserLogin : value.apiId,
        labelNameUserLogin: value.nameUserLogin,
      };
    });

    return list;
  }

  Map<String,dynamic> _generatorListFollower(Users usersNeedList){
    Map<String,dynamic> list = {};

    usersNeedList.follower.forEach((key, value) {
      list[value.nameUserLogin] = {
        labelApiUserLogin : value.apiId,
        labelNameUserLogin: value.nameUserLogin,
      };
    });

    return list;
  }

  Map<String,Follower> _generatorFollow(Map<String,dynamic> map){

    Map<String,Follower> follows = {};

    map.forEach((key, value) {
      follows[value[labelApiUserLogin]] = Follower(value[labelApiUserLogin], value[labelNameUserLogin]);
    });

    return follows;
  }

  initializeMyUser() async{

    DocumentSnapshot results = await _db.collection(_use).doc(labelFirebaseUsers).get().timeout(const Duration(seconds: 60));
    Map<String,dynamic> map = results.data() as Map<String,dynamic>;

    myUser = Users(
      map.containsKey(labelApiUserLogin) ? map[labelApiUserLogin] : "",
      map.containsKey(labelNameUserLogin) ? map[labelNameUserLogin] : "",
      map.containsKey(labelNameUser) ? map[labelNameUser] : "",
      map.containsKey(labelUrlImage) ? map[labelUrlImage] : "",
      map.containsKey(labelLargeDescription) ? map[labelLargeDescription] : "",
      map.containsKey(labelSortDescription) ? map[labelSortDescription] : "",
      map.containsKey(labelFollower) ? _generatorFollow(map[labelFollower]) : {},
      map.containsKey(labelFollowed) ? _generatorFollow(map[labelFollowed]): {},
      thisReferenceFirebase: results,
    );


  }

  List<Users> getFilterUsersTextFilter(String filter) {
    List<Users> users = [];
    try {
      for (var element in mapFilter) {
        bool has = false;
        for (var element1 in element.keys) {
          if(!has) {
            if (element.keys.toString().contains(filter)) {
              Map<String,dynamic> map = element[element1]?.data() as Map<String,dynamic>;

              Users newUsers = Users(
                map.containsKey(labelApiUserLogin) ? map[labelApiUserLogin] : "",
                map.containsKey(labelNameUserLogin) ? map[labelNameUserLogin] : "",
                map.containsKey(labelNameUser) ? map[labelNameUser] : "",
                map.containsKey(labelUrlImage) ? map[labelUrlImage] : "",
                map.containsKey(labelLargeDescription) ? map[labelLargeDescription] : "",
                map.containsKey(labelSortDescription) ? map[labelSortDescription] : "",
                map.containsKey(labelFollower) ? _generatorFollow(map[labelFollower]) : {},
                map.containsKey(labelFollowed) ? _generatorFollow(map[labelFollowed]): {},
                thisReferenceFirebase: element[element.keys.first],
              );



              if(newUsers.apiId != myUser.apiId){
                users.add(newUsers);
              }

              has = true;
            }
          }
        }
      }

    } catch (e,stackTrace) {
      forceErrorNoticeWithLegend(navigatorKey.currentContext!, labelErrorGetListWithFilterFirebaseDocuments);
    }

    return users;
  }

  List<Users> getFilterUsers() {
    List<Users> users = [];

    try {
      for (var element in mapFilter) {

        Map<String,dynamic> map = element[element.keys.first]?.data() as Map<String,dynamic>;

        Users newUsers = Users(
          map.containsKey(labelApiUserLogin) ? map[labelApiUserLogin] : "",
          map.containsKey(labelNameUserLogin) ? map[labelNameUserLogin] : "",
          map.containsKey(labelNameUser) ? map[labelNameUser] : "",
          map.containsKey(labelUrlImage) ? map[labelUrlImage] : "",
          map.containsKey(labelLargeDescription) ? map[labelLargeDescription] : "",
          map.containsKey(labelSortDescription) ? map[labelSortDescription] : "",
          map.containsKey(labelFollower) ? _generatorFollow(map[labelFollower]) : {},
          map.containsKey(labelFollowed) ? _generatorFollow(map[labelFollowed]): {},
          thisReferenceFirebase: element[element.keys.first],
        );


        if(newUsers.apiId != myUser.apiId){
          users.add(newUsers);
        }

      }
    } catch (e,stackTrace) {
      forceErrorNoticeWithLegend(navigatorKey.currentContext!, labelErrorGetListWithFilterFirebaseDocuments);
    }

    return users;
  }
}