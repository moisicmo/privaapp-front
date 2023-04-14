import 'package:flutter/material.dart';

class ButtonComponent extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final bool isWhite;
  final Color color;
  const ButtonComponent(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.isWhite = false,
      this.color = const Color(0xff623D92)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        elevation: 0,
        splashColor: Colors.transparent,
        color: isWhite ? Colors.transparent : color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        onPressed: onPressed,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(text,
              style: TextStyle(color: isWhite ? const Color(0xff0B9C3F) : Colors.white, fontWeight: FontWeight.bold)),
        ]));
  }
}

class BtbNoExtendComponent extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final bool isWhite;
  const BtbNoExtendComponent({Key? key, required this.text, required this.onPressed, this.isWhite = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: MaterialButton(
          elevation: 5,
          splashColor: Colors.transparent,
          color: isWhite ? Colors.white : const Color(0xff27AE60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.messenger_outline_outlined, color: isWhite ? const Color(0xff27AE60) : Colors.white),
                const SizedBox(width: 5),
                Text(text, style: TextStyle(color: isWhite ? const Color(0xff27AE60) : Colors.white)),
              ],
            ),
          )),
    );
  }
}

class ButtonComponent2 extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final bool stateLoading;
  const ButtonComponent2({Key? key, required this.text, required this.onPressed, this.stateLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        minWidth: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        color: Colors.red,
        disabledColor: Colors.grey,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: stateLoading
            ? Center(
                child: Image.asset(
                'assets/gifs/load.gif',
                fit: BoxFit.cover,
                height: 20,
              ))
            : Text(text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )));
  }
}

class ButtonWhiteComponent extends StatelessWidget {
  final String text;
  final Function() onPressed;
  const ButtonWhiteComponent({Key? key, required this.text, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        splashColor: Colors.transparent,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onPressed: onPressed,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(text, style: const TextStyle(color: Colors.black)),
        ]));
  }
}
