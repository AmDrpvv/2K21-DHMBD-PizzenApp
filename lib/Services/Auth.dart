import 'package:firebase_auth/firebase_auth.dart';
import 'package:kabootr_app/AppEntity/Models.dart';
import 'package:kabootr_app/Services/Database.dart';


class AuthService{
  final FirebaseAuth _auth =FirebaseAuth.instance;
//create our user from firebase user
  String _createStringfromFirebaseuser(FirebaseUser user){
    return user==null ? null : user.uid;
  }

  // auth change user stream
  Stream<String> get userStream {
    return _auth.onAuthStateChanged
        .map((FirebaseUser user) => _createStringfromFirebaseuser(user));
  }

  //sign in anon
  Future signInAnon() async{

    try{
      
      AuthResult _result = await _auth.signInAnonymously();
      FirebaseUser user = _result.user;
      return _createStringfromFirebaseuser(user);
    }catch(e){
      print('Error in signInAnon :'+ e.toString());
      return null;
    }
  }

  //signin with username and password
  Future signin(String email,String password) async
  {
    try{
      AuthResult _result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      FirebaseUser user = _result.user;
      return _createStringfromFirebaseuser(user);
    }catch(e){
      print('Error in signin :'+ e.toString());
      return null;
    }
  }

  //register with username and password
  Future register({String phoneNo,String password, String name, String email, String imgUrl, String about}) async
  {
    try{
      AuthResult _result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      FirebaseUser user = _result.user;
      //creating database document for this user
      if(user!=null){
        await DatabaseService(uid: user.uid).createuser(
          User(
            uid: user.uid,
            name: name,
            phoneNo: phoneNo,
            imgUrl: imgUrl,
            about: about
          )
        );
      }
      return _createStringfromFirebaseuser(user);
    }catch(e){
      print('Error in register auth:'+ e.toString());
      return null;
    }
  }


  //signing out
  Future signout ()async{
    try{
      return await _auth.signOut();
    }
    catch(e){
      print('Error in signout :'+ e.toString());
      return null;
    }
  }

  //deleting User
  Future deleteAccount() async{
    try {
      
      FirebaseUser resullt = await _auth.currentUser();
      await resullt.delete();
    } catch (e) {
      print('Error in deleting userAccount : $e');
    }

  }
}