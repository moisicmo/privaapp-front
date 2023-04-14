import 'package:flutter/material.dart';

class LabelOverImageComponent extends StatelessWidget {
  final double? bottom;
  final double? right;
  final String text;
  const LabelOverImageComponent({Key? key, required this.text, this.right, this.bottom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: bottom,
        right: right,
        child: Material(
            color: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
            child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.white),
                ))));
  }
}
