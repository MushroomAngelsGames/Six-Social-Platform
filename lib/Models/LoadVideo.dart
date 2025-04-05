import 'package:Six/Const/ConstNames.dart';
import 'package:Six/Const/ConstStyle.dart';
import 'package:Six/Models/GetElevatedButton.dart';
import 'package:Six/Models/VideoList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Objectos/Video.dart';

class LoadVideo extends StatefulWidget {
  LoadVideo({super.key,required this.ids,required this.isOwner});


  bool isOwner;
  List<Video> ids;

  @override
  _LoadVideoState createState() => _LoadVideoState();
}

class _LoadVideoState extends State<LoadVideo> {

  final formKey = GlobalKey<FormState>();
  final TextEditingController _idOrLinkVideo = TextEditingController();
  final TextEditingController _nameVideo = TextEditingController();


  @override
  void dispose() {
    _nameVideo.dispose();
    _idOrLinkVideo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          VideoList(ids: widget.ids,isOwner: widget.isOwner,),
          _space,
          Container(
            color: Colors.white10,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return labelErrorNameCreateNewUser;
                      }
                      return null;
                    },
                    controller: _nameVideo,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Nome do Video...',
                      fillColor: Colors.black38.withAlpha(100),
                      filled: true,
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.blueAccent,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear,color: Colors.red,),
                        onPressed: () => _nameVideo.clear(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return labelErrorNameCreateNewUser;
                      }
                      return null;
                    },
                    controller: _idOrLinkVideo,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Youtube \<Video id\> ou \<Link\>',
                      fillColor: Colors.black38.withAlpha(100),
                      filled: true,
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.blueAccent,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear,color: Colors.red,),
                        onPressed: () => _idOrLinkVideo.clear(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  GetElevatedButton("ADCIONAR NOVO VIDEO", () =>  _addNewVideo(), Icon(Icons.add_circle_outline_outlined,color: colorIconsMenu,size: 35), buttonStyleButMenu)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  _addNewVideo(){
    if(!formKey.currentState!.validate()){
      return;
    }
    setState(() {
      GetElevatedButton.resetSound();
      widget.ids.add(Video(_nameVideo.text, _idOrLinkVideo.text));
      _reset();
    });
  }

  _reset(){
    _nameVideo.clear();
    _idOrLinkVideo.clear();
  }

  Widget get _space => const SizedBox(height: 10);

}