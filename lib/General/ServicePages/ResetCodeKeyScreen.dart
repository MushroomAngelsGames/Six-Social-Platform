import 'package:Six/Init/InitApp.dart';
import 'package:Six/Models/GetElevatedButton.dart';
import 'package:Six/Services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Const/ConstNames.dart';
import '../../Const/ConstStyle.dart';
import '../../Init/App_Settigs.dart';
import '../../Models/NewAppBar.dart';
import '../../Models/Statics.dart';
import '../AutenticacaoPage.dart';

class ResetCodeKeyScreen extends StatefulWidget {
  const ResetCodeKeyScreen({Key? key}) : super(key: key);

  @override
  State<ResetCodeKeyScreen> createState() => _ResetCodeKeyScreenState();
}

class _ResetCodeKeyScreenState extends State<ResetCodeKeyScreen> {
  final formKey = GlobalKey<FormState>();
  //final formKeyCode = GlobalKey<FormState>();
  TextEditingController labelEmail = TextEditingController();
  //TextEditingController labelCodeKey = TextEditingController();

  @override
  void initState() {
    labelEmail.text = AutenticacaoPage.buildContextLogin
        .watch<AppSettings>()
        .configString['User']!;
    super.initState();
  }

  @override
  void dispose() {
    labelEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewAppbar().getAppBar(
          labelResetKeyScreenTopMenu, textStyleTopMenu, true, context,
          positionTextCenter: true, isFistScreen: true),
      body: _getBody(),
    );
  }

  _getBody() {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 0),
          child: Column(
            children: [
              getModelDetails(labelTitlePageResetKeyScreen, "", "", Icons.reset_tv_sharp, Colors.black54, 65,forceSizeText: 12,titleAlign:Alignment.centerLeft ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 8.0),
                child: TextFormField(
                  style: textStyleInputs,
                  controller: labelEmail,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: labelHelpInputEmail,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return labelEmailInvalidResetKeyScreen;
                    } else if (value.length < 6) {
                      return labelEmailInvalidResetKeyScreen;
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GetElevatedButton(labelButSendCodeResetKeyScreenTopMenu,() => _openMenuWaitCodeEmail(),
                    Icon(Icons.check, color: colorIconsMenu),buttonStyleButMenu
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _openMenuWaitCodeEmail(){
    AuthService.sendPasswordResetEmail(labelEmail.text);
    GetElevatedButton.resetSound();
    Navigator.of(context,rootNavigator: true).pop();
    forceNoticeWithLegend(navigatorKey.currentContext!,labelCodeMessageResetKeyScreen);
    /*setAlertNowWithWidget(context, AlertType.warning, labelCodeTitlePageResetKeyScreen, labelCodeMessageResetKeyScreen, [
      SizedBox(
        width: wightApp * 5,
        child: SingleChildScrollView(
          child: Form(
            key: formKeyCode,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 8.0),
                    child: TextFormField(
                      style: textStyleInputs,
                      controller: labelCodeKey,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: labelHelpCodeResetResetKeyScreen,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return labelEmailInvalidResetKeyScreen;
                        } else if (value.length < 6) {
                          return labelEmailInvalidResetKeyScreen;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 5),
                    child: GetElevatedButton(labelButCheckCodeResetKeyScreen,() {},
                        Icon(Icons.check, color: colorIconsMenu),buttonStyleButMenu
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: GetElevatedButton(labelCancel,() {GetElevatedButton.resetSound(); Navigator.of(context,rootNavigator: true).pop();},
                        Icon(Icons.cancel, color: colorIconsMenu),buttonStyleButMenu
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      )
    ]);*/
  }

}
