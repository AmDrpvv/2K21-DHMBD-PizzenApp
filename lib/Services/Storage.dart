import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FireStorageService{
  final File file;
  final String fileName;
  FireStorageService({this.file, this.fileName});

  Future uploadFile() async {

    StorageReference storageReference = 
    FirebaseStorage.instance.ref().child("images/$fileName");

    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    print('url for uploaded image is : $url');
    return url;
  }

  Future deleteFile() async {
    await FirebaseStorage.instance.ref().child("images/$fileName").delete();
  }

}