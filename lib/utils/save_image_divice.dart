import 'dart:io';
import 'package:path_provider/path_provider.dart';

  Future <String> saveImage(File image) async {
    DateTime lastDate = DateTime.now();
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = documentDirectory.path + "/images";
    var filePathAndName = documentDirectory.path +
        '/images/profile' +
        lastDate.toString() +
        '.png';
    await Directory(firstPath).create(recursive: true);
    File file2 = File(filePathAndName);
    file2.writeAsBytesSync(image.readAsBytesSync());
    return filePathAndName;
  }