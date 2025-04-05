import 'package:Six/DataBase/BDFirebase.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Const/ConstNames.dart';
import '../../Const/ConstStyle.dart';
import '../../Models/ControllerExpandList.dart';
import '../../Models/Statics.dart';
import '../../Objectos/AudioMap.dart';
import '../../Objectos/User.dart';
import 'SpeechScreenController.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController filterFind = TextEditingController();
  final ControllerExpandList _controllerExpandList = ControllerExpandList(50);

  @override
  void dispose() {
    filterFind.dispose();
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
      child:Obx(()=> (DBFirebase.firebaseDocuments.isLoadDocuments.value || DBFirebase.createPdf.isLoadingPdf.value)?
      Padding(padding: const EdgeInsets.all(8.0),
          child: getModelDetails(DBFirebase.createPdf.isLoadingPdf.value ? labelWaitPdf : labelWaitFindItems, '', '', Icons.waving_hand, Colors.black54, 65,secondIcon:
          const CircularProgressIndicator(),forceSizeText: 10,titleAlign: Alignment.centerLeft,useBorder: true)) :
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                getModelDetails(labelNameSearchScreen, "", "", Icons.person_add, Colors.black54, 65,forceSizeText: 10,titleAlign:Alignment.centerLeft ),
                const SizedBox(height: 1),
                getModelDetails("", "", "", Icons.people_alt, Colors.black54, 85,forceSizeText: 10,titleAlign:Alignment.centerLeft ,firstIcon:
                SizedBox(
                  width: wightApp * 0.9,
                  height: 65,
                  child: TextFormField(
                    style: textStyleInputs,
                    controller: filterFind,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: labelFilterFindListText,
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
                )),
              ]
          ),
          const SizedBox(height: 1),
          Container(
            width: wightApp,
            color: Colors.black54,
            height: heightApp * 1.25,
            child: _getListBuild(),),
        ],
      ),
      ),
    );
  }

  _getListBuild(){
    int amountList = 0;
    List<Users> users = [];

    if(filterFind.text.isNotEmpty){
      users = DBFirebase.firebaseCreateUsers.getFilterUsersTextFilter(filterFind.text.toUpperCase());
    } else{
      users = DBFirebase.firebaseCreateUsers.getFilterUsers();
    }


    amountList = _controllerExpandList.controllerToExpand(users, amountList);

    return RefreshIndicator(
      onRefresh: () async{
        await DBFirebase.firebaseCreateUsers.setFindUsersInFireBase();
        setState(() {
      });},

      child: ListView.builder(
        itemCount: users.isNotEmpty ? amountList : 1,
        controller: _controllerExpandList.controller,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (_, count) {

          if(users.isEmpty && filterFind.text.isEmpty){
            return getModelDetails(labelNotSearchScreen," ",'',Icons.error,Colors.black26,60,forceSizeText: 8,useBorder: false);
          }else if(users.isEmpty && filterFind.text.isNotEmpty){
            return getModelDetails(labelNotSearchScreenBaseWithFilter," ",'',Icons.person_add_disabled_rounded,Colors.black26,60,forceSizeText: 8,useBorder: false);
          }


          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: getModelDetails(users[count].nameUserLogin,"", users[count].nameUser, forceSizeText: 7, Icons.file_copy,Colors.black38, 85,
              firstIcon: CachedNetworkImage(
                imageUrl: users[count].urlImage,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error)  {
                  return  CircleAvatar(
                      backgroundColor: Colors.white,
                      radius : 25,
                      child: InkWell(
                        onTap:() => showImageItemFull(context,users[count].urlImage),
                        child: ClipOval(
                            child: Image.asset(imageError)),
                      ));},
                imageBuilder: (context, image) => CircleAvatar(
                  backgroundColor: Colors.white,
                  radius : 25,
                  child:  InkWell(
                    onTap:() => showImageItemFull(context,users[count].urlImage),
                    child: ClipOval(
                        child: Image(image: image,fit: BoxFit.fitWidth)),
                  ),
                ),
              ),
              secondIcon: OutlinedButton(onPressed: ()=>
              users[count].follower.containsKey(DBFirebase.firebaseCreateUsers.myUser.apiId)?
              unFollowNow(users[count]) :  followNow(users[count]), child:  AutoSizeText(
                  users[count].follower.containsKey(DBFirebase.firebaseCreateUsers.myUser.apiId)? labelButUnFollowViewStudyScreen: labelButFollowViewStudyScreen,minFontSize: 6,maxFontSize: 7,))),
          );
        },
      ),
    );

  }

  followNow(Users follower) async{
    if(DBFirebase.firebaseCreateUsers.isSaveFollowers.value) {
      return;
    }
    await DBFirebase.firebaseCreateUsers.setSaveNewFollowed(DBFirebase.firebaseCreateUsers.myUser,follower);

    setState(() { });
  }

  unFollowNow(Users follower) async{

    if(DBFirebase.firebaseCreateUsers.isSaveFollowers.value) {
      return;
    }

    await DBFirebase.firebaseCreateUsers.setSavUnFollowed(DBFirebase.firebaseCreateUsers.myUser,follower);
    setState(() { });
  }

}
