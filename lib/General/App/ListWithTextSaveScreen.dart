import 'package:Six/DataBase/BDFirebase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Const/ConstNames.dart';
import '../../Const/ConstStyle.dart';
import '../../Models/ControllerExpandList.dart';
import '../../Models/Statics.dart';
import '../../Objectos/AudioMap.dart';
import 'SpeechScreenController.dart';

class ListWithTextSaveScreen extends StatefulWidget {
  const ListWithTextSaveScreen({Key? key}) : super(key: key);

  @override
  State<ListWithTextSaveScreen> createState() => _ListWithTextSaveScreenState();
}

class _ListWithTextSaveScreenState extends State<ListWithTextSaveScreen> {

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
                  getModelDetails(labelTopListText, "", "", Icons.file_open_rounded, Colors.black54, 65,forceSizeText: 10,titleAlign:Alignment.centerLeft ),
                  const SizedBox(height: 1),
                  getModelDetails("", "", "", Icons.people_alt, Colors.black54, 85,forceSizeText: 10,titleAlign:Alignment.centerLeft ,firstIcon:
                  SizedBox(
                    width: wightApp * 0.75,
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
                  ),secondIcon:IconButton(onPressed: () => setNavigatorTransition(context, SpeechScreenController()), icon: Icon(Icons.add_circle_outline_outlined,color: colorIconsMenu,size: 25,))),
                ]
            ),
            const SizedBox(height: 1),
            Container(
              width: wightApp,
              color: Colors.black54,
              height: heightApp * 1.25,
              child: _getListBuild(),),
            /*Visibility(
              visible: MediaQuery.of(context).viewInsets.bottom == 0,
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: TextButton(onPressed: ()=> openUrl('https://www.mushroomangelsgames.com'), child:  const AutoSizeText(version,minFontSize: 6,maxFontSize: 10,)),
              ),
            ),*/

          ],
        ),
      ),
    );
  }

  _getListBuild(){
    int amountList = 0;
    List<AudioMap> audioMap = [];

   if(filterFind.text.isNotEmpty){
     audioMap = DBFirebase.firebaseDocuments.getFilterAudioMapTextFilter(filterFind.text.toUpperCase());

   } else{
     audioMap = DBFirebase.firebaseDocuments.getFilterAudioMap();

   }


    amountList = _controllerExpandList.controllerToExpand(audioMap, amountList);
      return RefreshIndicator(
        onRefresh: () async{ setState(() {
          DBFirebase.firebaseDocuments.setFindDocumentsInFireBase();
        });},
        child: ListView.builder(
            itemCount: audioMap.isNotEmpty ? amountList : 1,
            controller: _controllerExpandList.controller,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (_, count) {

              if(audioMap.isEmpty && filterFind.text.isEmpty){
                return getModelDetails(labelNotItemsInBase," ",'',Icons.error,Colors.black26,60,forceSizeText: 10,useBorder: false);
              }else if(audioMap.isEmpty && filterFind.text.isNotEmpty){
                return getModelDetails(labelNotItemsInBaseWithFilter," ",'',Icons.no_sim,Colors.black26,60,forceSizeText: 10,useBorder: false);
              }


              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: getModelDetails(audioMap[count].nameSave,"", audioMap[count].dateCreate, forceSizeText: 8,
                    Icons.file_copy,
                    Colors.black38,
                    70,
                    firstIcon: IconButton(onPressed: () {setNavigatorTransition(context, SpeechScreenController(audioMap: audioMap[count]));}, icon: Icon(Icons.edit_note, size: 35, color: colorIconsMenu,)),
                    secondIcon: IconButton(onPressed: () {DBFirebase.createPdf.createPdfData(audioMap[count]);}, icon: Icon(Icons.picture_as_pdf, size: 30, color: colorIconsMenu,))),
              );
            },
        ),
      );
  }

}

