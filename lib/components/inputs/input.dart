import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputComponent extends StatelessWidget {
  final IconData? icon;
  final String labelText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final TextEditingController controllerText;
  final List<TextInputFormatter>? inputFormatters;
  final Function() onEditingComplete;
  final Function(String)? validator;
  final bool obscureText;
  final Function()? onTap;
  final IconData? iconOnTap;
  final TextCapitalization textCapitalization;
  final Function(String)? onChanged;
  final Function()? onTapInput;
  final bool? stateAutofocus;
  final bool statecorrect;
  const InputComponent(
      {Key? key,
      required this.labelText,
      required this.keyboardType,
      required this.textInputAction,
      this.focusNode,
      required this.controllerText,
      this.inputFormatters,
      required this.onEditingComplete,
      this.validator,
      this.icon,
      this.obscureText = false,
      this.onTap,
      this.iconOnTap,
      this.textCapitalization = TextCapitalization.words,
      this.onChanged,
      this.onTapInput,
      this.stateAutofocus = false,
      this.statecorrect = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText),
        const SizedBox(height: 5),
        TextFormField(
            autofocus: stateAutofocus!,
            textAlignVertical: TextAlignVertical.center,
            focusNode: focusNode,
            textCapitalization: textCapitalization,
            textInputAction: textInputAction,
            onEditingComplete: onEditingComplete,
            validator: (text) => validator!(text!),
            controller: controllerText,
            inputFormatters: inputFormatters,
            onChanged: onChanged,
            onTap: onTapInput,
            keyboardType: keyboardType,
            obscureText: obscureText,
            style: const TextStyle(color: Color(0xff828282)),
            decoration: InputDecoration(
              prefixIcon: InkWell(
                onTap: onTap,
                child: Icon(
                  icon ?? iconOnTap,
                  color: const Color(0xff828282),
                ),
              ),
              suffixIcon: statecorrect
                  ? const Icon(
                      Icons.check_circle,
                      color: Color(0xff27AE60),
                    )
                  : null,
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
            )),
        const SizedBox(height: 5),
      ],
    );
  }
}
