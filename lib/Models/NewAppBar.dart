import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../Const/ConstNames.dart';
import '../Const/ConstStyle.dart';

class NewAppbar {

   late BuildContext _buildContext;
   final _playerSound = AudioCache();

   /// Recupear Logo do App.
   AppBar getAppBar(String name, TextStyle styleMenu, bool isNeedReturn,BuildContext context,{IconData? icon, Color? backgroundColorData, bool? positionTextCenter,bool? isFistScreen}) {
    _buildContext = context;
    return AppBar(
      elevation: 50,
      title:AutoSizeText(name,minFontSize: 10,maxFontSize: 16,textAlign: TextAlign.center),
      actions: [
        isNeedReturn ? const SizedBox(width: 25) : const SizedBox(width: 60),
        isNeedReturn ?  _getIconHas(icon) : _getIconHasDrawer(isFistScreen)],
      leading:  isNeedReturn ?  _getNeedReturn(isNeedReturn) : _getIconHas(icon) ,
      backgroundColor: backgroundColorData,
      centerTitle: positionTextCenter ?? false,
    );
  }

  ///Recupear Icone que Deve ser Usado.
   Widget _getIconHas(IconData? iconValue) {
    if (iconValue != null) {
      return Icon(iconValue, color: colorIconsMenu, size: 55);
    } else {
      return Image.asset("assets/app/icon-android.png",color: colorIconsMenu,width: 65,height: 65,);
      return Icon(Icons.account_balance, color: colorIconsMenu, size: 30);
    }
  }

  ///Recupear Icone ou Menu.
   Widget _getIconHasDrawer(bool? isFistScreen) {
     return const SizedBox();
     if(isFistScreen != null){
       if(isFistScreen){
         return const SizedBox();
       }
     }

    /* return PopupMenuButton<Widget>(
       elevation: 50,
       color: const Color(0xFF212121),
       icon: Icon(Icons.menu,color: colorIconsMenu,size: 35),
         // Callback that sets the selected popup menu item.
           itemBuilder: (BuildContext context) => [
             PopupMenuItem(
               enabled: false,
               child: Center(child: ClipOval(
                 child: Container(
                       width: 100,
                       height:  100,
                       child:SizedBox(
                           width: 100,
                           height:  100,
                           child: CachedNetworkImage(
                             fit: BoxFit.contain,
                             imageUrl:DBFirestore.getPersonImageStorage().userLogin.iconPerson,
                             placeholder: (context, url) => const CircularProgressIndicator(),
                             errorWidget: (context, url, error)  {
                               return  CircleAvatar(
                                   backgroundColor: Colors.white,
                                   radius : 500,
                                   child: ClipOval(
                                     child: Image.asset(imageError),
                                   ));},
                             imageBuilder: (context, image) => CircleAvatar(
                               backgroundImage: image,
                               backgroundColor: Colors.white,
                               maxRadius: 500,
                             ),
                           ),
                       )
                 ),
               ))
             ),
             PopupMenuItem(
               textStyle: const_style.TextStyleMenuBack,
               child: Center(child: Text(DBFirestore.getPersonImageStorage().userLogin.namePerson),)
             ),
             PopupMenuItem(
                 child: Center(child: Text(DBFirestore.getPersonImageStorage().userLogin.officePerson),)
             ),
             PopupMenuItem(
                 child: Center(child:IconButton(onPressed: (){
                   Navigator.of(context).pop();
                   setNavigatorTransition(context, CreateNewOffice(person: DBFirestore.getPersonImageStorage().userLogin));
                 }, icon: Icon(Icons.edit_rounded,color: const_style.ColorIconsMenu)),)
             ),
           ]);*/

   }

   ///Gerar Botao de Retorno quando For Necessario.
   Widget _getNeedReturn(bool isNeedReturn) {
    if (isNeedReturn) {
      return IconButton(
          onPressed: () =>
               _popAndPush(),
          icon: const Icon(
            Icons.arrow_back,
            size: 25,
            color: Colors.white,
          ));
    } else {
      return Container();
    }
  }

  ///Fechar Tela Atual e Retornar.
   _popAndPush(){
    _playerSound.play(nameClipBut, isNotification: true, volume: 0.5);
    Navigator.of(_buildContext).maybePop();
  }

}
