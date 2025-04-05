
import 'dart:typed_data';

import 'package:Six/Const/ConstStyle.dart';
import 'package:Six/DataBase/BDFirebase.dart';
import 'package:Six/Init/InitApp.dart';
import 'package:Six/Models/GetElevatedButton.dart';
import 'package:Six/Models/LinkModelOpen.dart';
import 'package:Six/Models/Statics.dart';
import 'package:Six/Objectos/AudioMap.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../Const/ConstNames.dart';
import '../../Models/LoadLink.dart';
import '../../Models/LoadVideo.dart';
import '../../Models/NewAppBar.dart';
import '../../Models/SoundRecorder.dart';
import '../../Models/VideoList.dart';
import '../../Objectos/Video.dart';

class SpeechScreenController extends StatefulWidget {
  SpeechScreenController({AudioMap? audioMap, Key? key}) {
    if(audioMap != null){
      editeAudioMap=audioMap;

      if(editeAudioMap!.idUser == DBFirebase.firebaseCreateUsers.myUser.apiId){
        isOwner = true;
      }
      isEdite = true;

    }else{
      isOwner = true;
    }
  }

  bool isOwner = false;
  bool isEdite = false;
  late AudioMap? editeAudioMap = AudioMap("", "", "",false,"",[],[]);

  @override
  State<SpeechScreenController> createState() => _SpeechScreenControllerState();
}

class _SpeechScreenControllerState extends State<SpeechScreenController> {

  final formKey = GlobalKey<FormState>();
  late final List<bool> _isExpanded = List.generate(5, (index) => false);
  final TextEditingController _labelHelp = TextEditingController();
  final SpeechToText _speech = SpeechToText();

  TextEditingController labelNameSave = TextEditingController();

  bool _speechEnabled = false;
  String lateResult ="";
  List<Video> ids = [];
  List<Video> links = [];
  SoundRecorder soundRecorder = SoundRecorder();

  bool _isListening = false;
  double _confidence = 1.0;

  bool isPublic = false;
  bool isRecording = false;

  late Uint8List soundFile;

  static const String labelClickCaptureAudio = 'Click para Capturar Áudio.';
  static const String labelSecondClickCaptureAudio=  'Trascrição:';

  @override
  void initState() {
    super.initState();
    soundRecorder.init();
    _initSpeech();
    if(widget.isEdite){
      links = widget.editeAudioMap!.links;
      ids = widget.editeAudioMap!.movies;
      isPublic = widget.editeAudioMap!.isPublic;
      labelNameSave.text = widget.editeAudioMap!.nameSave;
      _labelHelp.text = widget.editeAudioMap!.audioToText;
    }
  }



  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speech.initialize(
        onError: (value) {
          if(value.errorMsg == "error_no_match" || value.errorMsg == "error_speech_timeout" ){
            _startListening();
          }
          else{
            forceErrorNoticeWithLegend(navigatorKey.currentContext!, labelErrorStartRecover+value.errorMsg,);
            _stopListening();
          }
        }
    );
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {

    if(_labelHelp.text.isNotEmpty){
      lateResult = _labelHelp.text;
    }

    if(!_isListening){
      getEffectsListening();
    }

    if(_speechEnabled) {

      await _speech.listen(onResult: _onSpeechResult,
      partialResults: true,listenFor: const Duration(days: 1)).whenComplete(() {setState(() {});});
      _isListening = true;
      setState(() {});
    }
  }

  void _stopListening() async {
    await _speech.stop();
    _isListening = false;
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _labelHelp.text = "$lateResult ${result.recognizedWords}";
    });
  }

  @override
  void dispose() {
    labelNameSave.dispose();
    soundRecorder.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    if(_isListening && _speech.isNotListening){
        _startListening();
    }

    return WillPopScope(
      onWillPop: () async{
        if(!widget.isOwner) return true;

        final confirmation = await showWillPopAlert(
            context, labelExitNoSaveSpeechScreenController, labelExitNoSaveNotExitSpeechScreenController,labelExitNoSaveConfirmSpeechScreenController);
        return confirmation ?? false;
      },
      child: Scaffold(
        appBar: NewAppbar().getAppBar(appNameNewDocument, textStyleTopMenu, true,context, positionTextCenter: true,isFistScreen: true),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: _body(),
      ),
    );
  }

  _body(){
    return SingleChildScrollView(
      reverse:  true,
      child: Container(
        padding: const EdgeInsets.fromLTRB(5, 5, 5,15),
        child: Obx(() => (DBFirebase.firebaseDocuments.isSaveInFirebase.value || DBFirebase.createPdf.isLoadingPdf.value )?
        Padding(padding: const EdgeInsets.all(8.0),
            child: getModelDetails(DBFirebase.createPdf.isLoadingPdf.value ? labelWaitPdf : labelWaitSpeechScreenController, '', '', Icons.waving_hand, Colors.black54, 65,secondIcon:
            const CircularProgressIndicator(),forceSizeText: 10,titleAlign: Alignment.centerLeft,useBorder: true)) :
        Column(
          children: [
            Visibility(
              visible: widget.isOwner,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: widget.isEdite? wightApp * 0.8 : wightApp *0.97,
                    child: getModelDetails(labelVisibilityCharactersSpeechScreenController,  "" ,"", isPublic ? Icons.public_outlined : Icons.public_off, Colors.black54, 70,useBorder: true,forceSizeText: 10,titleAlign: Alignment.centerLeft,
                        secondIcon:OutlinedButton(onPressed: () => _togglePublicOrPrivate(),
                            child: AutoSizeText(!isPublic? labelButPrivateName:labelButPublicName,minFontSize: 6,maxFontSize: 10,))),
                  ),
                  Visibility(
                      visible: widget.isEdite,
                      child: IconButton(onPressed: _openMenuRemove, icon: const Icon(Icons.delete_forever,color: Colors.red,size: 35))),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Visibility(
                  visible:  widget.isOwner,
                  child: SizedBox(
                      width: wightApp * 0.48,
                      child: GetElevatedButton(widget.isEdite? labelButEditeDataBase : labelButSaveDataBase, () {widget.isEdite? _openMenuAcceptSaveEdite() : _openMenuNameSave();}, Icon(Icons.save,color: colorIconsMenu,size: 30), buttonStyleButMenu)),
                ),
                SizedBox(
                    width:  widget.isOwner ? wightApp * 0.48 : wightApp * 0.97,
                    child: GetElevatedButton(labelButGeneratorPdfDataBase, () {DBFirebase.createPdf.createPdfData(AudioMap("Empty", _labelHelp.text, "",isPublic,"",[],[]));}, Icon(Icons.picture_as_pdf,color: colorIconsMenu,size: 30), buttonStyleButMenu))
              ],),
            const SizedBox(height: 10),
            ExpansionPanelList(
              expandedHeaderPadding: const EdgeInsets.all(1),
              dividerColor: Colors.brown,
              expansionCallback: (index, isExpanded) => setState(() {
                player.play(nameClipBut, isNotification: true, volume: 0.5);
                _isExpanded[index] = !isExpanded;
              }),
              children: [
                _audioRecorder(),
                _speechToText(),
                _link(),
                _youtubePlayer()
              ],
            ),
          ],
        ),
        ),
      ),
    );
  }

  _clickButton() async {
    await soundRecorder.toggleRecording();
    isRecording = soundRecorder.isRecording;

   setState(() {

   });

  }

  _clickButtonPause() async {
    await soundRecorder.togglePause();
    setState(() {

    });
  }

  _clickButtonPlaying() async {
    await soundRecorder.togglePlaying();
    setState(() {

    });
  }


  _togglePublicOrPrivate(){
    isPublic = !isPublic;
    setState(() {

    });
  }

  ExpansionPanel _audioRecorder() {
    return ExpansionPanel(
      backgroundColor: Colors.black38,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Visibility(
                visible:  widget.isOwner,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: isRecording  ? wightApp * 0.45 : wightApp* 0.92,
                      child: GetElevatedButton(isRecording ? labelButStop : labelButPlayRecorder, () => _clickButton(),
                          Icon(isRecording ? Icons.stop_circle : Icons.mic,color: colorIconsMenu,size: 35,),
                          isRecording ? buttonStyleButStop:buttonStyleButMenu  ),
                    ),
                    Visibility(
                      visible: isRecording,
                      child: SizedBox(
                        width: wightApp * 0.45,
                        child: GetElevatedButton(soundRecorder.isPaused ? labelButResumeStop : labelButPauseStop, () =>  _clickButtonPause(),
                            Icon(soundRecorder.isPaused ? Icons.play_arrow : Icons.pause,color: colorIconsMenu,size: 35,),
                            soundRecorder.isPaused ? buttonStyleButResume:buttonStyleButMenu  ),
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 5),
            GetElevatedButton(soundRecorder.isPlay? "PARAR" : "REPRODUZIR", () => _clickButtonPlaying(), Icon(soundRecorder.isPlay? Icons.stop: Icons.play_circle,color: colorIconsMenu,size: 35,), soundRecorder.isPlay ? buttonStyleButStop:buttonStyleButMenu  )
          ],
        ),
      ),
      headerBuilder: (_, isExpanded) {
        return Padding(
          padding: const EdgeInsets.all(25.0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                widget.isOwner? labelButAudioRecorderVideoName : labelButAudioVideoName,
                style: textStyleInputs,
                maxFontSize: 10,
                minFontSize: 8,
              )),
        );
      },
      isExpanded: _isExpanded[0],
    );
  }

  ExpansionPanel _speechToText() {
    return ExpansionPanel(
      backgroundColor: Colors.black38,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            getModelDetails(labelCountCharactersSpeechScreenController,  _labelHelp.text.length.toString() ,"", Icons.book_outlined, Colors.black54, 65,useBorder: true,forceSizeText: 12,titleAlign: Alignment.centerLeft),
            Container(
              color: Colors.black26,
              height: heightApp,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: TextField(
                  controller: _labelHelp,
                  enabled: widget.isOwner,
                  textAlign: TextAlign.justify,
                  decoration: const InputDecoration(
                    hintText: labelClickCaptureAudio,
                    labelText: labelSecondClickCaptureAudio,
                  ),
                  onChanged: (value){
                    setState(() {

                    });
                  },
                  autofocus: false,
                  maxLines: null,
                  keyboardType: TextInputType.text,
                ),
              ),
            ),
            Visibility(
              visible:  widget.isOwner,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GetElevatedButton(labelClickCaptureAudio, () => _speech.isNotListening ? _startListening() : _stopListening() , Icon(_isListening ? Icons.mic: Icons.mic_none,color: colorIconsMenu,size: 35,),_isListening ? buttonStyleButStop:buttonStyleButMenu  ),
              ),
            )
          ],
        ),
      ),
      headerBuilder: (_, isExpanded) {
        return Padding(
          padding: const EdgeInsets.all(25.0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                labelButSpeechToTextName,
                style: textStyleInputs,
                maxFontSize: 10,
                minFontSize: 8,
              )),
        );
      },
      isExpanded: _isExpanded[1],
    );
  }

  ExpansionPanel _youtubePlayer() {
    return ExpansionPanel(
      backgroundColor: Colors.black38,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children:  [
            widget.isOwner ? LoadVideo(ids: ids,isOwner: widget.isOwner) :  VideoList(ids: widget.editeAudioMap!.movies,isOwner: widget.isOwner),
          ],
        ),
      ),
      headerBuilder: (_, isExpanded) {
        return Padding(
          padding: const EdgeInsets.all(25.0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                labelButLinkToVideoName,
                style: textStyleInputs,
                maxFontSize: 10,
                minFontSize: 8,
              )),
        );
      },
      isExpanded: _isExpanded[3],
    );
  }

  ExpansionPanel _link() {
    return ExpansionPanel(
      backgroundColor: Colors.black38,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children:  [
            widget.isOwner ? LoadLink(ids: links,isOwner: widget.isOwner) :  LinkModelOpen(ids: links,isOwner: widget.isOwner),
          ],
        ),
      ),
      headerBuilder: (_, isExpanded) {
        return Padding(
          padding: const EdgeInsets.all(25.0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                labelButLinkName,
                style: textStyleInputs,
                maxFontSize: 10,
                minFontSize: 8,
              )),
        );
      },
      isExpanded: _isExpanded[2],
    );
  }

  _openMenuNameSave(){
    labelNameSave.clear();
    GetElevatedButton.resetSound();
    setAlertNowWithWidget(context, AlertType.warning, labelLegendTitleSaveSpeechScreenController, labelLegendSaveSpeechScreenController, [
      SizedBox(
        width: wightApp * 5,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 8.0),
                    child: TextFormField(
                      style: textStyleInputs,
                      controller: labelNameSave,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: labelHelpNameSaveSpeechScreenController,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return labelErrorNameSaveSpeechScreenController;
                        } else if (value.length < 4) {
                          return labelErrorNameSaveSpeechScreenController;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 5),
                    child: GetElevatedButton(labelButSaveDataBase,() =>  _setSaveDocument(),
                        Icon(Icons.save, color: colorIconsMenu),buttonStyleButMenu
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: GetElevatedButton(labelCancel,() {GetElevatedButton.resetSound(); Navigator.of(context,rootNavigator: true).pop();},
                        Icon(Icons.cancel, color: colorIconsMenu),buttonStyleButMenu
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      )
    ]);
  }

  _openMenuAcceptSaveEdite(){
    setAlertNowWithWidget(context, AlertType.warning, labelLegendTitleEditeSpeechScreenController, labelLegendEditeSpeechScreenController, [
      SizedBox(
        width: wightApp * 5,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 5),
                    child: GetElevatedButton(labelButEditeDataBase,() =>  _setEditeDocument(),
                        Icon(Icons.save, color: colorIconsMenu),buttonStyleButMenu
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: GetElevatedButton(labelCancel,() {GetElevatedButton.resetSound(); Navigator.of(context,rootNavigator: true).pop();},
                        Icon(Icons.cancel, color: colorIconsMenu),buttonStyleButMenu
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      )
    ]);
  }

  _openMenuRemove(){
    labelNameSave.clear();
    GetElevatedButton.resetSound();
    setAlertNowWithWidget(context, AlertType.warning, labelLegendTitleRemoveSpeechScreenController, labelLegendRemoveSpeechScreenController, [
      SizedBox(
        width: wightApp * 5,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 5),
                    child: GetElevatedButton(labelButRemoveDataBase,() =>  _setRemoveItem(),
                        Icon(Icons.delete_forever, color: Colors.red),buttonStyleButMenu
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: GetElevatedButton(labelCancel,() {GetElevatedButton.resetSound(); Navigator.of(context,rootNavigator: true).pop();},
                        Icon(Icons.cancel, color: colorIconsMenu),buttonStyleButMenu
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      )
    ]);
  }

  _setRemoveItem() async{
    Navigator.of(context,rootNavigator: true).pop();
    if(await DBFirebase.firebaseDocuments.removeDocument(widget.editeAudioMap!)){
      DBFirebase.firebaseDocuments.setFindDocumentsInFireBase();
      Navigator.of(context,rootNavigator: true).pop();
      forceNoticeWithLegend(navigatorKey.currentContext!, labelRemoveWithSuccess);
    }
  }

  _setEditeDocument() async{
    if(formKey.currentState!.validate()){
      setState((){});
      GetElevatedButton.resetSound();
      Navigator.of(context,rootNavigator: true).pop();
      if(await DBFirebase.firebaseDocuments.setEditeDocument(
          AudioMap(labelNameSave.text, _labelHelp.text, "",isPublic,widget.editeAudioMap!.idUser,ids,links))){
        Navigator.of(context,rootNavigator: true).pop();
        forceNoticeWithLegend(navigatorKey.currentContext!, labelSaveWithSuccess);
        DBFirebase.firebaseDocuments.setFindDocumentsInFireBase();
      }

      _resetValue();
    }
  }

  _setSaveDocument() async{
    if(formKey.currentState!.validate()){
      setState((){});
      GetElevatedButton.resetSound();
      Navigator.of(context,rootNavigator: true).pop();
      if( await DBFirebase.firebaseDocuments.setSaveNewDocument(
          AudioMap(labelNameSave.text, _labelHelp.text, "",isPublic,DBFirebase.firebaseCreateUsers.myUser.apiId,ids,links))){
        Navigator.of(context,rootNavigator: true).pop();
        forceNoticeWithLegend(navigatorKey.currentContext!, labelSaveWithSuccess);
        DBFirebase.firebaseDocuments.setFindDocumentsInFireBase();
      }

      _resetValue();
    }
  }

  _resetValue(){
    labelNameSave.clear();
    _labelHelp.clear();
  }


}
