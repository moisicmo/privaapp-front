import 'package:flutter/material.dart';

class ForsmButtomAlt extends StatelessWidget {
  const ForsmButtomAlt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: CustomPaint(
        // painter: FormButtomPainter(ThemeProvider.themeOf(context).id.contains('dark') ? const Color(0xff214a44):const Color(0xff8dbeb8)),
        painter: FormButtomPainter(const Color(0xfff2f2f2)),
      ),
    );
  }
}

class FormButtomPainter extends CustomPainter {
  final Color color;

  FormButtomPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.fill; //stroke //fill

    final path = Path()
      ..moveTo(0, size.height * 1)
      ..quadraticBezierTo(size.width * 0.15, size.height * 0.85, size.width * 0.7, size.height * 0.7)
      ..quadraticBezierTo(size.width / 1.2, size.height * 0.3, size.width, size.height * 0.25)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class FormtopAlt extends StatelessWidget {
  const FormtopAlt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: CustomPaint(
        painter: FormtopPainter(),
      ),
    );
  }
}

class FormtopPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xffFECB3A)
      ..strokeWidth = 2
      ..style = PaintingStyle.fill; //stroke //fill

    final path = Path()
      ..moveTo(0, size.height * 0.8)
      ..quadraticBezierTo(size.width * 0.15, size.height * 0.75, size.width * 0.8, size.height * 0.65)
      // ..quadraticBezierTo(size.width / 1.2, size.height * 0.3, size.width, size.height * 0.25)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
