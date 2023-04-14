import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

TargetFocus targetCreateProcedure(GlobalKey<State<StatefulWidget>> keyTarget) {
  return TargetFocus(
    identify: "keyCreateProcedure",
    keyTarget: keyTarget,
    contents: [
      TargetContent(
        align: ContentAlign.bottom,
        builder: (context, controller) {
          return Column(
            verticalDirection: VerticalDirection.up,
            children: <Widget>[
              const Padding(
                  padding: EdgeInsets.all(30),
                  child: Text(
                    "Para crear su trámite debe presionar el botón CREAR TRÁMITE, cuando se encuentre en color verde",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  )),
              Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(45),
                  child: RotationTransition(
                      turns: const AlwaysStoppedAnimation(130 / 180),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/images/arrow.png',
                          color: Colors.white,
                          height: 80,
                        ),
                      )))
            ],
          );
        },
      ),
    ],
    shape: ShapeLightFocus.RRect,
    radius: 20,
  );
}

TargetFocus targetMenu(GlobalKey<State<StatefulWidget>> keyTarget) {
  return TargetFocus(identify: "keyMenu", keyTarget: keyTarget, contents: [
    TargetContent(
      align: ContentAlign.bottom,
      builder: (context, controller) {
        return Column(
          verticalDirection: VerticalDirection.up,
          children: <Widget>[
            const Padding(
                padding: EdgeInsets.all(30),
                child: Text(
                  "MENÚ\nAquí podrá ingresar al menú de datos y configuraciones",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                )),
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(90),
              child: RotationTransition(
                  turns: const AlwaysStoppedAnimation(100 / 180),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      'assets/images/arrow.png',
                      color: Colors.white,
                      height: 80,
                    ),
                  )),
            )
          ],
        );
      },
    ),
  ]);
}

TargetFocus targetGroup(GlobalKey<State<StatefulWidget>> keyTarget) {
  return TargetFocus(
    identify: "keygroup",
    keyTarget: keyTarget,
    contents: [
      TargetContent(
        align: ContentAlign.top,
        builder: (context, controller) {
          return Column(
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              const Padding(
                  padding: EdgeInsets.all(30),
                  child: Text(
                    "Círculo de confianza\nPresionando este botón usted podrá ver sus círculos de confianza",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  )),
              Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(10),
                  child: RotationTransition(
                      turns: const AlwaysStoppedAnimation(40 / 180),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/images/arrow.png',
                          color: Colors.white,
                          height: 80,
                        ),
                      )))
            ],
          );
        },
      ),
    ],
    shape: ShapeLightFocus.RRect,
    radius: 20,
  );
}

TargetFocus targetInvite(GlobalKey<State<StatefulWidget>> keyTarget) {
  return TargetFocus(
    identify: "keyInvite",
    keyTarget: keyTarget,
    contents: [
      TargetContent(
        align: ContentAlign.bottom,
        builder: (context, controller) {
          return Column(
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(10),
                  child: RotationTransition(
                      turns: const AlwaysStoppedAnimation(120 / 180),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/images/arrow.png',
                          color: Colors.white,
                          height: 80,
                        ),
                      ))),
              const Padding(
                  padding: EdgeInsets.all(30),
                  child: Text(
                    "Inivitación\nPresionando este botón usted podrá invitar a alguien para te cuide",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ],
          );
        },
      ),
    ],
    shape: ShapeLightFocus.RRect,
    radius: 20,
  );
}

TargetFocus targetReadInvite(GlobalKey<State<StatefulWidget>> keyTarget) {
  return TargetFocus(
    identify: "keyReadInvite",
    keyTarget: keyTarget,
    contents: [
      TargetContent(
        align: ContentAlign.top,
        builder: (context, controller) {
          return Column(
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              const Padding(
                  padding: EdgeInsets.all(30),
                  child: Text(
                    "Yo cuido\nPresionando este botón usted podrá ver las personas que le cuidan",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  )),
              Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(10),
                  child: RotationTransition(
                      turns: const AlwaysStoppedAnimation(40 / 180),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/images/arrow.png',
                          color: Colors.white,
                          height: 80,
                        ),
                      )))
            ],
          );
        },
      ),
    ],
    shape: ShapeLightFocus.RRect,
    radius: 20,
  );
}

TargetFocus targetRead(GlobalKey<State<StatefulWidget>> keyTarget) {
  return TargetFocus(
    identify: "keyRead",
    keyTarget: keyTarget,
    contents: [
      TargetContent(
        align: ContentAlign.bottom,
        builder: (context, controller) {
          return Column(
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(90),
                child: RotationTransition(
                    turns: const AlwaysStoppedAnimation(100 / 180),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        'assets/images/arrow.png',
                        color: Colors.white,
                        height: 80,
                      ),
                    )),
              ),
              const Padding(
                  padding: EdgeInsets.all(30),
                  child: Text(
                    "Escanear \nPresionando este botón usted podrá leer otras invitaciones (codigos QR) para dar acceso a que le cuiden ",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ],
          );
        },
      ),
    ],
    shape: ShapeLightFocus.RRect,
    radius: 20,
  );
}

TargetFocus targetAlert(GlobalKey<State<StatefulWidget>> keyTarget) {
  return TargetFocus(
    identify: "keyAlert",
    keyTarget: keyTarget,
    contents: [
      TargetContent(
        align: ContentAlign.top,
        builder: (context, controller) {
          return Column(
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              const Padding(
                  padding: EdgeInsets.all(30),
                  child: Text(
                    "Alerta \nPresionando este botón usted podrá enviar un alerta a todos los que le cuidan",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  )),
              Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(10),
                  child: RotationTransition(
                      turns: const AlwaysStoppedAnimation(40 / 180),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/images/arrow.png',
                          color: Colors.white,
                          height: 80,
                        ),
                      )))
            ],
          );
        },
      ),
    ],
    shape: ShapeLightFocus.RRect,
    radius: 20,
  );
}
