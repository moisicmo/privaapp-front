import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:privaap/components/button.dart';
import 'package:privaap/components/inputs/date.dart';
import 'package:privaap/components/inputs/phone.dart';
import 'package:privaap/components/inputs/select.dart';

class StepRegister02 extends StatefulWidget {
  final Function() methodSendCode;
  final Function() methodValidate;
  final TextEditingController phoneCtrl;
  final TextEditingController codeCtrl;
  final TextEditingController emailCtrl;
  final Function(String) dateCtrl;
  final Function(String) stateCivilCtrl;
  final Function(String) genderCtrl;
  final String? stateCivil;
  final String? gender;
  final String date;
  final bool sendCode;
  final bool stateLoading;
  const StepRegister02(
      {super.key,
      required this.methodSendCode,
      required this.methodValidate,
      required this.phoneCtrl,
      required this.dateCtrl,
      required this.stateCivilCtrl,
      required this.genderCtrl,
      required this.codeCtrl,
      required this.emailCtrl,
      required this.stateCivil,
      required this.gender,
      required this.date,
      required this.sendCode,
      this.stateLoading = false});

  @override
  State<StepRegister02> createState() => _StepRegister02State();
}

class _StepRegister02State extends State<StepRegister02> {
  bool hidePassword = true;
  bool stateBtnContinue = false;
  final stateCivilList = ['Casado(a)', 'Soltero(a)', 'Viudo(a)', 'Otro'];
  final genderList = ['Masculino', 'Femenino', 'Otro'];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Select(
          labelText: 'Estado Civil',
          options: stateCivilList,
          onChanged: (value) {
            widget.stateCivilCtrl(value);
            changeInputs();
          },
          statecorrect: widget.stateCivil != '',
          text: widget.stateCivil,
        ),
        Select(
          labelText: 'Genero',
          options: genderList,
          onChanged: (value) {
            widget.genderCtrl(value);
            changeInputs();
          },
          statecorrect: widget.gender != '',
          text: widget.gender,
        ),
        Date(
            labelText: 'Fecha de Nacimiento',
            selectDate: (value) {
              debugPrint('value fecha de naciemiento $value');
              widget.dateCtrl(value);
              changeInputs();
            }),
        NumberPhone(
          labelText: 'Teléfono Móvil',
          controller: widget.phoneCtrl,
          onChanged: (v) => changeInputs(),
          statecorrect: widget.phoneCtrl.text.length > 6,
        ),
        if (!widget.stateLoading)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (stateBtnContinue)
                BtbNoExtendComponent(
                    isWhite: widget.sendCode,
                    text: widget.sendCode ? 'Reenviar Código' : 'Enviar Código',
                    onPressed: () => widget.methodSendCode()),
              if (widget.sendCode)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                      'Te hemos enviado un correo con un código al ${widget.emailCtrl.text}. Para completar la verificación de la cuenta, por favor ingresa el código de activación de 6 dígitos.',
                      textAlign: TextAlign.center),
                ),
              if (widget.sendCode)
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  onChanged: (value) {},
                  controller: widget.codeCtrl,
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
                      activeFillColor: Colors.red),
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                ),
              if (widget.sendCode) ButtonComponent(text: 'Verificar', onPressed: () => widget.methodValidate()),
            ],
          ),
        if (widget.stateLoading)
          Center(
              child: Image.asset(
            'assets/gifs/load.gif',
            fit: BoxFit.cover,
            height: 20,
          )),
      ],
    );
  }

  changeInputs() {
    if (widget.stateCivil == '') return setState(() => stateBtnContinue = false);
    if (widget.gender == '') return setState(() => stateBtnContinue = false);
    if (widget.date == '') return setState(() => stateBtnContinue = false);
    if (widget.phoneCtrl.text.length < 8) return setState(() => stateBtnContinue = false);
    setState(() => stateBtnContinue = true);
  }
}
