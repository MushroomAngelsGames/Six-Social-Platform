import 'package:Six/Init/InitApp.dart';
import 'package:Six/Models/GetElevatedButton.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';
import '../Const/ConstNames.dart';
import '../Const/ConstStyle.dart';
import '../Objectos/FileAudioMap.dart';

double heightApp = MediaQuery.of(navigatorKey.currentContext!).size.width;
double wightApp = MediaQuery.of(navigatorKey.currentContext!).size.width;



final player = AudioCache();

enum TypeFind{
  data,
  name,
}

///enum definir erro
enum AlertType { error, success, info, warning, none }

///Verificar se tem Internete sem Aviso.
Future<bool> checkHasNetNotContext()async{
  if(await InternetConnectionChecker().hasConnection == false){
    return false;
  }
  return true;
}

///Verificar se tem Internete e Avisar.
checkHasNetAll(BuildContext context) async{
  await checkHasNet(context);
}

///Avisar Não tem Internete.
Future<bool> checkHasNet(BuildContext context)async{
  if(await InternetConnectionChecker().hasConnection == false)
  {
    // ignore: use_build_context_synchronously
    setAlertNow(context, AlertType.error, labelNoHasNet, labelNoHasNetDescription,
        [
          GetElevatedButton(nameOk, () {Navigator.of(context,rootNavigator: true).pop();}, Icon(Icons.check_box,color: colorIconsMenu,size: 25), buttonStyleButMenu)
        ]);
    return false;
  }
  return true;

}

///Gerar Alerta Sem Menu.
setAlertNow(BuildContext context,AlertType type,String title,String description,List<GetElevatedButton>  buttons,{Icon? icon}){
  _getEffectsError(type);
  showDialog<void>(
    useSafeArea : false,
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: const BorderSide(
            width: 1,
            color: Colors.blueAccent,
          ),
        ),
        icon: icon ?? const SizedBox(),
        title: Column(
          children: [
            Text(title,style: textStyleRed,textAlign: TextAlign.center),
            Visibility(
                visible: description.isNotEmpty,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(description,style: textStyleInputs,textAlign: TextAlign.justify),
                  ],
                )),
          ],
        ),
        scrollable:true,
        actions:buttons,
      );
    },
  );
}

setAlertNowWithWidget(BuildContext context,AlertType type,String title,String description, List<Widget>? widget,{Icon? icon}){
  _getEffectsError(type);
  showDialog<void>(
    useSafeArea : false,
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: const BorderSide(
            width: 1,
            color: Colors.blueAccent,
          ),
        ),
        icon: icon ?? const SizedBox(),
        title: Column(
          children: [
            Text(title,style: textStyleRed,textAlign: TextAlign.center),
            Visibility(
                visible: description.isNotEmpty,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(description,style: textStyleInputs,textAlign: TextAlign.justify),
                  ],
                )),
          ],
        ),
        scrollable:true,
        actions: widget,
      );
    },
  );
}

///Gerar Efeitos dos tipos de Alerta.
_getEffectsError(AlertType type){

  switch(type){
    case AlertType.error:
      player.play(nameClipError,isNotification: true);
      break;
    case AlertType.info:
      player.play(nameClipInfo,isNotification: true,volume: 0.75);
      break;
    case AlertType.warning:
      player.play(nameClipWarning,isNotification: true,volume: 0.5);
      break;
    case AlertType.success:
      player.play(nameClipSuccess,isNotification: true,volume: 0.75);
      break;
  }


  Vibration.vibrate(duration: 300);
}

///Abrir Termos de Serviço
openUrl(String link) async {
  if (!await launch(link)) {
    forceErrorNoticeWithLegend(navigatorKey.currentContext!, labelErrorOpenTermService);
  }
}

///Gerar Efeito de Sucesso.
getEffectsSuccess(){
  player.play(nameClipCodeBar,isNotification: true);
  Vibration.vibrate(duration: 250);
}

///Gerar Efeito de Sucesso.
getEffectsListening(){
  player.play(nameClipSuccess,isNotification: true);
  Vibration.vibrate(duration: 250);
}

///Realizar Transição entre Telas.
setNavigatorTransition(BuildContext context, Widget router) {
  Navigator.push(context, MaterialPageRoute(builder: (e) => router));
}

///Gerar Aviso de Erro com Legenda.
forceErrorNoticeWithLegend(BuildContext context,String nameError){
  setAlertNow(
      context,
      AlertType.error,
      labelErrorForce,
      nameError,
      <GetElevatedButton>[
        GetElevatedButton(nameOk,() {
          Navigator.of(context, rootNavigator: true).pop();
        }, const Icon(Icons.check_box,color: Colors.red,size: 25,),buttonStyleButMenu)
      ],
      icon: const Icon(Icons.error_outline,color: Colors.red,size: 150,)
  );
}


///Gerar Aviso de Erro com Legenda.
forceNoticeWithLegend(BuildContext context,String legend){
  setAlertNow(
      context,
      AlertType.success,
      labelAttention,
      legend,
      <GetElevatedButton>[
        GetElevatedButton(nameOk,() {
          Navigator.of(context, rootNavigator: true).pop();
        }, const Icon(Icons.check_box,color: Colors.green,size: 25,),buttonStyleButMenu)
      ],
  );
}

///Adcionar 0 a uma string
String _addZero(String value){
  if (value.length == 1) {
    value = '0$value';
  }
  return value;
}

///time format
String getDateTimeWithSeconds(DateTime time) {
  String moth = time.month.toString();
  String day = time.day.toString();
  String times = "${time.hour}h:${time.minute}m:${time.second}s";
  return  '${_addZero(day)}/${_addZero(moth)}/${time.year} às $times';
}


DateTime getFormatDateTime(String dateTime){
  try{
    dateTime = dateTime.replaceRange(10, null,"");
    List<String> dateTimeStart = dateTime.split('/');
    dateTime = '${dateTimeStart[2]}-${dateTimeStart[1]}-${dateTimeStart[0]}';
    return DateTime.parse(dateTime);
  }catch(e){
    return DateTime.now();
  }
}


///Gerar POP Perguntado se pode Fechar a tela.
Future<bool?> showWillPopAlert(BuildContext context,String title,String butStay,butExit) {
  return showDialog(
      context: context,
      builder: (cont) {
        return AlertDialog(
          title: SizedBox(width: MediaQuery.of(context).size.width, height:  MediaQuery.of(context).size.height * 0.1,
              child: AutoSizeText(title, minFontSize: 8,maxFontSize: 14,style: textStyleRed)),
          actions: [
            SizedBox(width: MediaQuery.of(context).size.width, height:  MediaQuery.of(context).size.height * 0.08, child :
            GetElevatedButton(butExit, () => Navigator.of(context,rootNavigator: true).pop(true), const Icon(Icons.close), buttonStyleButMenu)),
            const SizedBox(height: 5),
            SizedBox(width: MediaQuery.of(context).size.width, height:  MediaQuery.of(context).size.height * 0.08, child :
            GetElevatedButton(butStay, () => Navigator.of(context,rootNavigator: true).pop(false), const Icon(Icons.check), buttonStyleButMenu))
          ],
        );
      }
  );
}


///Gerar Image;
Future<bool?> showImageItemFull(BuildContext context,String url) {
  return showDialog(
      context: context,
      builder: (cont) {
        return AlertDialog(
          title: getImage(context,url),
          actions: [
            SizedBox(width: MediaQuery.of(context).size.width, height:  MediaQuery.of(context).size.height * 0.08, child :
            GetElevatedButton('FECHAR', () => Navigator.of(context,rootNavigator: true).pop(false), const Icon(Icons.check), buttonStyleButMenu)),
          ],
        );
      }
  );
}


List<FileAudioMap> getListFileAudioMapSequence(List<FileAudioMap> list,TypeFind typeFind){
  List<FileAudioMap> temp = List.from(list);
  switch(typeFind) {
    case TypeFind.data:
      temp.sort((a, b) => getFormatDateTime(b.audioMap.dateCreate).compareTo(
              getFormatDateTime(a.audioMap.dateCreate)));
      break;
    case TypeFind.name:
      temp.sort((a, b) => b.audioMap.nameSave.compareTo(a.audioMap.nameSave));
      break;
  }

  return temp;
}


///Recuperar Image de Peças.
Widget getImage(BuildContext context, String url){
  return Visibility(
    visible: url.isNotEmpty,
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.25,
      color: Colors.white10,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: CachedNetworkImage(
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.contain,
                  colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.colorBurn)),
            ),
          ),
          imageUrl: url,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error)  {
            return  CircleAvatar(
                backgroundColor: Colors.white,
                radius : 500,
                child: ClipOval(
                  child: Image.asset(imageError),
                ));},
        ),
      ),
    ),
  );
}


Widget getModelDetails(String title, String value,String subtitle, IconData icon,Color color,double heightValue,{bool useBorder = false,TextStyle? firstColor ,Alignment? titleAlign,TextStyle? corSecond,double? forceSizeText,Widget ? secondIcon,bool? treeLine,Widget ? firstIcon}){
  return Container(
    height: heightValue,
    color: !useBorder? color: null,
    decoration: !useBorder ? null: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.blueAccent),
        color: color
    ),
    child: ListTile(
      minVerticalPadding: 0,
      isThreeLine: treeLine ?? true,
      subtitle: AutoSizeText(subtitle, style: textStyleValueSale,minFontSize: forceSizeText ?? 4,maxFontSize: forceSizeText ?? 8,),
      leading:firstIcon ??  Icon(icon,size: 30,color: colorIconsMenu),
      trailing: secondIcon ?? AutoSizeText(value, style: corSecond ?? textStyleValueSale,minFontSize: forceSizeText ?? 4,maxFontSize:  forceSizeText ?? 10,),
      title: titleAlign == null?
      AutoSizeText(title, style:firstColor?? textStyleNameItem,minFontSize:forceSizeText ?? 4,maxFontSize: forceSizeText ?? 8,):
      Align(alignment: titleAlign,child:AutoSizeText(title, style:firstColor?? textStyleNameItem,minFontSize:forceSizeText ?? 4,maxFontSize: forceSizeText ?? 8,),),
    ),
  );



}
