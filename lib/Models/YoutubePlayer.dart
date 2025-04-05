import 'package:Six/Models/NewAppBar.dart';
import 'package:Six/Models/Statics.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../Const/ConstNames.dart';
import '../Const/ConstStyle.dart';
import '../Objectos/Video.dart';


class PlayerVideo extends StatefulWidget {
   PlayerVideo({super.key,required this.id, required this.idStart}){
     for (var element in id) {
       ids.add(element.idOrLink);
     }
   }

   int idStart;
   List<Video> id;
   List<String> ids = [];

  @override
  _PlayerVideoState createState() => _PlayerVideoState();
}

class _PlayerVideoState extends State<PlayerVideo> {
  late YoutubePlayerController _controller;

  int count = 0;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  @override
  void initState() {
    count =widget.idStart;
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.ids[widget.idStart]) ?? "",
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _loadNew(bool next){


      if(next){
        if(count >= widget.ids.length -1){
          count = 0;
        }else{
          count++;
        }
      }else{
        if(count <=0){
          count = widget.ids.length - 1;
        }else{
          count--;
        }
      }

    _controller.load(YoutubePlayer.convertUrlToId(widget.ids[count]) ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
        onExitFullScreen: () {
          SystemChrome.setPreferredOrientations(DeviceOrientation.values);
        },
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.blueAccent,
          topActions: <Widget>[
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                _controller.metadata.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
          onReady: () {
            _isPlayerReady = true;
          },
          onEnded: (data) {_controller.load(widget.ids[(widget.ids.indexOf(data.videoId) + 1) % widget.ids.length]);
          },
        ),
        builder: (context, player) =>
            Scaffold(
                appBar: NewAppbar().getAppBar(appNameNewDocument, textStyleTopMenu, true,context, positionTextCenter: true,isFistScreen: true),
                body:Column(
                  children: [
                    player,
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _space,
                          AutoSizeText(_videoMetaData.title,minFontSize: 6,maxFontSize: 10),
                          _space,
                          AutoSizeText(_videoMetaData.author,minFontSize: 6,maxFontSize: 10),
                          _space,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.skip_previous),
                                onPressed: _isPlayerReady
                                    ? () => _loadNew(false)
                                    : null,
                              ),
                              IconButton(
                                icon: Icon(
                                  _controller.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                ),
                                onPressed: _isPlayerReady
                                    ? () {
                                  _controller.value.isPlaying
                                      ? _controller.pause()
                                      : _controller.play();
                                  setState(() {});
                                }
                                    : null,
                              ),
                              IconButton(
                                icon: Icon(_muted ? Icons.volume_off : Icons.volume_up),
                                onPressed: _isPlayerReady
                                    ? () {
                                  _muted
                                      ? _controller.unMute()
                                      : _controller.mute();
                                  setState(() {
                                    _muted = !_muted;
                                  });
                                }
                                    : null,
                              ),
                              FullScreenButton(
                                controller: _controller,
                                color: Colors.blueAccent,
                              ),
                              IconButton(
                                icon: const Icon(Icons.skip_next),
                                onPressed: _isPlayerReady
                                    ? () => _loadNew(true)
                                    : null,
                              ),
                            ],
                          ),
                          _space,
                          getModelDetails("Volume", "", "",forceSizeText: 10, Icons.volume_up_outlined, Colors.black38, 75,secondIcon:
                          SizedBox(
                            width: wightApp*  0.5,
                            child: Slider(
                              inactiveColor: Colors.transparent,
                              value: _volume,
                              min: 0.0,
                              max: 100.0,
                              divisions: 10,
                              label: '${(_volume).round()}',
                              onChanged: _isPlayerReady
                                  ? (value) {
                                setState(() {
                                  _volume = value;
                                });
                                _controller.setVolume(_volume.round());
                              }
                                  : null,
                            ),
                          ),useBorder: true),
                          _space,
                        ],
                      ),
                    ),
                  ],
                )));
  }

  Widget get _space => const SizedBox(height: 10);

}