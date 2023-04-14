import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInputComponent extends StatefulWidget {
  final File? imageFile;
  final String? image;
  final Function(File) onPressed;
  const ImageInputComponent({super.key, this.imageFile, required this.onPressed, this.image});

  @override
  State<ImageInputComponent> createState() => _ImageInputComponentState();
}

class _ImageInputComponentState extends State<ImageInputComponent> {
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => _displayPickImageDialog(),
        child: Stack(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: widget.image == null
                    ? widget.imageFile == null
                        ? Image.asset('assets/images/person.png',
                            width: 100, height: 100, fit: BoxFit.cover, gaplessPlayback: true)
                        : Image.file(
                            File(widget.imageFile!.path),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            gaplessPlayback: true,
                          )
                    : Image.network(widget.image!, width: 80, height: 80, fit: BoxFit.cover, gaplessPlayback: true)),
            const Positioned(
              bottom: 5,
              right: 0,
              child: Icon(
                Icons.image,
                size: 20,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }

  _onImageButtonPressed(ImageSource source, BuildContext context) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      maxWidth: 540,
      maxHeight: 380,
      imageQuality: 100,
    );
    if (!mounted) return;
    Navigator.pop(context);
    if (pickedFile == null) return;
    final file = File(pickedFile.path);
    return widget.onPressed(file);
  }

  _displayPickImageDialog() {
    showCupertinoModalPopup<String>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
              title: const Text(
                'Seleccionar medio de Imagen',
              ),
              actions: <Widget>[
                CupertinoActionSheetAction(
                  child: const Text('Cámara'),
                  onPressed: () => _onImageButtonPressed(ImageSource.camera, context),
                ),
                CupertinoActionSheetAction(
                  child: const Text('Galería'),
                  onPressed: () => _onImageButtonPressed(ImageSource.gallery, context),
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
}
