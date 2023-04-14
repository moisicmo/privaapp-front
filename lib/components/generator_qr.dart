import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:privaap/components/button.dart';
import 'package:privaap/components/headers.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class ScreenQr extends StatefulWidget {
  final String message;
  const ScreenQr({super.key, required this.message});

  @override
  State<ScreenQr> createState() => _ScreenQrState();
}

class _ScreenQrState extends State<ScreenQr> {
  ScreenshotController screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HedersComponent(title: 'Invitación'),
        Screenshot(
            controller: screenshotController,
            child: Container(
              color: const Color(0xffEBEDEE),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<ui.Image>(
                      future: _loadOverlayImage(),
                      builder: (ctx, snapshot) {
                        return CustomPaint(
                          size: const Size.square(250),
                          painter: QrPainter(
                            data: widget.message,
                            version: QrVersions.auto,
                            eyeStyle: const QrEyeStyle(
                              eyeShape: QrEyeShape.square,
                              color: Color(0xff128760),
                            ),
                            dataModuleStyle: const QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.circle,
                              color: Color(0xff1a5441),
                            ),
                            // size: 320.0,
                            embeddedImage: snapshot.data,
                            embeddedImageStyle: QrEmbeddedImageStyle(
                              size: const Size.square(40),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )),
        ButtonComponent(
          onPressed: () => _shareQrCode(),
          text: 'Compartir',
        ),
      ],
    );
  }

  _shareQrCode() async {
    debugPrint('COMPARTIENDO');
    final directory = (await getApplicationDocumentsDirectory()).path;
    screenshotController.capture().then((Uint8List? image) async {
      if (image != null) {
        try {
          String fileName = DateTime.now().microsecondsSinceEpoch.toString();
          final imagePath = await File('$directory/$fileName.png').create();
          await imagePath.writeAsBytes(image);
          List<dynamic> docs = [imagePath.path];
          if (docs == null || docs.isEmpty) return null;

          await FlutterShare.shareFile(
            title: 'Compartir Invitación',
            text: 'Hola! te invito a unirte a mi círculo de confianza',
            filePath: docs[0] as String,
          );
        } catch (error) {
          debugPrint('error $error');
        }
      }
    }).catchError((onError) {
      debugPrint('Error --->> $onError');
    });
  }

  Future<ui.Image> _loadOverlayImage() async {
    final completer = Completer<ui.Image>();
    final byteData = await rootBundle.load('assets/images/person.png');
    ui.decodeImageFromList(byteData.buffer.asUint8List(), completer.complete);
    return completer.future;
  }
}
