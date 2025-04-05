import 'package:Six/Models/Statics.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../Objectos/Video.dart';
import 'YoutubePlayer.dart';

/// Creates list of video players
class VideoList extends StatefulWidget {
   VideoList({super.key,required this.ids,required this.isOwner});

   bool isOwner;
  List<Video> ids;
  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.ids.length * 75,
      child: ListView.separated(
          itemBuilder: (context, index) {
            return getModelDetails(widget.ids[index].nameVideo,"", widget.ids[index].idOrLink, Icons.video_collection, Colors.black38, 75,secondIcon:
            OutlinedButton(onPressed: () => _playVideo(index), child: const AutoSizeText("PLAY",minFontSize: 6,maxFontSize: 8,)),forceSizeText: 6,
                firstIcon: widget.isOwner ? IconButton(onPressed: (){
                  setState(() {
                    widget.ids.remove(widget.ids[index]);
                  });
                }, icon: const Icon(Icons.delete_forever,size: 35,color: Colors.red,)) : null);
          },
          itemCount:  widget.ids.length,
          separatorBuilder: (context, _) => const SizedBox(height: 1.0),
        ),
    );
  }

  _playVideo(int idStart){
   setNavigatorTransition(context,  PlayerVideo(id: widget.ids,idStart: idStart,));
  }
}