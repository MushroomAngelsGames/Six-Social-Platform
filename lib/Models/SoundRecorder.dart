import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:Six/Init/InitApp.dart';
import 'package:Six/Models/Statics.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart' show DateFormat;

const pathToSaveAudio = "audio_example";

class SoundRecorder {
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecorderInitialized = false;
  final audioPlayer = AssetsAudioPlayer();

  bool get isRecording => _audioRecorder!.isRecording;
  bool get isPaused => _audioRecorder!.isPaused;
  bool get isPlay=> isPlaying;

  late Uint8List soundFile;
  String localSave = "teste.aac";
  String _path = "/storage/emulated/0";
  bool hasRecorder = false;
  bool isPlaying = false;

  Future init()async{
    _audioRecorder =FlutterSoundRecorder();
    final status = await Permission.microphone.request();
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();



    if(status != PermissionStatus.granted){
      forceErrorNoticeWithLegend(navigatorKey.currentContext!, "Você Precisa Autorizar a Utilização do Microfone ");
    }

    await _audioRecorder!.openAudioSession(
      focus: AudioFocus.requestFocusAndStopOthers,
      category: SessionCategory.playAndRecord,
      mode: SessionMode.modeDefault,
      device: AudioDevice.speaker
    );

    _isRecorderInitialized = true;
  }

  void dispose(){

    if(!_isRecorderInitialized) return;

    _audioRecorder!.closeAudioSession();
    _audioRecorder = null;
    _isRecorderInitialized = false;
  }

  Future _record() async{
    if(!_isRecorderInitialized) return;

    _path = await saveAndGeneratorScreen();

    await _audioRecorder!.startRecorder(
        toFile: _path
    );

    StreamSubscription _recorderSubscripting = _audioRecorder!.onProgress!.listen((event) {
      var date = DateTime.fromMillisecondsSinceEpoch(event.duration.inMilliseconds, isUtc: true);
      var txt = DateFormat("mm:ss:SS","en_GB").format(date);
      txt.substring(0,8);


    });

    _recorderSubscripting.cancel();

  }

  Future _startPlaying() async{
    await audioPlayer.open(
      Audio.file(_path),
      autoStart:true,
      showNotification:true,
   );
    isPlaying = true;
  }

  Future _stopPlaying() async{
    await  audioPlayer.stop();
    isPlaying = false;
  }

  Future _stop() async{
    if(!_isRecorderInitialized) return;
    await _audioRecorder!.stopRecorder();
    _writeFileToStorage();
    hasRecorder = true;
  }

  Future toggleRecording() async {
    if (!_audioRecorder!.isRecording) {
      await _record();
    } else {
      await _stop();
    }
    getEffectsListening();
  }

  Future togglePlaying() async {
    if (!isPlaying) {
      await _startPlaying();
    } else {
      await _stopPlaying();
    }
    getEffectsListening();
  }

  Future togglePause() async {
    if (_audioRecorder!.isRecording && !_audioRecorder!.isPaused) {
      await _audioRecorder!.pauseRecorder();
    } else {
      await _audioRecorder!.resumeRecorder();
    }
    getEffectsListening();
  }

  void _writeFileToStorage() async {
    File file = File(_path);

    Uint8List bytes = await file.readAsBytes();
    file.writeAsBytes(bytes);
  }

  Future<String> saveAndGeneratorScreen() async {
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/$localSave';
    return path;
  }


}