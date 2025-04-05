import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../Const/ConstNames.dart';

class GetElevatedButton extends StatelessWidget {
  final playerSound = AudioCache();

  final String nameBut;
  final VoidCallback onPressed;
  final ButtonStyle buttonStyle;
  final Icon iconBut;
  static bool blockSound = false;

  GetElevatedButton(
    this.nameBut,
    this.onPressed,
    this.iconBut,
    this.buttonStyle, {Key? key}
  ) : super(key: key);

  ///Gerar Efeito Sonoro ao Clicar.
  VoidCallback _effectClick(){
      if (!kIsWeb) {
        if (!blockSound) {
          playerSound.play(nameClipBut, isNotification: true, volume: 0.7);
          blockSound = true;
        }
      }

    return onPressed;
  }

  ///Restaurar Efeito Sonoro do Click.
  static resetSound() =>  blockSound = false;

  ///Construtor Principal.
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: buttonStyle,
      onPressed: _effectClick(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        verticalDirection:  VerticalDirection.down,
        crossAxisAlignment:CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          AutoSizeText(
            nameBut,
            maxFontSize: 10,
            minFontSize: 6,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          iconBut
        ],
      ),
    );
  }
}
