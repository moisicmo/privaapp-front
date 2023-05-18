import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:privaap/components/headers.dart';
import 'package:privaap/main.dart';
import 'package:privaap/models/user_model.dart';
import 'package:privaap/providers/user_provider.dart';
import 'package:privaap/screens/register/step01.dart';
import 'package:privaap/screens/register/step02.dart';
import 'package:privaap/screens/register/step03.dart';
import 'package:privaap/services/auth_service.dart';
import 'package:privaap/services/push_notifications.dart';
import 'package:privaap/services/service_method.dart';
import 'package:privaap/services/services.dart';
import 'package:privaap/utils/save_image_divice.dart';
import 'package:provider/provider.dart';

class ScreenRegister extends StatefulWidget {
  const ScreenRegister({super.key});

  @override
  State<ScreenRegister> createState() => _ScreenRegisterState();
}

class _ScreenRegisterState extends State<ScreenRegister> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController lastNameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController passwordRepeatCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController codeCtrl = TextEditingController();
  File? imageFile;
  String dateCtrl = '';
  String? stateCivilCtrl;
  String? genderCtrl;
  int steps = 1;
  bool hidePassword = true;
  bool sendCode = false;
  bool stateLoading = false;
  int idUser = 0;
  String textTitle = 'Registrate';
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          body: Center(
            child: Column(
              children: [
                HedersComponent(title: textTitle),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Text(
                        //   textTitle,
                        //   style: const TextStyle(fontSize: 30),
                        // ),
                        SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          child: Column(
                            children: [
                              if (steps == 1)
                                StepRegister01(
                                  nameCtrl: nameCtrl,
                                  lastNameCtrl: lastNameCtrl,
                                  emailCtrl: emailCtrl,
                                  passwordCtrl: passwordCtrl,
                                  passwordRepeatCtrl: passwordRepeatCtrl,
                                  complete: () => setState(() => steps = 2),
                                  imageFile: imageFile,
                                  changeImage: (File file) => setState(() => imageFile = file),
                                ),
                              if (steps == 2)
                                StepRegister02(
                                    phoneCtrl: phoneCtrl,
                                    codeCtrl: codeCtrl,
                                    emailCtrl: emailCtrl,
                                    methodSendCode: () => sendData(),
                                    methodValidate: () => verifyUser(),
                                    dateCtrl: (value) => setState(() => dateCtrl = value),
                                    stateCivilCtrl: (value) => setState(() => stateCivilCtrl = value),
                                    genderCtrl: (value) => setState(() => genderCtrl = value),
                                    stateCivil: stateCivilCtrl,
                                    gender: genderCtrl,
                                    date: dateCtrl,
                                    sendCode: sendCode,
                                    stateLoading: stateLoading),
                              if (steps == 3) StepRegister03(methodcontinue: () => connectSocket())
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  connectSocket() {
    Navigator.pushNamed(context, 'loading');
  }

  Future<bool> _onBackPressed() async {
    if (steps == 1) return true;
    if (steps == 2) {
      setState(() => steps = 1);
      return false;
    } else {
      return true;
    }
    // return await showDialog(
    //     barrierDismissible: false,
    //     context: context,
    //     builder: (BuildContext context) {
    //       return FadeIn(
    //           child: DialogTwoAction(
    //               message: '¿Estás seguro de salir de la aplicación PRIVAAP?',
    //               actionCorrect: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
    //               messageCorrect: 'Salir'));
    //     });
  }

  sendData() async {
    setState(() {
      sendCode = false;
      stateLoading = true;
    });
    final Map<String, String> body = {
      "name": nameCtrl.text.trim(),
      "last_name": lastNameCtrl.text.trim(),
      "email": emailCtrl.text.trim(),
      "phone": phoneCtrl.text.trim(),
      "gender": genderCtrl!,
      "password": passwordCtrl.text.trim()
    };
    final response = await serviceMethod(context, 'post', body, serviceRegister(), false);
    setState(() => stateLoading = false);
    if (response != null) {
      setState(() {
        sendCode = true;
        idUser = response.data['user']['id'];
      });
    }
  }

  verifyUser() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userData = Provider.of<UserData>(context, listen: false);
    setState(() => stateLoading = true);
    Map<String, dynamic> body;
    if (imageFile != null) {
      // String nameImageCover = await saveImage(imageFile!);
      String image = base64Encode(await imageFile!.readAsBytes());
      // final Map<String, dynamic> body = {'archivo': image};
      body = {
        'code': codeCtrl.text.trim(),
        'tk_notification': await PushNotificationService.getTokenFirebase(),
        'archivo': image
      };
    } else {
      body = {
        'code': codeCtrl.text.trim(),
        'tk_notification': await PushNotificationService.getTokenFirebase(),
        'archivo': null
      };
    }
    if (!mounted) return;
    final response = await serviceMethod(context, 'post', body, serviceVerifyUser(idUser), false);
    setState(() => stateLoading = false);
    debugPrint('response $response');
    if (response != null) {
      await authService.loginCustomer(response.data['token']);
      await userData.updateUserData(userModelFromJson(json.encode(response.data['user']))!);
      prefs!.setString('user', json.encode(response.data['user']));
      prefs!.setString('groups', '');
      setState(() {
        steps = 3;
        textTitle = 'Bienvenido(a)';
      });
    }
  }
}
