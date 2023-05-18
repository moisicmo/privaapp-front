import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:privaap/components/button.dart';
import 'package:privaap/components/dialog_action.dart';
import 'package:privaap/components/headers.dart';
import 'package:scan/scan.dart';

class ReadQr extends StatefulWidget {
  final Function(String) result;
  const ReadQr({super.key, required this.result});

  @override
  State<ReadQr> createState() => _ReadQrState();
}

class _ReadQrState extends State<ReadQr> {
  final ImagePicker _picker = ImagePicker();

  ScanController controllerReadQr = ScanController();
  String qrcode = 'Unknown';

  @override
  void initState() {
    controllerReadQr.resume();
    super.initState();
  }

  @override
  void dispose() {
    controllerReadQr.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: BtbNoExtendComponent(text: 'Escanear invitaciones', onPressed: () => _displayPickImageDialog()),
    );
  }

  _displayPickImageDialog() {
    showCupertinoModalPopup<String>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
              title: const Text(
                'Seleccionar medio de lectura',
              ),
              actions: <Widget>[
                CupertinoActionSheetAction(
                  child: const Text('Cámara'),
                  onPressed: () => _onImageButtonPressed(true, context),
                ),
                CupertinoActionSheetAction(
                  child: const Text('Galería'),
                  onPressed: () => _onImageButtonPressed(false, context),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop("Discard");
                },
              ));
        });
  }

  void _onImageButtonPressed(bool camera, BuildContext context) async {
    if (camera) {
      readInvitation();
    } else {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 540,
        maxHeight: 380,
        imageQuality: 100,
      );
      if (!mounted) return;
      Navigator.pop(context);
      if (pickedFile == null) return;

      // return widget.onPressed(file);
      String? result = await Scan.parse(pickedFile.path);
      widget.result(result!);
    }
  }

  Future readInvitation() async {
    await showDialog(
        context: context,
        builder: (_) {
          return FadeIn(
              child: DialogWidget(
            component: Column(
              children: [
                const HedersComponent(title: 'Lector de invitaciones'),
                SizedBox(
                  width: 250, // custom wrap size
                  height: 250,
                  child: ScanView(
                    controller: controllerReadQr,
                    // custom scan area, if set to 1.0, will scan full area
                    scanAreaScale: .7,
                    // scanLineColor: Colors.green,
                    onCapture: (data) {
                      debugPrint('data $data');
                      widget.result(data);
                      if (!mounted) return;
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                ButtonComponent(
                  onPressed: () => controllerReadQr.toggleTorchMode(),
                  text: 'Flash',
                ),
              ],
            ),
          ));
        });
  }
}
