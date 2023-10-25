import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Sign_in.dart';


final GlobalKey<FormState> _formkey = GlobalKey<FormState>();


class App extends StatelessWidget {

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.red[600],
      theme: ThemeData(primaryColor: Colors.redAccent),
      title: 'Password Reset',
      debugShowCheckedModeBanner: false,
      home: password_reset(title: 'Payment'),
    );
  }
}

class password_reset extends StatefulWidget {

  password_reset({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _password_resetState createState() => _password_resetState();
}


class _password_resetState extends State<password_reset> {

 late String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Password Reset',style: TextStyle(color: Colors.brown[400]),),
          centerTitle: true,
        ),
        body: Center(
          child:
          ListView(
            children: <Widget>[
              SizedBox(height:10.0),

              Form(
                  key: _formkey,
                  child:
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                        child:
                        TextFormField(
                          maxLines: 1,
                          validator: (input){
                            if (input!.isEmpty) {
                              return 'Please enter your email';
                            }
                          
                          },
                          onSaved: (input) => email = input! ,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Please insert a valid email where the password reset link can be sent to.'
                                ' hint: example19@yahoo.com',
                            hintMaxLines: 3,
                            labelStyle: TextStyle(
                                fontSize: 17.0,
                                fontStyle: FontStyle.normal
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height:300.0),
                      ElevatedButton(
                        onPressed: (){
                          setState(() {
                            var  _validate = true;
                          });

                          final formState = _formkey.currentState;
                          if (formState!.validate()) {
                            formState.save();
                           resetPassword(email);
                              showDialog(context: context,
                                builder: (context) => AlertDialog(
                                content: ListTile(
                                title: Text('Pasword Reset',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0,),
                                ),

                                subtitle: Text('Please check your email for a password reset link',
                                )
                                ),
                                titlePadding: EdgeInsets.only(bottom: 20.0) ,
                                contentPadding: EdgeInsets.all(12.0),
                                actions: <Widget>[
                                Row(
                                children: <Widget>[
                                TextButton(onPressed: ()=>
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(), fullscreenDialog: true)),
                                child:Text('OK')
                                ),
                                SizedBox(height: 35.0,)
                                ],
                                ),
                                ],
                                )
                                );
                          }
                          // Navigator.of(context).pop();
                        },

                        child: Text('Send me password reset link'),
                      ),
                    ],
                  )
              )

            ],
          ),
        )
    );

  }
  Future<void>
  resetPassword(email) async{
    await FirebaseAuth.instance.sendPasswordResetEmail(email:email);
      }

}
