import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class NumberPhone extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final Function(PhoneNumber) onChanged;
  final bool statecorrect;
  const NumberPhone(
      {super.key,
      required this.labelText,
      required this.controller,
      required this.onChanged,
      this.statecorrect = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText),
        IntlPhoneField(
          searchText: 'Buscar por nombre de país',
          controller: controller,
          // autoValidate: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value.toString().length == 8) {
              return null;
            } else {
              return 'Ingrese su número';
            }
          },
          decoration: InputDecoration(
              fillColor: statecorrect ? Colors.white : null,
              focusedBorder: statecorrect
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(color: Color(0xff27AE60), width: 1.0))
                  : null,
              enabledBorder: statecorrect
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                        color: Color(0xff27AE60),
                        width: 1.0,
                      ),
                    )
                  : null,
              hintStyle: TextStyle(color: Colors.grey.withOpacity(.8)),
              hintText: "Número telefónico"),
          initialCountryCode: 'BO',
          onChanged: (phone) => onChanged(phone),
        ),
      ],
    );
  }
}
