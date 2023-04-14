import 'package:flutter/material.dart';
import 'package:privaap/components/button.dart';

class StepRegister03 extends StatelessWidget {
  final Function() methodcontinue;
  const StepRegister03({super.key, required this.methodcontinue});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text('Bienvenido a una aplicación que te ayuda a vivir más seguro contigo mismo...'),
      Center(
          child: Image.asset(
        'assets/images/wellcome.png',
        fit: BoxFit.contain,
        // height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      )),
      ButtonComponent(text: 'Terminar', onPressed: () => methodcontinue())
    ]);
  }
}
