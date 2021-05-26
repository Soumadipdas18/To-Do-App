import 'package:flutter/material.dart';
import 'package:todoapp/constants/constants.dart';
import 'package:todoapp/ui/widgets/custom_shape.dart';
import 'package:todoapp/ui/widgets/responsive_ui.dart';
import 'package:todoapp/ui/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';


TextEditingController lastNameController = TextEditingController();
TextEditingController firstNameController = TextEditingController();
TextEditingController birthdayController = TextEditingController();

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignInScreen(),
    );
  }
}

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String? title;

  bool large=false;
  bool medium=false;
  String? email,pwd;
  FirebaseAuth auth = FirebaseAuth.instance;
  double? _height;
  double ?_width;
  double ?_pixelRatio;
  bool _large=false;
  bool _medium=false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();



  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large =  ResponsiveWidget.isScreenLarge(_width!, _pixelRatio!);
    _medium =  ResponsiveWidget.isScreenMedium(_width!, _pixelRatio!);
    return Material(
      child: Container(
        height: _height,
        width: _width,
        padding: EdgeInsets.only(bottom: 5),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              clipShape(),
              welcomeTextRow(),
              signInTextRow(),
              form(),

              SizedBox(height: _height !/ 12),
              button(),
              signUpTextRow(),
            ],
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

  Widget welcomeTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width !/ 20, top: _height !/ 100),
      child: Row(
        children: <Widget>[
          Text(
            "Welcome",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _large? 60 : (_medium? 50 : 40),
            ),
          ),
        ],
      ),
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width !/ 15.0),
      child: Row(
        children: <Widget>[
          Text(
            "Sign in to your account",
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: _large? 20 : (_medium? 17.5 : 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width! / 12.0,
          right: _width! / 12.0,
          top: _height !/ 15.0),
      child: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            emailTextFormField(),
            SizedBox(height: _height !/ 40.0),
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
        //sign in
        if(email!.isEmpty||pwd!.isEmpty){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fields are empty')));
        }
        else {
          try {
            UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pwd);
            Scaffold.of(context).showSnackBar(SnackBar(content: Text('Login Successful')));
            Navigator.pushReplacement<void, void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => Home(),
              ),
            );
          } on FirebaseAuthException catch (e) {
            if (e.code == 'user-not-found') {
              Scaffold.of(context).showSnackBar(SnackBar(content: Text('No user found for that email.')));
            } else if (e.code == 'wrong-password') {
              Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Wrong password provided for that user.')));
            } else {
              Scaffold.of(context).showSnackBar(SnackBar(content: Text('Error $e')));
            }
          }
        }
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
        width: _large? _width!/4 : (_medium? _width!/3.75: _width!/3.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[Colors.orange[200]!, Colors.pinkAccent],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text('SIGN IN',style: TextStyle(fontSize: _large? 14: (_medium? 12: 10))),
      ),
    );
  }

  Widget signUpTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height !/ 120.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Don't have an account?",
            style: TextStyle(fontWeight: FontWeight.w400,fontSize: _large? 14: (_medium? 12: 10)),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(SIGN_UP);
              print("Routing to Sign up screen");
            },
            child: Text(
              "Sign up",
              style: TextStyle(
                  fontWeight: FontWeight.w800, color: Colors.orange[200], fontSize: _large? 19: (_medium? 17: 15)),
            ),
          )
        ],
      ),
    );
  }

}