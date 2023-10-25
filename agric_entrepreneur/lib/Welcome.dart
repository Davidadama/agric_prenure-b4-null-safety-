import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'Register.dart';
import 'Sign_in.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String? get title => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.green[700],
        title:
           Text('Welcome',style: TextStyle(color: Colors.white,fontSize: 20.0),),
        centerTitle: true,
      ),
      body:

      Row(mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
                       children: <Widget>[
                         Image.asset('assets/icons/718.jpg',
                         height: 350.0,
                         width: 300.0,
                         filterQuality: FilterQuality.high,
                         ),
               Center(
                 child:
               Text('by  Joe Turner'),
               ),
                         SizedBox(height: 15.0,),
               RichText(
                //textAlign: TextAlign.center,
                  //textDirection: TextDirection.rtl,
                  text: TextSpan(
                    style: TextStyle(color: Colors.green[700], fontSize: 50.0, fontStyle: FontStyle.normal),
                    children: <TextSpan>[
                      TextSpan(text: 'Sign up',
                      recognizer: TapGestureRecognizer()..onTap=(){
                        navigateToRegister();
                      }
                      ),
                    ]
                  )
              ),

                  SizedBox(height: 20.0,),
    RichText(
          textAlign: TextAlign.center,
    text: TextSpan(
    style: TextStyle(color: Colors.greenAccent, fontSize: 30.0, fontStyle: FontStyle.normal),
    children: <TextSpan>[
    TextSpan(
    text: 'I already have an account.',
    style: TextStyle(color: Colors.green[700],fontSize: 15.0, fontStyle: FontStyle.normal),
    recognizer: TapGestureRecognizer()..onTap=(){
    navigateToSignIn();
    }
    )
    ]
    )
    ),
    SizedBox(height: 30.0),
            ],

          ),
        ],
      ),
    );
  }

  void navigateToRegister(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => Register(), fullscreenDialog: true));
  }

  void navigateToSignIn(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(), fullscreenDialog: true));
  }
}
