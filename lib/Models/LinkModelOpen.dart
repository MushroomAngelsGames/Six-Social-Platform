import 'package:Six/Models/Statics.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../Objectos/Video.dart';


/// Creates list of video players
class LinkModelOpen extends StatefulWidget {
  LinkModelOpen({super.key,required this.ids,required this.isOwner});

  bool isOwner;
  List<Video> ids;

  @override
  _LinkModelOpenState createState() => _LinkModelOpenState();
}

class _LinkModelOpenState extends State<LinkModelOpen> {


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.ids.length * 100,
      child: ListView.separated(
        itemBuilder: (context, index) {
          return getModelDetails(widget.ids[index].nameVideo,"", widget.ids[index].idOrLink, Icons.link
              , Colors.black38, 100,secondIcon:
          OutlinedButton(onPressed: () => openUrl(widget.ids[index].idOrLink), child: const AutoSizeText("ABRIR",minFontSize: 6,maxFontSize: 8,)),forceSizeText: 6,
              firstIcon: widget.isOwner ?IconButton(onPressed: (){
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


}