import 'package:Six/DataBase/BDFirebase.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Const/ConstNames.dart';
import '../../Const/ConstStyle.dart';
import '../../Models/ControllerExpandList.dart';
import '../../Models/Statics.dart';

import '../../Objectos/FileAudioMap.dart';
import 'SpeechScreenController.dart';


class ViewStudyScreen extends StatefulWidget {
  const ViewStudyScreen({Key? key}) : super(key: key);

  @override
  State<ViewStudyScreen> createState() => _ViewStudyScreenState();
}

class _ViewStudyScreenState extends State<ViewStudyScreen> {
  final TextEditingController filterFind = TextEditingController();
  final ControllerExpandList _controllerExpandList = ControllerExpandList(50);

  late TypeFind typeFind = TypeFind.data;
  late String filterDropDown = 'DATA';

  @override
  void initState(){
    super.initState();
    DBFirebase.firebasePublicFile.setFindFirebasePublicFile();
  }


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
      child:Obx(()=> (DBFirebase.firebasePublicFile.isLoadDocuments.value)?
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
                getModelDetails(labelNameViewStudyScreen, "", "", Icons.public_outlined, Colors.black54, 65,forceSizeText: 10,titleAlign:Alignment.centerLeft ),
                const SizedBox(height: 1),
                Container(
                  color: Colors.black54,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: wightApp * 0.7,
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
                        ),
                      ),
                      _getDropDownFilter()
                    ],
                  ),
                ),
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

  Widget _getDropDownFilter() {
    return Container(
      width: wightApp * 0.2,
      alignment: AlignmentDirectional.centerEnd,
      child: DropdownButton<String>(
        dropdownColor: Colors.black,
        menuMaxHeight:  MediaQuery.of(context).size.height * 0.8,
        value: filterDropDown,
        icon: Icon(
          Icons.arrow_downward,
          color: colorIconsMenu,
          textDirection: TextDirection.rtl,
        ),
        elevation: 50,
        style: textStyleInputs,
        underline: Container(
          height: 1,
          color: Colors.white70,
        ),
        onChanged: (String? newValue) {
          setState(() {
            filterDropDown = newValue!;

            switch(filterDropDown){
              case 'DATA':
                typeFind =TypeFind.data;
                break;
              case 'NOME':
                typeFind = TypeFind.name;
                break;
            }

          });
        },
        items: <String>['DATA','NOME']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            alignment: AlignmentDirectional.centerStart,
            value: value,
            child: AutoSizeText(
              value,
              maxFontSize: 10,
              minFontSize: 6,
              style: textStyleValue,
            ),
          );
        }).toList(),
      ),
    );
  }

  _getListBuild(){
    int amountList = 0;

    List<FileAudioMap> mapsPublic = [];

    if(filterFind.text.isNotEmpty){
      mapsPublic = DBFirebase.firebasePublicFile.getFilterAudioMapTextFilter(filterFind.text.toUpperCase());

    } else{
      mapsPublic = DBFirebase.firebasePublicFile.getFilterAudioMap();
    }

    amountList = _controllerExpandList.controllerToExpand(mapsPublic, amountList);

    mapsPublic = getListFileAudioMapSequence(mapsPublic,typeFind);

    return RefreshIndicator(
      onRefresh: () async{ setState(() {
        DBFirebase.firebasePublicFile.setFindFirebasePublicFile();
      });},
      child: ListView.builder(
        itemCount: mapsPublic.isNotEmpty ? amountList : 1,
        controller: _controllerExpandList.controller,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (_, count) {

          if(mapsPublic.isEmpty && filterFind.text.isEmpty){
            return getModelDetails(labelNotPublicItemsInBase," ",'',Icons.error,Colors.black26,60,forceSizeText: 10,useBorder: false);
          }else if(mapsPublic.isEmpty && filterFind.text.isNotEmpty){
            return getModelDetails(labelNotPublicInBaseWithFilter," ",'',Icons.no_sim,Colors.black26,60,forceSizeText: 10,useBorder: false);
          }

          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: getModelDetails("${mapsPublic[count].user.nameUserLogin} : ${mapsPublic[count].audioMap.nameSave}","", mapsPublic[count].audioMap.dateCreate, forceSizeText: 8, Icons.file_copy, Colors.black38, 85,
                firstIcon: CachedNetworkImage(
                  imageUrl: mapsPublic[count].user.urlImage,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error)  {
                    return  CircleAvatar(
                        backgroundColor: Colors.white,
                        radius : 25,
                        child: InkWell(
                          onTap:() => showImageItemFull(context,""),
                          child: ClipOval(
                              child: Image.asset(imageError)),
                        ));},
                  imageBuilder: (context, image) => CircleAvatar(
                    backgroundColor: Colors.white,
                    radius : 25,
                    child:  InkWell(
                      onTap:() => showImageItemFull(context,""),
                      child: ClipOval(
                          child: Image(image: image,fit: BoxFit.cover,)),
                    ),
                  ),
                ),
                secondIcon: IconButton(
                    onPressed: () {setNavigatorTransition(context, SpeechScreenController(audioMap: mapsPublic[count].audioMap));},
                    icon: Icon(Icons.read_more_sharp, size: 30, color: colorIconsMenu,)),),
          );
        },
      ),
    );
  }
}
