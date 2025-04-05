import 'package:Six/DataBase/BDFirebase.dart';
import 'package:Six/Init/InitApp.dart';
import 'package:Six/Models/GetElevatedButton.dart';
import 'package:Six/Objectos/User.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Const/ConstNames.dart';
import '../../Const/ConstStyle.dart';
import '../../Models/Statics.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController nameUser = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController sortLegend = TextEditingController();
  final TextEditingController largeLegend = TextEditingController();
  final TextEditingController instImage = TextEditingController();

  @override
  void initState(){
    nameUser.text = DBFirebase.firebaseCreateUsers.myUser.nameUserLogin;
    name.text = DBFirebase.firebaseCreateUsers.myUser.nameUser;
    sortLegend.text = DBFirebase.firebaseCreateUsers.myUser.sortLegendUser;
    largeLegend.text = DBFirebase.firebaseCreateUsers.myUser.legendUser;
    instImage.text = DBFirebase.firebaseCreateUsers.myUser.urlImage;
    super.initState();
  }


  @override
  void dispose() {
    nameUser.dispose();
    name.dispose();
    sortLegend.dispose();
    largeLegend.dispose();
    instImage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _getBody();
  }

  ///Corpo Principal
  _getBody() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child:Obx(()=> (DBFirebase.firebaseCreateUsers.isLoadDocuments.value)?
      Padding(padding: const EdgeInsets.all(8.0),
          child: getModelDetails(labelWait, '', '', Icons.waving_hand, Colors.black54, 65,secondIcon:
          const CircularProgressIndicator(),forceSizeText: 10,titleAlign: Alignment.centerLeft,useBorder: true)) :
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            color: Colors.black38,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),
                  getModelDetails(labelNameSettingsScreen, "", "", Icons.file_open_rounded, Colors.black54, 65,forceSizeText: 10,titleAlign:Alignment.centerLeft ),
                  const SizedBox(height: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width:wightApp *0.497,
                          child: getModelDetails(labelFollowersSettingsScreen, "",DBFirebase.firebaseCreateUsers.myUser.follower.length.toString(), Icons.person_add, Colors.black54, 65,forceSizeText: 7)),
                      const SizedBox(width: 1),
                      SizedBox(
                          width:wightApp *0.497,
                          child: getModelDetails(labelFollowedSettingsScreen, "",DBFirebase.firebaseCreateUsers.myUser.followed.length.toString(), Icons.person_search_rounded, Colors.black54, 65,forceSizeText: 7)),
                    ],
                  ),
                  instImage.text.isNotEmpty ? const SizedBox(height: 10):const SizedBox(),
                  Visibility(
                    visible:  instImage.text.isNotEmpty,
                    child: CachedNetworkImage(
                      imageUrl:  instImage.text ,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error)  {
                        return  CircleAvatar(
                            backgroundColor: Colors.white,
                            radius : 125,
                            child: InkWell(
                              onTap:() => showImageItemFull(context, instImage.text ),
                              child: ClipOval(
                                  child: Image.asset(imageError)),
                            ));},
                      imageBuilder: (context, image) => CircleAvatar(
                        backgroundColor: Colors.white,
                        radius : 125,
                        child:  InkWell(
                          onTap:() => showImageItemFull(context, instImage.text ),
                          child: ClipOval(
                              child: Image(image: image)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: wightApp * 0.9,
                    height: 65,
                    child: TextFormField(
                      style: textStyleInputs,
                      controller: nameUser,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: labelHelpInputNameUserNewUser,
                      ),
                      keyboardType: TextInputType.name,
                      onChanged: (value){setState(() {

                      });},
                      enabled: false,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return labelErrorNameCreateNewUser;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: wightApp * 0.9,
                    height: 65,
                    child: TextFormField(
                      maxLines: null,
                      minLines: null,
                      expands: true,
                      style: textStyleInputs,
                      controller: name,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: labelHelpInputNameCompleteUserNewUser,
                      ),
                      keyboardType: TextInputType.name,
                      onChanged: (value){setState(() {

                      });},
                      validator: (value) {
                        if (value!.isEmpty) {
                          return labelErrorNameCreateNewUser;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: wightApp * 0.9,
                    height: 65,
                    child: TextFormField(
                      maxLines: null,
                      minLines: null,
                      expands: true,
                      style: textStyleInputs,
                      controller: instImage,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: labelHelpInputInstUserNewUser,
                      ),
                      keyboardType: TextInputType.url,
                      onChanged: (value){setState(() {

                      });},
                      validator: (value) {
                        if (value!.isEmpty) {
                          return labelErrorNameCreateNewUser;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: wightApp * 0.9,
                    height: 125,
                    child: TextFormField(
                      maxLines: 4,
                      maxLength: 250,
                      minLines: 4,
                      style: textStyleInputs,
                      controller: sortLegend,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: labelHelpInputDescriptionSortUserNewUser,
                      ),
                      keyboardType: TextInputType.text,
                      onChanged: (value){setState(() {

                      });},
                      validator: (value) {
                        if (value!.isEmpty) {
                          return labelErrorNameCreateNewUser;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: wightApp * 0.9,
                    height: 200,
                    child: TextFormField(
                      maxLines: 10,
                      maxLength: 1000,
                      minLines: 6,
                      style: textStyleInputs,
                      controller: largeLegend,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: labelHelpInputDescriptionLargeUserNewUser,
                      ),
                      keyboardType: TextInputType.text,
                      onChanged: (value){setState(() {

                      });},
                      validator: (value) {
                        if (value!.isEmpty) {
                          return labelErrorNameCreateNewUser;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  GetElevatedButton(labelButSaveDataBase, () async{
                    GetElevatedButton.resetSound();
                     if(await DBFirebase.firebaseCreateUsers.setSaveUpdateUser(Users(DBFirebase.firebaseCreateUsers.myUser.apiId,nameUser.text,
                         name.text.toUpperCase(), instImage.text,
                         largeLegend.text.toUpperCase(),   sortLegend.text.toUpperCase(),DBFirebase.firebaseCreateUsers.myUser.followed,DBFirebase.firebaseCreateUsers.myUser.followed))){
                       await DBFirebase.firebaseCreateUsers.setFindUsersInFireBase();
                       forceNoticeWithLegend(navigatorKey.currentContext!, labelEditeSuccessSettingsScreen);
                     }


                  }, Icon(Icons.save,color: colorIconsMenu,size: 30,) , buttonStyleButMenu),
                  const SizedBox(height: 10),
                ]
            ),
          ),
          const SizedBox(height: 1),
        ],
      ),
      ),
    );
  }

}
