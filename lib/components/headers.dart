import 'package:flutter/material.dart';
import 'package:privaap/components/paint_copy.dart';

class HedersComponent extends StatefulWidget {
  final String? titleHeader;
  final String? title;
  final bool center;
  final GlobalKey? keyNotification;
  final bool stateColor;
  final bool stateBack;
  final Function()? actionBack;
  const HedersComponent(
      {Key? key,
      this.titleHeader,
      this.title = '',
      this.center = false,
      this.keyNotification,
      this.stateColor = false,
      this.stateBack = true,
      this.actionBack})
      : super(key: key);

  @override
  State<HedersComponent> createState() => _HedersComponentState();
}

class _HedersComponentState extends State<HedersComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      AppBar(
          automaticallyImplyLeading: widget.stateBack,
          leadingWidth: 25,
          leading: GestureDetector(
            onTap: () {
              if (widget.actionBack == null) {
                Navigator.of(context).pop();
              } else {
                widget.actionBack!();
              }
            },
            child: const Icon(Icons.arrow_back_ios_new),
          ),
          title: GestureDetector(
            onTap: () {
              if (widget.actionBack == null) {
                Navigator.of(context).pop();
              } else {
                widget.actionBack!();
              }
            },
            child: Text(widget.titleHeader ?? 'BP TIEMPO', style: const TextStyle(fontWeight: FontWeight.w500)),
          )),
      SizedBox(
        width: double.infinity,
        height: 50,
        child: Stack(
          children: [
            const FormtopAlt(),
            const ForsmButtomAlt(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(widget.title!,
                  textAlign: widget.center ? TextAlign.center : TextAlign.start,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
          ],
        ),
      ),
    ]);
  }
}
