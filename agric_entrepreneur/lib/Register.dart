import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'Sign_in.dart';
import 'User_info.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String _email, _password;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Container(
        decoration: BoxDecoration(
        image: DecorationImage(
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(Colors.lightGreen.withOpacity(0.2), BlendMode.dstATop),
    image: AssetImage('assets/icons/718.jpg')
    ),
    ),
    child: Scaffold(
        backgroundColor: Colors.transparent,
        body:
        ListView(
            children: <Widget>[
              SizedBox(height:30.0),
    Padding(
    padding: EdgeInsets.only(top: 13.0),
    child:
    Text('Sign up',
    textAlign: TextAlign.center, style: TextStyle(
    fontSize: 25.0,
    fontWeight: FontWeight.bold,
    color: Colors.green[400]
    ),
    ),
    ),
    SizedBox(height:220.0),


     Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
          Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child:
        TextFormField(
          style: TextStyle(
            color: Colors.white
          ),
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Please Enter Email';
                  }
                },
                onSaved: (input) => _email = input,
                decoration: InputDecoration(
                    labelStyle: TextStyle(
                      color: Colors.green,
                      fontSize: 17
                    ),
                    labelText: 'Email'
                ),
              ),
          ),
        Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child:
          TextFormField(
            style: TextStyle(
              color: Colors.green,

            ),
                validator: (input) {
                  if (input.length == 0) {
                    return 'Password cannot be empty';
                  }
                },
                onSaved: (input) => _password = input,
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    color: Colors.green,
                    fontSize: 17
                  ),
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
        ),
              SizedBox(height:25.0),
              RaisedButton(
                onPressed: register,
                child: Text('Sign up'),
              ),
            SizedBox(height:45.0),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: TextStyle(color: Colors.green[400], fontSize: 30.0, fontStyle: FontStyle.normal),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'I already have an account.',
                            style: TextStyle(color: Colors.green[400],fontSize: 15.0, fontStyle: FontStyle.normal),
                            recognizer: TapGestureRecognizer()..onTap=(){
                              navigateToSignIn();
                            }
                        )
                      ]
                  )
              ),

            ],
          )
      ),
    ]
        )
    )
    )
    );
  }
  void navigateToSignIn(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(), fullscreenDialog: true));
  }

showAlertDialog(BuildContext context){
  AlertDialog alert= AlertDialog(
    contentPadding: EdgeInsets.all(5),
    content: new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(
          backgroundColor: Colors.green,
        ),
        Container(margin: EdgeInsets.only(left: 10),child: Text('wait...'),),
      ],
    ),
  ) ;
  showDialog(context: context,
  barrierDismissible: false,
    builder: (BuildContext context){
    return alert;
    }
  );
}

  Future<void> register () async {
    FirebaseUser user;
    final formState = _formkey.currentState;
    if (formState.validate()) {
      formState.save();

      try{
             showAlertDialog(context);
          user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password)).user;
             Navigator.pop(context);

        showDialog(context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              content: ListTile(
                  title: Text('Email verification',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0,),
                  ),
                  subtitle: Text('Please check your email for a verification link',
                  )
              ),
              titlePadding: EdgeInsets.only(bottom: 20.0) ,
              contentPadding: EdgeInsets.all(12.0),
              actions: <Widget>[
                Row(
                  children: <Widget>[
                    FlatButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => User(), fullscreenDialog: true)),
                        child:Text('OK')
                    ),
                    SizedBox(height: 35.0,)
                  ],
                ),
              ],
            )
        );

           await user.sendEmailVerification();
           return user.uid;

         } catch (e){
           print(e.message);
        showDialog(context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              content: ListTile(
                  title: Text('Error',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0,),
                  ),
                  subtitle: Text(e.message,
                  )
              ),
              titlePadding: EdgeInsets.only(bottom: 20.0) ,
              contentPadding: EdgeInsets.all(12.0),
              actions: <Widget>[
                Row(
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pop(context);
                        },
                        child:Text('OK')
                    ),
                    SizedBox(height: 35.0,)
                  ],
                ),
              ],
            )
        );
         }
    }

  }
}
