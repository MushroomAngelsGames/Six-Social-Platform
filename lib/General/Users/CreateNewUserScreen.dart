
import 'package:Six/DataBase/BDFirebase.dart';
import 'package:Six/Objectos/User.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Const/ConstNames.dart';
import '../../Const/ConstStyle.dart';
import '../../Icons/logo_icons.dart';
import '../../Models/GetElevatedButton.dart';
import '../../Models/NewAppBar.dart';
import '../../Models/Statics.dart';
import '../../Services/AuthService.dart';



class CreateNewUserScreen extends StatefulWidget {
  const CreateNewUserScreen({Key? key}) : super(key: key);

  @override
  State<CreateNewUserScreen> createState() => _CreateNewUserScreenState();
}

class _CreateNewUserScreenState extends State<CreateNewUserScreen> {
  bool isChecked = false;
  final TextEditingController nameUser = TextEditingController();
  final TextEditingController emailUser = TextEditingController();
  final TextEditingController keyCodeUser = TextEditingController();
  final TextEditingController checkKeyCodeUser = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool obscureKeycode = true;
  bool waitCreateUser = false;

  @override
  void dispose() {
    super.dispose();
    nameUser.dispose();
    emailUser.dispose();
    checkKeyCodeUser.dispose();
    keyCodeUser.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewAppbar().getAppBar(
          labelTopCreateNewUser, textStyleTopMenu, true,context,
          icon: Logo.logo, positionTextCenter: true,isFistScreen: true),
      body: _getBody(),
    );
  }

  ///Corpo Principal
  _getBody() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: waitCreateUser ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: getModelDetails(labelWaitCreateNewUser, '', '', Icons.waving_hand, Colors.black54, 65,secondIcon:
            const CircularProgressIndicator(),forceSizeText: 10,titleAlign: Alignment.centerLeft,useBorder: true))
            : SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Form(
                key: formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      getModelDetails(labelTitlePageCreateNewUser, "", "", Icons.people_alt, Colors.black54, 65,forceSizeText: 12,titleAlign:Alignment.centerLeft ),
                      const SizedBox(height: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                            child: TextFormField(
                              style: textStyleInputs,
                              controller: nameUser,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: labelHelpInputNameUserNewUser,
                              ),
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return labelErrorNameCreateNewUser;
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                            child: TextFormField(
                              style: textStyleInputs,
                              controller: emailUser,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: labelHelpInputEmailCreateNewUser,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return labelErrorEmail;
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 24.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.7,
                                  child: TextFormField(
                                    style: textStyleInputs,
                                    controller: keyCodeUser,
                                    obscureText: obscureKeycode,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: labelHelpInputKeyCodeCreateNewUser,
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return labelErrorNoEditeKeyCode;
                                      } else if (value.length < 6) {
                                        return labelErrorLessKeyCode;
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                IconButton(onPressed: () {setState(() {
                                  obscureKeycode = !obscureKeycode;
                                });}, icon:  Icon(Icons.remove_red_eye_sharp,color: colorIconsMenu))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 24.0),
                            child: TextFormField(
                              style: textStyleInputs,
                              controller: checkKeyCodeUser,
                              obscureText: obscureKeycode,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: labelHelpInputCheckKeyCodeCreateNewUser,
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return labelErrorNoEditeKeyCode;
                                } else if (value.length < 6) {
                                  return labelErrorLessKeyCode;
                                }else if(keyCodeUser.text != checkKeyCodeUser.text){
                                  return labelErrorKeyCodeCreateNewUser;
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical:5),
                              child:  Row(
                                children: [
                                  Checkbox(
                                    checkColor: Colors.white,
                                   // fillColor: MaterialStateProperty.resolveWith(getColor),
                                    value: isChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isChecked = value!;
                                      });
                                    },
                                  ),
                                  TextButton(onPressed: () =>  openUrl('https://www.mushroomangelsgames.com/termos-de-serviço-six') , child:  const AutoSizeText(labelTermServices,minFontSize: 6,maxFontSize: 10,))
                                ],
                              )
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical:5),
                              child: GetElevatedButton(labelButCreateNewUser,() => _butCreateUser(),
                                  Icon(Icons.check, color: colorIconsMenu),buttonStyleButMenu
                              )),
                        ],
                      ),
                    ]
                ),
              ),
              Visibility(
                visible: MediaQuery.of(context).viewInsets.bottom == 0,
                child: const Padding(
                  padding: EdgeInsets.all(25),
                  child: AutoSizeText(version,minFontSize: 6,maxFontSize: 8,textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
        ),
    );
  }

  ///Criar User But
  _butCreateUser() async{
    GetElevatedButton.resetSound();

      if(formKey.currentState!.validate()){
        if(isChecked){
          setState(() {
            waitCreateUser = true;
          });
          if(await checkHasNet(context)) {
             if (await AuthService.createNewUser(emailUser.text, keyCodeUser.text)) {
               if(await DBFirebase.firebaseCreateUsers.setSaveNewUser(Users("",nameUser.text.toUpperCase().replaceAll(" ", "_").trim(), "", "", "", "",{},{}))) {
               getEffectsSuccess();
               Navigator.of(context, rootNavigator: true).pop();
               await AuthService.login(emailUser.text, keyCodeUser.text);
               return;
             }
           }

            setState(() {
              waitCreateUser = false;
            });
            return;
          }
        }else{
          forceErrorNoticeWithLegend(context,labelErrorCheckTermServiceCreateUser);
        }
      }else{
        forceErrorNoticeWithLegend(context,labelErrorFormCreateUser);
      }
  }

  _reset(){
    emailUser.clear();
    keyCodeUser.clear();
    checkKeyCodeUser.clear();
    nameUser.clear();
  }
  
}
