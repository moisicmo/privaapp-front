import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:privaap/components/button.dart';
import 'package:privaap/components/gif_loading.dart';
import 'package:privaap/components/inputs/input.dart';
import 'package:privaap/providers/user_provider.dart';
import 'package:privaap/services/service_method.dart';
import 'package:privaap/services/services.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  final bool stateEmail;
  const ChangePassword({super.key, this.stateEmail = false});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController passwordRepeatCtrl = TextEditingController();
  TextEditingController codeCtrl = TextEditingController();
  bool hidePassword = true;
  bool hidePasswordRepeat = true;
  bool passwordState = false;
  bool passwordConfirmState = false;
  bool stateSendCode = false;
  bool stateLoading = false;
  int step = 1;
  @override
  void initState() {
    existLogin();
    super.initState();
  }

  existLogin() async {
    final sizeScreenModal = Provider.of<SizeScreenModal>(context, listen: false);
    final userData = Provider.of<UserData>(context, listen: false).userData;
    await Future.delayed(const Duration(milliseconds: 50), () {});
    if (widget.stateEmail) {
      setState(() {
        step = 2;
        sizeScreenModal.updateSizeScreen(1);
        emailCtrl.text = userData!.email!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!widget.stateEmail)
              InputComponent(
                textInputAction: TextInputAction.next,
                controllerText: emailCtrl,
                onEditingComplete: () => node.nextFocus(),
                onChanged: (v) => changeInputs(),
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                icon: Icons.email,
                labelText: "Correo electrónico",
                statecorrect: emailCtrl.text.isNotEmpty &&
                        emailCtrl.text.contains(RegExp('@'), 0) &&
                        emailCtrl.text.contains(RegExp('.com'), 0)
                    ? true
                    : false,
              ),
            if (step == 2)
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
              ),
            if (step == 2)
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
                statecorrect: passwordConfirmState,
              ),
            if (!stateLoading)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // if (stateBtnContinue)
                  BtbNoExtendComponent(
                      isWhite: stateSendCode,
                      text: stateSendCode ? 'Reenviar Código' : 'Enviar Código',
                      onPressed: () => sendCode()),
                  if (stateSendCode)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                          'Te hemos enviado un correo con un código al . Para completar la verificación de la cuenta, por favor ingresa el código de activación de 6 dígitos.',
                          textAlign: TextAlign.center),
                    ),
                  if (stateSendCode)
                    PinCodeTextField(
                      appContext: context,
                      length: 6,
                      onChanged: (value) {},
                      controller: codeCtrl,
                      autoDisposeControllers: false,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.transparent,
                      pinTheme: PinTheme(
                        inactiveColor: const Color(0xff419388),
                        activeColor: Colors.black,
                        selectedColor: const Color(0xff419388),
                        selectedFillColor: const Color(0xff419388),
                        inactiveFillColor: Colors.transparent,
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        activeFillColor: Colors.red,
                      ),
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                    ),
                  if (stateSendCode) ButtonComponent(text: 'Verificar', onPressed: () => methodValidate()),
                ],
              ),
          ],
        ),
      ),
    );
  }

  changeInputs() {}
  formComplete(BuildContext context) {}
  sendCode() async {
    final sizeScreenModal = Provider.of<SizeScreenModal>(context, listen: false);
    setState(() => stateLoading = true);
    final Map<String, String> body = {
      "email": emailCtrl.text.trim(),
    };
    final response = await serviceMethod(context, 'post', body, requestChangePwd(), false, null);
    setState(() => stateLoading = false);
    if (response != null) {
      setState(() {
        stateSendCode = true;
        step = 2;
        sizeScreenModal.updateSizeScreen(1);
      });
    }
  }

  methodValidate() async {
    final sizeScreenModal = Provider.of<SizeScreenModal>(context, listen: false);
    setState(() => stateLoading = true);
    final Map<String, String> body = {
      "email": emailCtrl.text.trim(),
      "code": codeCtrl.text.trim(),
      "password": passwordCtrl.text.trim(),
    };
    final response = await serviceMethod(context, 'post', body, validateChangePWd(), false, null);
    setState(() => stateLoading = false);
    if (response != null) {
      if (!mounted) return;
      return showSuccessful(context, response.data['msg'], () {
        stateSendCode = false;
        sizeScreenModal.updateSizeScreen(2);
        Navigator.of(context).pop();
      });
    }
  }
}
