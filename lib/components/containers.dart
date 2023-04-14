import 'package:flutter/material.dart';

class ContainerComponent extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final Color? color;
  const ContainerComponent({Key? key, required this.child, this.width, this.height, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: color ?? const Color(0xfff2f2f2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 0.5,
              offset: Offset(0, 1),
            )
          ],
        ),
        child: child);
  }
}

class ContainerRoundedComponent extends StatelessWidget {
  final Widget child;
  const ContainerRoundedComponent({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 2.0,
                  offset: Offset(1, 1),
                )
              ],
            ),
            child: child));
  }
}
