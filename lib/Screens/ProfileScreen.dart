import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:kabootr_app/AppEntity/Models.dart';
import 'package:kabootr_app/AppEntity/utils.dart';
import 'package:kabootr_app/AppEntity/utils2.dart';
import 'package:kabootr_app/Screens/PhotoView.dart';
import 'package:kabootr_app/Services/Database.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  ProfileScreen({this.user});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

final _formkey = GlobalKey<FormState>();

class _ProfileScreenState extends State<ProfileScreen> {
  User ourUser;
  File image;

  TextEditingController textEditController;
  @override
  void initState() {
    // TODO: implement initState
    ourUser = User(
      name: widget.user.name,
      phoneNo: widget.user.phoneNo,
      about: widget.user.about,
      imgUrl: widget.user.imgUrl,
      uid: widget.user.uid,
    );

    textEditController = TextEditingController();
    super.initState();
  }

  bool isuserChanged(){
    if(ourUser.phoneNo != widget.user.phoneNo) return true;
    if(ourUser.about != widget.user.about) return true;
    if(ourUser.imgUrl != widget.user.imgUrl) return true;

    return false;
  }

  void customDispose(BuildContext context) async {
    if(isuserChanged()){
      await DatabaseService(uid: ourUser.uid).updateuser(ourUser);
    }
    Navigator.pop(context);
  }

  showAlertDialog(BuildContext context, bool isNumber) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("Confirm"),
      onPressed: () {
        if(_formkey.currentState.validate())
        {
          if(isNumber) ourUser.phoneNo = textEditController.text;
          else ourUser.about = textEditController.text;
          setState(() {});
          Navigator.of(context).pop();
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: isNumber ? Text("Enter Your Phone Number") : Text("Enter About Yourself"),
      actions: [
        okButton,
      ],
      content: Form(
        key: _formkey,
        child: TextFormField(
          controller: textEditController,
          keyboardType:isNumber ? TextInputType.phone : TextInputType.name,
          validator: (val) {
            if(isNumber && val.length == 10) return null;
            else if(!isNumber && val.length > 10) return null;
            else return 'Enter valid Data';
          },
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            labelStyle: TextStyle(color: Theme.of(context).accentColor),
            labelText: isNumber ?"Phone Number" : 'About',
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).accentColor)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).accentColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).accentColor)),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red)),
          )),
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Card(
              elevation: 5.0,
              color: Theme.of(context).primaryColor,
              margin: EdgeInsets.all(20.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (BuildContext context) => ImageViewer(
                              nameOfImage: 'img_${ourUser.uid}',
                              url: ourUser.imgUrl,
                              uploadImage: uploadImage,
                            ))),
                          child: CircleAvatar(
                          radius: 65.0,
                          backgroundColor: Theme.of(context).accentColor,
                          backgroundImage: NetworkImage(ourUser.imgUrl),
                          
                      ),
                        ),
                      Positioned(
                        bottom: 0.0,
                        right: 0.0,
                        child: FloatingActionButton(
                          child: Icon(Icons.camera, color: Colors.white,),
                          onPressed: (){
                            settingModalBottomSheetFunction(context);
                          },
                          backgroundColor: Theme.of(context).accentColor,
                        ),
                      ),
                      ], 
                    ),
                  ),
                  Text(
                    ourUser.name,
                    style: TextStyle(
                        fontSize: 24.0, color: Theme.of(context).accentColor),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10.0),
                    child: ListTile(
                      subtitle: Text(
                        'Phone Number',
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          textEditController.clear();
                          showAlertDialog(context, true);
                        },
                        icon: Icon(
                          Icons.edit,
                        ),
                        color: Theme.of(context).accentColor,
                      ),
                      title: Text(
                        '+91 '+ ourUser.phoneNo,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: ListTile(
                      subtitle: Text(
                        'About',
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          textEditController.clear();
                          showAlertDialog(context, false);
                        },
                        icon: Icon(
                          Icons.edit,
                        ),
                        color: Theme.of(context).accentColor,
                      ),
                      title: Text(
                        ourUser.about,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

void uploadImage(String url, String _ ){
  ourUser.imgUrl = url.replaceFirst(fileAttachMsg, '');
  setState(() {});
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
                onTap: () async {
                  image = await getImageFromDevice(true);
                  Navigator.pop(context);
                  if(image != null){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (BuildContext context) => ImageViewer(
                        nameOfImage: 'img_${ourUser.uid}',
                        image: image,
                        uploadImage: uploadImage,
                      )));
                  }
                }
              ),
            new ListTile(
                leading: new Icon(Icons.image),
                title: new Text('Gallery'),
                onTap: () async{
                  image = await getImageFromDevice(false);
                  Navigator.pop(context);
                  if(image != null){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (BuildContext context) => ImageViewer(
                        nameOfImage: 'img_${ourUser.uid}',
                        image: image,
                        uploadImage: uploadImage,
                      )));
                  }
                }),
          ],
        ),
      );
    });
}
}

