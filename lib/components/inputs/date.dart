import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Date extends StatefulWidget {
  final String labelText;
  final Function(String) selectDate;
  const Date({super.key, required this.labelText, required this.selectDate});

  @override
  State<Date> createState() => _DateState();
}

class _DateState extends State<Date> {
  String text = '';
  DateTime currentDate = DateTime(1950, 1, 1);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.labelText),
        ButtonDate(text: text, onPressed: () => select(context), statecorrect: text != ''),
      ],
    );
  }

  select(BuildContext context) {
    showCupertinoModalPopup<String>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            actions: <Widget>[_buildDateTimePicker()],
            cancelButton: CupertinoActionSheetAction(
              child: const Text('Elegir'),
              onPressed: () {
                setState(() => text = DateFormat(' dd, MMMM yyyy ', "es_ES").format(currentDate));
                widget.selectDate(DateFormat('dd-MM-yyyy').format(currentDate));
                Navigator.of(context).pop();
              },
            ),
          );
        });
  }

  Widget _buildDateTimePicker() {
    return SizedBox(
        height: 200,
        child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: currentDate,
            onDateTimeChanged: (DateTime newDataTime) {
              setState(() {
                text = DateFormat(' dd, MMMM yyyy ', "es_ES").format(newDataTime);
                currentDate = newDataTime;
              });
              widget.selectDate(DateFormat('dd-MM-yyyy').format(newDataTime));
            }));
  }
}

class ButtonDate extends StatelessWidget {
  final String text;
  final Color? colorText;
  final FontWeight? fontWeight;
  final bool iconState;
  final Function() onPressed;
  final bool statecorrect;

  const ButtonDate(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.iconState = false,
      this.colorText,
      this.fontWeight,
      this.statecorrect = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        elevation: 0,
        focusElevation: 0,
        onPressed: onPressed,
        color: statecorrect ? Colors.white : const Color(0xffEBEDEE),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: statecorrect
                ? const BorderSide(color: Color(0xff27AE60), style: BorderStyle.solid, width: 1)
                : BorderSide.none),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(text,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xff828282),
              )),
        ]));
  }
}
