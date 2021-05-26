import 'package:flutter/material.dart';
import 'package:todoapp/ui/widgets/customaapbar.dart';
import 'package:todoapp/ui/widgets/custom_shape.dart';
import 'package:todoapp/ui/widgets/responsive_ui.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoapp/constants/constants.dart';






class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool large=false;
  bool medium=false;
  String? email,pwd;
  FirebaseAuth auth = FirebaseAuth.instance;
  final snackBar = SnackBar(content: Text('Yay! A SnackBar!'));
  bool checkBoxValue = false;
  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _large;
  late bool _medium;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large =  ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium =  ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Material(
      child: Scaffold(
        body: Container(
          height: _height,
          width: _width,
          margin: EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Opacity(opacity: 0.88,child: CustomAppBar()),
                clipShape(),
                signupTextRow(),
                form(),
                SizedBox(height: _height/35,),
                button(),
                signInTextRow(),


              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget clipShape() {
    //double height = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height:_large? _height!/4 : (_medium? _height!/3.75 : _height!/3.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200]!, Colors.pinkAccent],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large? _height!/4.5 : (_medium? _height!/4.25 : _height!/4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200]!, Colors.pinkAccent],
                ),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(top: _large? _height!/30 : (_medium? _height!/25 : _height!/20)),
          child: Image.asset(
            'assets/images/login.png',
            height: _height!/3.5,
            width: _width!/3.5,
          ),
        ),
      ],
    );
  }
  Widget signupTextRow() {
    return Container(

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Sign Up",
            style: TextStyle(

              fontWeight: FontWeight.bold,
              fontSize: _large? 40 : (_medium? 30 : 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left:_width/ 12.0,
          right: _width / 12.0,
          top: _height / 20.0),
      child: Form(
        child: Column(
          children: <Widget>[

            emailTextFormField(),
            SizedBox(height: _height / 60.0),
            passwordTextFormField(),
          ],
        ),
      ),
    );
  }





  Widget emailTextFormField() {

    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    large =  ResponsiveWidget.isScreenLarge(_width!, _pixelRatio!);
    medium=  ResponsiveWidget.isScreenMedium(_width!, _pixelRatio!);
    return Material(

      borderRadius: BorderRadius.circular(30.0),
      elevation: large? 12 : (medium? 10 : 8),
      child: TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        cursorColor: Colors.orange[200],
        onChanged: (value) => email = value,
        decoration: InputDecoration(
          prefixIcon: Icon( Icons.email, color: Colors.orange[200], size: 20),
          hintText: "Email ID",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
        ),
      ),
    );

  }

  Widget passwordTextFormField() {

    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    large =  ResponsiveWidget.isScreenLarge(_width!, _pixelRatio!);
    medium=  ResponsiveWidget.isScreenMedium(_width!, _pixelRatio!);
    return Material(

      borderRadius: BorderRadius.circular(30.0),
      elevation: large? 12 : (medium? 10 : 8),
      child: TextFormField(
        controller: passwordController,
        keyboardType: TextInputType.visiblePassword,
        cursorColor: Colors.orange[200],
        onChanged: (value) => pwd = value,
        decoration: InputDecoration(
          prefixIcon: Icon( Icons.lock, color: Colors.orange[200], size: 20),
          hintText: "Password",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }


  Widget button() {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () async {
        //sign up
        if(email!.isEmpty||pwd!.isEmpty){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fields are empty')));
        }
        else
        {
          try {
            UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pwd);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signup successful')));
            Navigator.pop(context, {});
          } on FirebaseAuthException catch (e) {
            if (e.code == 'weak-password') {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password too weak')));
            } else if (e.code == 'email-already-in-use') {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email already in use')));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error $e')));
            }
          } catch (e) {
            print(e);
          }
        }
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
//        height: _height / 20,
        width: _large ? _width / 4 : (_medium ? _width / 3.75 : _width / 3.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[Colors.orange[200]!, Colors.pinkAccent],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text('SIGN UP',
          style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10)),),
      ),
    );
  }



  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Already have an account?",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop(SIGN_IN);
              print("Routing to Sign up screen");
            },
            child: Text(
              "Sign in",
              style: TextStyle(
                  fontWeight: FontWeight.w800, color: Colors.orange[200], fontSize: 19),
            ),
          )
        ],
      ),
    );
  }
}
