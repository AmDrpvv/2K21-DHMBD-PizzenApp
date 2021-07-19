import 'package:flutter/material.dart';
import 'package:kabootr_app/Screens/Loading.dart';
import 'package:kabootr_app/Services/Auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

final _formkey = GlobalKey<FormState>();

class _SignInState extends State<SignIn> {
  bool isLoading;
  final AuthService authservice = AuthService();
  TextEditingController passwordController;
  TextEditingController emailController;
  String error;

  @override
  void initState() {
    // TODO: implement initState

    isLoading = false;
    passwordController = TextEditingController();
    emailController = TextEditingController();
    error = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:  isLoading ? Loading() :  Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: emailController,
                    validator: (val) =>
                        val.isEmpty ? "enter valid email ID" : null,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Enter Email ID",
                      errorBorder: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                    )),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: passwordController,
                    obscureText: true,
                    validator: (val) => val.length < 5
                        ? "enter valid password of at least 5 digits"
                        : null,
                    decoration: InputDecoration(
                      hintText: "Enter Password",
                      errorBorder: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                    )),
                SizedBox(
                  height: 20.0,
                ),
                RaisedButton(
                  child: Text(
                    "Log In",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Theme.of(context).accentColor,
                  onPressed: () async {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                    if (_formkey.currentState.validate()) {
                      try {
                        setState(() {isLoading = true;});
                        final user = await authservice.signin(emailController.text, passwordController.text);
                        if(user == null)
                        {
                          error = 'Sign In Failed!';
                          setState(() {isLoading = false;});
                        }
                      } catch (e) {
                        print('Error in sign In : ' + e.toString());
                        error = 'something went wrong!';
                        setState(() {isLoading = false;});
                      }
                      emailController.clear();
                      passwordController.clear();
                    }
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 15.0),
                ),
              ],
            ),
          )),
    );
  }
}
