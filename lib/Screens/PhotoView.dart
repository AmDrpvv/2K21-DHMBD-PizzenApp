import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kabootr_app/AppEntity/utils.dart';
import 'package:kabootr_app/Screens/Loading.dart';
import 'package:kabootr_app/Services/Storage.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatefulWidget {
  final File image;
  final String url;
  final Function uploadImage;
  final String nameOfImage;
  ImageViewer({this.image, this.url, this.uploadImage, @required this.nameOfImage});
  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  bool isLoading = false;

  void customDispose(BuildContext context){
    if(widget.url == null){
      widget.image.delete(recursive: true);
      imageCache.clear();
      Navigator.pop(context);
    }
    else
    {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        customDispose(context);
        return null;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => customDispose(context),
            icon: Icon(Icons.arrow_back_ios),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: isLoading ? Loading():  PhotoView(
        imageProvider: widget.url == null ? FileImage(widget.image)
        : NetworkImage(widget.url),
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 1.8,
          initialScale: PhotoViewComputedScale.contained * 1.1,
          backgroundDecoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
            if(isLoading) return null;
            if(widget.url == null)
            {
              String dateTime = getFormattedDateTime(DateTime.now());
              String nameOfImg = widget.nameOfImage == '' ? 'img_'+ dateTime.replaceAll('/','') : widget.nameOfImage;
              setState(() { isLoading = true;});
              String url = await FireStorageService(
                file: widget.image, fileName: nameOfImg).uploadFile();
              
              widget.uploadImage(fileAttachMsg + url, dateTime);
              setState(() { isLoading = false;});
            }
            customDispose(context);
          },
          backgroundColor: Theme.of(context).accentColor,
          child: Icon(
            widget.url == null ? Icons.send : Icons.arrow_back,
            color: Colors.white,),
        ),
      ),
    );
  }
}