import 'package:Six/General/ServicePages/ResetCodeKeyScreen.dart';
import 'package:Six/Services/AuthService.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import '../Const/ConstNames.dart';
import '../Const/ConstStyle.dart';
import '../Init/App_Settigs.dart';
import '../Models/GetElevatedButton.dart';
import '../Models/NewAppBar.dart';
import '../Models/Statics.dart';
import '../Services/AutenticacaoController.dart';
import 'Users/CreateNewUserScreen.dart';


class AutenticacaoPage extends StatefulWidget {

  static late BuildContext buildContextLogin;

  AutenticacaoPage({Key? key}) : super(key: key);

  @override
  State<AutenticacaoPage> createState() => _AutenticacaoPageState();
}

class _AutenticacaoPageState extends State<AutenticacaoPage> {
  final AutenticacaoController controller = Get.put(AutenticacaoController());
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  late String keycode = '';
  bool obscureKeycode = true;

  ///Inicializar Biometria.
  _authenticate() async{
    if(await _isBiometricAvailable()){
      await _getListOfBiometricTypes();
      await _authenticateUser();
    }
  }

  ///Vericiar Tipo de Biometria.
  Future<bool> _isBiometricAvailable() async{
    try {
      bool isAvailable = await _localAuthentication.canCheckBiometrics;
      return isAvailable;
    }catch(e){
      return false;
    }
  }

  ///Recuperar Lista de Biometrias.
  Future<void> _getListOfBiometricTypes() async{
    try {
      List<BiometricType> listOfBiometrics = await _localAuthentication.getAvailableBiometrics();
    }catch(e){
    }
  }

  ///Realizar Autinticação.
  Future<void> _authenticateUser() async{
    try {
    if(await _localAuthentication.isDeviceSupported()) {
     if (await _localAuthentication.authenticate(
         localizedReason: 'USE A DIGITAL PARA LOGAR NO SISTEMA',
         options: const AuthenticationOptions(
             stickyAuth: true
         ))) {
       controller.keycode.text = keycode;
       controller.login();
     }
   }
    }catch(e){
    }
  }

  ///Construtor.
  @override
  Widget build(BuildContext context) {
    AutenticacaoPage.buildContextLogin = context;
    _loadEmail();

    return Scaffold(
      appBar: NewAppbar().getAppBar(
          appName, textStyleTopMenu, false,context, positionTextCenter: true,isFistScreen: true),
      body: getBody(),
    );
  }

  ///Corpo.
  Widget getBody() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Obx(
        () => controller.isLoading.value
            ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: getModelDetails(labelWaitLoginDataBase, '', '', Icons.waving_hand, Colors.black54, 65,secondIcon:
            const CircularProgressIndicator(),forceSizeText: 10,titleAlign: Alignment.centerLeft,useBorder: true))
            : SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Form(
                      key: controller.formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 150,
                            width: double.maxFinite,
                            child: Card(
                                color: const Color(0XFFA80300),
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Image.asset(imageAppFirst),
                                )),
                          ),
                          const SizedBox(height: 20),
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                                child: TextFormField(
                                  style: textStyleInputs,
                                  controller: controller.email,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: labelHelpInputEmail,
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
                                    vertical: 0.0, horizontal: 24.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.7,
                                      child: TextFormField(
                                        style: textStyleInputs,
                                        controller: controller.keycode,
                                        obscureText: obscureKeycode,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: labelHelpInputKeyCode,
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
                              Visibility(
                                  visible: AuthService.errorLogin,
                                  child: TextButton(onPressed: () => _openResetKeyCode() , child:  const AutoSizeText(labelForgetCodeKey,minFontSize: 4,maxFontSize: 6,))),
                             Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 5),
                               child: GetElevatedButton(controller.buttonFirst.value.toString(),() => _eventClick(),
                                   Icon(Icons.check, color: colorIconsMenu),buttonStyleButMenu
                               ),
                             ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 0),
                                  child: GetElevatedButton(labelButCreateAccount,() =>   _createNewUser(),
                                      Icon(Icons.new_label_sharp, color: colorIconsMenu),buttonStyleButMenu
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
      ),
    );
  }

  ///Ler dados de Login Salvos na Memoria.
  _readProviderDataLogin()  {
    controller.email.text = AutenticacaoPage.buildContextLogin.watch<AppSettings>().configString['User']!;
    keycode  = AutenticacaoPage.buildContextLogin.watch<AppSettings>().configString['key'] ?? '';
    if(controller.email.text.isNotEmpty){
      _authenticate();
    }
  }

  ///Salvar dados da menoria.
  _alterAndSaveEmailUsed() => AutenticacaoPage.buildContextLogin.read<AppSettings>().setLocale(controller.email.text,controller.keycode.text);

  ///Buscar Email Salvo.
  _loadEmail() async{
    if(controller.email.text.isEmpty) {
      _readProviderDataLogin();
    }
  }

  ///Ir Criar Novo Urser
  _createNewUser(){
    GetElevatedButton.resetSound();
    setNavigatorTransition(context, const CreateNewUserScreen());
  }

  ///Validar Login.
  _eventClick(){
    GetElevatedButton.resetSound();
    if (controller.formKey.currentState!.validate()) {
      if (controller.isLogin.value) {
        _alterAndSaveEmailUsed();
        controller.login();
      }
    }
  }

  ///Validar Login.
  _openResetKeyCode(){
    GetElevatedButton.resetSound();
    setNavigatorTransition(context, const ResetCodeKeyScreen());
  }


}
