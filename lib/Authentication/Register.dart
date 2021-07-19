import 'package:flutter/material.dart';
import 'package:kabootr_app/Screens/Loading.dart';
import 'package:kabootr_app/Services/Auth.dart';

class Registration extends StatefulWidget {
  final String passkey;
  final String imgageUrl;
  Registration({@required this.imgageUrl, this.passkey});
  @override
  _RegistrationState createState() => _RegistrationState();
}

final _formkey = GlobalKey<FormState>();

class _RegistrationState extends State<Registration> {
  bool isLoading;

  TextEditingController nameController;
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController phoneNoController;
  String error;
  final AuthService authservice = AuthService();
  @override
  void initState() {
    // TODO: implement initState

    isLoading = false;
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    phoneNoController = TextEditingController();
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
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    validator: (val) => val.isEmpty ? "enter valid name" : null,
                    decoration: InputDecoration(
                      hintText: "Enter Name",
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
                  controller: phoneNoController,
                    validator: (val) =>
                        val.length != 10 ? "enter valid phone Number" : null,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "Enter Phone Number",
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
                  controller: emailController,
                    validator: (val) => val.isEmpty ? "enter valid email ID" : null,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      
                      hintText: "Enter Your Email ID",
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
                    validator: (val) => val.length < 6
                        ? "enter valid password of at least 6 digits"
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
                TextFormField(
                    obscureText: true,
                    
                    validator: (val) => val != passwordController.text
                        ? "Password Couldn't Match"
                        : null,
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
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
                  obscureText: true,
                    validator: (val) => val != widget.passkey ? "Please enter valid passKey" : null,
                    decoration: InputDecoration(
                      hintText: "Enter Passkey",
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
                    "Register",
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
                        final user = await authservice.register(
                          email: emailController.text,
                          password: passwordController.text,
                          name: nameController.text,
                          phoneNo : phoneNoController.text,
                          about: "Hey there I'm Using a DhimanBlend's Product",
                          imgUrl: widget.imgageUrl,
                        );
                        if(user == null)
                        {
                          error = 'Registration Failed!!';
                          setState(() {isLoading = false;});
                        }
                      } catch (e) {
                        print('Error in Register : ' + e.toString());
                        error = 'something went wrong!!';
                        setState(() {isLoading = false;});
                      }
                      phoneNoController.clear();
                      passwordController.clear();
                      nameController.clear();
                      emailController.clear();
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
