import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:privaap/components/button.dart';
import 'package:privaap/components/inputs/input.dart';
import 'package:privaap/components/modal.dart';
import 'package:privaap/main.dart';
import 'package:privaap/models/user_model.dart';
import 'package:privaap/providers/user_provider.dart';
import 'package:privaap/screens/pages/change_pwd.dart';
import 'package:privaap/services/auth_service.dart';
import 'package:privaap/services/push_notifications.dart';
import 'package:privaap/services/service_method.dart';
import 'package:privaap/services/services.dart';
import 'package:provider/provider.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController passwordRepeatCtrl = TextEditingController();
  bool hidePassword = true;
  bool hidePasswordRepeat = true;
  bool stateLoading = false;
  bool emailState = false;
  bool passwordState = false;
  bool passwordConfirmState = false;
  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
                // height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width * 0.6,
              )),
              SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      InputComponent(
                        textInputAction: TextInputAction.next,
                        controllerText: emailCtrl,
                        onEditingComplete: () => node.nextFocus(),
                        onChanged: (v) => changeInputs(),
                        keyboardType: TextInputType.emailAddress,
                        textCapitalization: TextCapitalization.none,
                        icon: Icons.email,
                        labelText: "Correo electrónico",
                        statecorrect: emailState,
                        validator: (value) {
                          if (value.isNotEmpty) {
                            if (value.contains(RegExp('@'), 0) || value.contains(RegExp('.com'), 0)) {
                              return null;
                            } else {
                              return 'El correo no es valido';
                            }
                          } else {
                            return 'Ingrese su correo';
                          }
                        },
                      ),
                      InputComponent(
                          textInputAction: TextInputAction.done,
                          controllerText: passwordCtrl,
                          onEditingComplete: () => formComplete(context),
                          onChanged: (v) => changeInputs(),
                          keyboardType: TextInputType.text,
                          icon: Icons.lock,
                          labelText: "Contraseña",
                          obscureText: hidePassword,
                          onTap: () => setState(() => hidePassword = !hidePassword),
                          iconOnTap: hidePassword ? Icons.lock_outline : Icons.lock_open_sharp,
                          statecorrect: passwordState,
                          validator: (value) {
                            if (value.isNotEmpty) {
                              if (value.length >= 6) {
                                return null;
                              } else {
                                return 'La contraseña debe ser de 6 carecteres o mas';
                              }
                            } else {
                              return 'Ingrese su contraseña';
                            }
                          }),
                      InputComponent(
                          textInputAction: TextInputAction.done,
                          controllerText: passwordRepeatCtrl,
                          onEditingComplete: () => formComplete(context),
                          onChanged: (v) => changeInputs(),
                          keyboardType: TextInputType.text,
                          icon: Icons.lock,
                          labelText: "Repita Contraseña",
                          obscureText: hidePasswordRepeat,
                          onTap: () => setState(() => hidePasswordRepeat = !hidePasswordRepeat),
                          iconOnTap: hidePasswordRepeat ? Icons.lock_outline : Icons.lock_open_sharp,
                          statecorrect: stateRepeatPassword(),
                          validator: (value) {
                            if (value == passwordCtrl.text) {
                              return null;
                            } else {
                              return 'No coincide la contraseña';
                            }
                          }),
                      if (!stateLoading)
                        ButtonComponent(text: 'Iniciar Sesión', onPressed: () => formComplete(context)),
                      if (!stateLoading)
                        ButtonComponent(isWhite: true, text: 'Olvide mi contraseña', onPressed: () => forgotPassword()),
                      if (stateLoading)
                        Center(
                            child: Image.asset(
                          'assets/gifs/load.gif',
                          fit: BoxFit.cover,
                          height: 20,
                        )),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('¿Aún no tienes una cuenta?'),
                          ButtonComponent(
                            isWhite: true,
                            text: 'Registrarme',
                            onPressed: () => Navigator.pushNamed(context, 'register'),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool stateRepeatPassword() {
    if (passwordRepeatCtrl.text == passwordCtrl.text && passwordRepeatCtrl.text.length >= 6) {
      return true;
    } else {
      return false;
    }
  }

  changeInputs() {
    debugPrint('passwordCtrl.text.length ${passwordCtrl.text.length}');
    if (emailCtrl.text == '' ||
        !emailCtrl.text.contains(RegExp('@'), 0) ||
        !emailCtrl.text.contains(RegExp('.com'), 0)) {
      setState(() => emailState = false);
    } else {
      setState(() => emailState = true);
    }
    if (passwordCtrl.text.length < 6) {
      setState(() => passwordState = false);
    } else {
      setState(() => passwordState = true);
    }
  }

  formComplete(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userData = Provider.of<UserData>(context, listen: false);
    if (formKey.currentState!.validate()) {
      setState(() => stateLoading = true);
      if (!await checkVersion(context)) return setState(() => stateLoading = false);
      final Map<String, String> body = {
        "email": emailCtrl.text.trim(),
        "password": passwordCtrl.text.trim(),
        "tk_notification": await PushNotificationService.getTokenFirebase()
      };
      if (!mounted) return;
      final response = await serviceMethod(context, 'post', body, serviceAuthSession(), false);
      setState(() => stateLoading = false);
      if (response != null) {
        await authService.loginCustomer(response.data['token']);
        await userData.updateUserData(userModelFromJson(json.encode(response.data['user']))!);
        prefs!.setString('user', json.encode(response.data['user']));
        prefs!.setString('groups', '');
        if (!mounted) return;
        Navigator.pushNamed(context, 'loading');
      }
    }
  }

  forgotPassword() async {
    final sizeScreenModal = Provider.of<SizeScreenModal>(context, listen: false);
    sizeScreenModal.updateSizeScreen(2);
    return showBarModalBottomSheet(
      enableDrag: false,
      expand: false,
      context: context,
      builder: (context) => const ModalComponent(
        title: 'Olvidé mi contraseña :(',
        child: ChangePassword(),
      ),
    );
  }
}
