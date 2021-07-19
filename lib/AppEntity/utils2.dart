import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

Future<File> getImageFromDevice(bool isCamera) async {
  final picker = ImagePicker();
  final pickedFile = await picker.getImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      maxHeight: 720,
      imageQuality: 90,
      maxWidth: 720);

  if (pickedFile != null) {
    return File(pickedFile.path);
  } else {
    return null;
  }
}

Future<String> saveImageToDevice(File _image, String name) async {
  try {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = '${documentsDirectory.path}/SavedProfileImages/$name';
    await _image.copy(path);
    imageCache.clear();
    await Future.delayed(Duration(seconds: 1));
    _image.delete(recursive: true);
    return path;
  } catch (e) {
    print('error in saving Images to Device : $e');
    return null;
  }
}

Future<String> getImageFileFromAssets(String path, String name) async {
  try {
    final byteData = await rootBundle.load('$path');

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String pathdir = '${documentsDirectory.path}/SavedProfileImages/$name';
    final file = await File(pathdir).create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    imageCache.clear();
    return file.path;
  } catch (e) {
    print('error in getImageFileFromAssets : $e');
    return null;
  }
}

settingModalBottomSheetFunction(context) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext _context) {
        return Container(
          child: new Wrap(
            children: <Widget>[
              new ListTile(
                  leading: new Icon(Icons.camera),
                  title: new Text('Camera'),
                  onTap: () {
                    Navigator.pop(context);
                  }),
              new ListTile(
                  leading: new Icon(Icons.image),
                  title: new Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                  }),
            ],
          ),
        );
      });
}
