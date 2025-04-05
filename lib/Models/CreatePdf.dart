import 'dart:io';
import 'dart:typed_data';
import 'package:Six/Init/InitApp.dart';
import 'package:Six/Models/Statics.dart';
import 'package:Six/Objectos/AudioMap.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart' as pdfValues;
import 'package:pdf/widgets.dart' as pdfLib;

import '../Const/ConstNames.dart';

class CreatePdf{

  var isLoadingPdf = false.obs;

  late var ttf;
  late var title;
  late var cellStyle;
  late var headerStyle;
  late var oldStyle;
  late var textJust;

  late Uint8List fontData;
  late File file;

  ///Inicializar Fotes para Pdf.
  _font() async{
    Uint8List fontData = (await rootBundle.load('assets/OpenSans-Regular.ttf')).buffer.asUint8List();
    ttf = pdfLib.Font.ttf(fontData.buffer.asByteData());
    cellStyle =  pdfLib.TextStyle(font:ttf,fontSize: 8,fontWeight: pdfLib.FontWeight.bold);
    headerStyle = pdfLib.TextStyle(font:ttf,fontSize: 10);
    textJust =  pdfLib.TextStyle(font:ttf,fontSize: 8,fontWeight: pdfLib.FontWeight.bold);
    oldStyle  = pdfLib.TextStyle(font:ttf,fontSize: 8,);
    title = pdfLib.TextStyle(font:ttf,fontSize: 12,fontWeight: pdfLib.FontWeight.bold);
  }

  ///Recuperar Nome Para Pdf.
  String getName(String pdfName) =>'${pdfName.replaceAll("/", "")}.pdf';

  ///Recuperar Logo do App Para Pdf.
  Future<pdfLib.MemoryImage> _readImageData(String name) async {
    var assetImage = pdfLib.MemoryImage(
      (await rootBundle.load('assets/app/$name'))
          .buffer
          .asUint8List(),
    );
    return assetImage;
  }

  ///Salvar na Memoria o Pdf.
  Future<String> saveAndGeneratorScreen(String pdfName, pdfLib.Document pdf) async {
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/$pdfName';

    file = File(path);
    file.writeAsBytesSync(await pdf.save());
    return path;
  }

  ///Gerar Roda com Logo da Mushroom para Pdf.
  Future<pdfLib.Widget> getFootPage() async{
    var iconLogoMushroom = await _readImageData('mushroom-angels-games-icone.png');
    var styleType = pdfLib.TextStyle(color: pdfValues.PdfColor.fromHex("#000000"),font:ttf , fontSize: 10);

    return
      pdfLib.Column(
          children : [
            pdfLib.LinearProgressIndicator(value:1 ,valueColor: pdfValues.PdfColor.fromHex("#000000"),minHeight: 1),
            pdfLib.SizedBox(height: 10),
            pdfLib.Row(
                children: [
                  pdfLib.SizedBox(child: pdfLib.Image(iconLogoMushroom,width: 25,height: 25)),
                  pdfLib.SizedBox(width: 5),
                  pdfLib.SizedBox(width: 450,
                    child: pdfLib.Row(
                        mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                        children: [
                          pdfLib.Text('Mushroom Angels Games',style: styleType ),
                          pdfLib.Text('https://www.mushroomangelsgames.com',style: styleType )
                        ]),),
                ]),
            pdfLib.SizedBox(height: 10),
            pdfLib.LinearProgressIndicator(value:1 ,valueColor: pdfValues.PdfColor.fromHex("#000000"),minHeight: 1),
          ]);
  }

  ///Logo Bruna Semijoias e Site.
  Future<pdfLib.Widget> getIconPdf() async{
    var imageLogoBruna = await _readImageData('six.png');
    var styleType = pdfLib.TextStyle(color: pdfValues.PdfColor.fromHex("#0D0D0D"),font:ttf , fontSize: 10);
    return
      pdfLib.Column(
          mainAxisAlignment: pdfLib.MainAxisAlignment.start,
          children: [
            pdfLib.Row(
                mainAxisAlignment: pdfLib.MainAxisAlignment.start,
                children: [
                  pdfLib.Image(imageLogoBruna,width: 85,height: 85 ),
                  pdfLib.SizedBox(width: 25),
                  pdfLib.Text('SIX - Facilitando os Estudos',style: title),
                ]),
            pdfLib.Align( child:pdfLib.Text('https://mushroomangelsgames.com',style: styleType),alignment: pdfLib.Alignment.topRight),
            pdfLib.LinearProgressIndicator(value:1 ,valueColor: pdfValues.PdfColor.fromHex("#000000"),minHeight: 1),
            pdfLib.SizedBox(height: 15),
          ]);
  }

  ///Gerar Pdf 
  createPdfData(AudioMap audioMap) async {

    isLoadingPdf.value = true;
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);

    await _font();

      var footPage = await getFootPage();
      var appBarApp = await getIconPdf();

      //var decorationBox = pdfLib.BoxDecoration(color: pdfValues.PdfColor.fromHex("#A7A7A7"));


    try {
      pdf.addPage(
          pdfLib.MultiPage(
              header:(c)  {
                if(c.pageNumber == 1){
                  return appBarApp;
                }
                return pdfLib.SizedBox();
              },

              footer: (c) {
                if(c.pageNumber == c.pagesCount){
                  return footPage;
                }
                return pdfLib.SizedBox();
              },

              maxPages: 50000000,
              pageFormat: pdfValues.PdfPageFormat.a4,
              build: (context) =>
              [

                pdfLib.SizedBox(height: 5),
                pdfLib.Header(level: 1,text: audioMap.nameSave),
                pdfLib.LinearProgressIndicator(value:1 ,valueColor: pdfValues.PdfColor.fromHex("#000000"),minHeight: 1),
                pdfLib.SizedBox(height: 5),
                pdfLib.Paragraph(text: audioMap.audioToText,style: textJust,textAlign: pdfLib.TextAlign.justify),
                pdfLib.SizedBox(height: 15),
                pdfLib.LinearProgressIndicator(value:1 ,valueColor: pdfValues.PdfColor.fromHex("#000000"),minHeight: 1),
                pdfLib.SizedBox(height: 5),
              ]
          ));

      String nameUse = getName(audioMap.getNameToSave());
      String path = await saveAndGeneratorScreen(nameUse, pdf);
      isLoadingPdf.value = false;
      OpenFile.open(path);

    }catch(e)
    {
      forceErrorNoticeWithLegend(navigatorKey.currentContext!, labelErrorPdf);
      isLoadingPdf.value = false;
    }
  }
}