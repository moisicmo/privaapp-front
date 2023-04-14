import 'package:flutter/material.dart';
import 'package:privaap/components/button.dart';
import 'package:privaap/components/inputs/input.dart';
import 'package:privaap/services/service_method.dart';
import 'package:privaap/services/services.dart';

class VerifyPassword extends StatefulWidget {
  final Function(bool) pwdCorrect;
  const VerifyPassword({super.key, required this.pwdCorrect});

  @override
  State<VerifyPassword> createState() => _VerifyPasswordState();
}

class _VerifyPasswordState extends State<VerifyPassword> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController passwordCtrl = TextEditingController();
  bool hidePassword = true;
  bool passwordState = false;
  bool stateLoading = false;
  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
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
            !stateLoading
                ? ButtonComponent(text: 'Verificar', onPressed: () => formComplete(context))
                : Center(
                    child: Image.asset(
                    'assets/gifs/load.gif',
                    fit: BoxFit.cover,
                    height: 20,
                  )),
          ],
        ),
      ),
    );
  }

  changeInputs() {}
  formComplete(context) async {
    setState(() => stateLoading = true);
    final Map<String, String> body = {
      "password": passwordCtrl.text.trim(),
    };
    final response = await serviceMethod(context, 'post', body, verifyPwd(), true, null);
    setState(() => stateLoading = false);
    if (response != null) {
      if (!mounted) return;
      widget.pwdCorrect(true);
    }
  }
}
