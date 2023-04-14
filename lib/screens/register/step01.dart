import 'dart:io';

import 'package:flutter/material.dart';
import 'package:privaap/components/button.dart';
import 'package:privaap/components/image_input.dart';
import 'package:privaap/components/inputs/input.dart';

class StepRegister01 extends StatefulWidget {
  final TextEditingController nameCtrl;
  final TextEditingController lastNameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final TextEditingController passwordRepeatCtrl;
  final File? imageFile;
  final Function() complete;
  final Function(File) changeImage;
  const StepRegister01(
      {super.key,
      required this.nameCtrl,
      required this.lastNameCtrl,
      required this.emailCtrl,
      required this.passwordCtrl,
      required this.passwordRepeatCtrl,
      required this.imageFile,
      required this.changeImage,
      required this.complete});

  @override
  State<StepRegister01> createState() => _StepRegister01State();
}

class _StepRegister01State extends State<StepRegister01> {
  bool hidePassword = true;
  bool hidePasswordRepeat = true;
  bool stateBtnContinue = false;
  @override
  void initState() {
    changeInputs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Column(
      children: [
        ImageInputComponent(
          imageFile: widget.imageFile,
          onPressed: (File value) {
            changeInputs();
            widget.changeImage(value);
          },
        ),
        InputComponent(
          textInputAction: TextInputAction.next,
          controllerText: widget.nameCtrl,
          onEditingComplete: () => node.nextFocus(),
          onChanged: (v) => changeInputs(),
          keyboardType: TextInputType.text,
          icon: Icons.person,
          labelText: "Nombre(s)",
          statecorrect: widget.nameCtrl.text.isNotEmpty,
        ),
        InputComponent(
          textInputAction: TextInputAction.next,
          controllerText: widget.lastNameCtrl,
          onEditingComplete: () => node.nextFocus(),
          onChanged: (v) => changeInputs(),
          keyboardType: TextInputType.text,
          icon: Icons.person,
          labelText: "Apellidos",
          statecorrect: widget.lastNameCtrl.text.isNotEmpty,
        ),
        InputComponent(
          textInputAction: TextInputAction.next,
          controllerText: widget.emailCtrl,
          onEditingComplete: () => node.nextFocus(),
          onChanged: (v) => changeInputs(),
          keyboardType: TextInputType.emailAddress,
          textCapitalization: TextCapitalization.none,
          icon: Icons.email,
          labelText: "Correo electrónico",
          statecorrect: widget.emailCtrl.text.isNotEmpty &&
              widget.emailCtrl.text.contains(RegExp('@'), 0) &&
              widget.emailCtrl.text.contains(RegExp('.com'), 0),
        ),
        InputComponent(
          textInputAction: TextInputAction.done,
          controllerText: widget.passwordCtrl,
          onEditingComplete: () => node.nextFocus(),
          textCapitalization: TextCapitalization.none,
          keyboardType: TextInputType.text,
          onChanged: (v) => changeInputs(),
          labelText: "Contraseña",
          obscureText: hidePassword,
          onTap: () => setState(() => hidePassword = !hidePassword),
          iconOnTap: hidePassword ? Icons.lock : Icons.lock_open_sharp,
          statecorrect: widget.passwordCtrl.text.length >= 6 || stateRepeatPassword(),
        ),
        InputComponent(
          textInputAction: TextInputAction.done,
          controllerText: widget.passwordRepeatCtrl,
          onEditingComplete: () => widget.complete(),
          textCapitalization: TextCapitalization.none,
          keyboardType: TextInputType.text,
          labelText: "Repita Contraseña",
          obscureText: hidePasswordRepeat,
          onChanged: (v) => changeInputs(),
          onTap: () => setState(() => hidePasswordRepeat = !hidePasswordRepeat),
          iconOnTap: hidePasswordRepeat ? Icons.lock : Icons.lock_open_sharp,
          statecorrect: stateRepeatPassword(),
        ),
        if (stateBtnContinue) ButtonComponent(text: 'Siguiente', onPressed: () => widget.complete()),
      ],
    );
  }

  bool stateRepeatPassword() {
    if (widget.passwordRepeatCtrl.text == widget.passwordCtrl.text && widget.passwordRepeatCtrl.text.length >= 6) {
      return true;
    } else {
      return false;
    }
  }

  changeInputs() {
    if (widget.nameCtrl.text == '') return setState(() => stateBtnContinue = false);
    if (widget.lastNameCtrl.text == '') return setState(() => stateBtnContinue = false);
    if (widget.emailCtrl.text == '' ||
        !widget.emailCtrl.text.contains(RegExp('@'), 0) ||
        !widget.emailCtrl.text.contains(RegExp('.com'), 0)) return setState(() => stateBtnContinue = false);
    if (widget.passwordCtrl.text == '') return setState(() => stateBtnContinue = false);
    if (widget.passwordRepeatCtrl.text != widget.passwordCtrl.text) return setState(() => stateBtnContinue = false);
    // if (widget.imageFile == null) return setState(() => stateBtnContinue = false);
    setState(() => stateBtnContinue = true);
  }
}
