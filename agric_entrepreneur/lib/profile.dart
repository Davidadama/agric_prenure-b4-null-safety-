import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

final GlobalKey<FormState> _formkey = GlobalKey<FormState>();


class Profile extends StatefulWidget {
  String title;

  Profile (String s);

  @override
  _ProfileState createState() => _ProfileState();
}

/**
final nameController = TextEditingController();
final emailController = TextEditingController();
final addressController = TextEditingController();
final passController = TextEditingController();
final phoneController = TextEditingController();
final roleController = TextEditingController();  **/

class _ProfileState extends State<Profile> {
  Future<FirebaseUser> _future;
  @override
  void initState(){

    _future = FirebaseAuth.instance.currentUser();
    
    super.initState();
  }

 late String userID,uid, _email, _name, _phone, _address, _role,_answer ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900],
      body:
      ListView(
          children: <Widget>[
      Padding(
      padding: EdgeInsets.only(left: 15.0, top: 10.0  ),
      child:
      Row(
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.lightGreenAccent,
              onPressed: (){Navigator.of(context).pop();} ),
        ],
      ),
    ),
    SizedBox(height:10.0),
    Padding(
    padding: EdgeInsets.only(top: 15.0, left: 10.0),
    child:
    Text('Profile', style: TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: Colors.lightGreenAccent
    ),
    ),
    ),
    SizedBox(height:78.0),
    Container(
    height: MediaQuery.of(context).size.height - 199.0,
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(topRight: Radius.circular(60.0))
    ),

            child:
            FutureBuilder(
                future: _future,
                builder: (context,AsyncSnapshot<FirebaseUser> snapshot){
                  if (snapshot.connectionState==ConnectionState.done) {
                    userID = snapshot.data.uid;
                    _userDetails(userID);

                    if (userID != null) {
                      return  StreamBuilder(
                          stream: Firestore.instance.collection('User_information').where('userId', isEqualTo: userID)
                              .snapshots(),
                          builder: (context, snapshot) {

                            if (snapshot.hasData == false) {
                              return Center(
                                child: Text('No information'),
                              );
                            }

                            else {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.green,
                                    )
                                );
                              }
                            }
                            return ListView.builder(
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                      child:
                                      Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(left: 5.0),
                                              child:
                                              Column(
                                                  children: <Widget>[
                                                    SizedBox(height: 10.0),

                                                    ListTile(
                                                        title: Row(
                                                          children: <Widget>[
                                                            Icon(Icons.person_pin, color: Colors.lightGreenAccent,)
                                                            , Text('Name ',
                                                              style: TextStyle(
                                                                  fontSize: 17.0,fontWeight: FontWeight.w500),
                                                              maxLines: 3,
                                                            )
                                                            ,],
                                                        ),
                                                        subtitle:
                                                        Padding(padding: EdgeInsets.only(left:23.0),
                                                          child: Text(snapshot.data.documents[index]['Name'],
                                                            style: TextStyle(
                                                              fontSize: 18.0,
                                                            ),),

                                                        )
                                                    ),

                                                    SizedBox(height: 10.0),

                                                    ListTile(
                                                        title: Row(
                                                          children: <Widget>[
                                                            Icon(Icons.email, color: Colors.lightGreenAccent,)
                                                            , Text('email ',
                                                              style: TextStyle(
                                                                  fontSize: 17.0,fontWeight: FontWeight.w500),
                                                              maxLines: 3,
                                                            )
                                                            ,],
                                                        ),
                                                        subtitle:
                                                        Padding(padding: EdgeInsets.only(left:23.0),
                                                          child: Text(snapshot.data.documents[index]['Email'],
                                                            style: TextStyle(
                                                              fontSize: 18.0,
                                                            ),),

                                                        )
                                                    ),

                                                    SizedBox(height: 10.0),
                                                    ListTile(
                                                        title: Row(
                                                          children: <Widget>[
                                                            Icon(Icons.phone_android, color: Colors.lightGreenAccent,)
                                                            , Text( 'Phone' ,
                                                              style: TextStyle(
                                                                  fontSize: 17.0,
                                                                  fontWeight: FontWeight.w500),
                                                              maxLines: 3,
                                                            )
                                                            ,],
                                                        ),
                                                        subtitle:
                                                        Padding(padding: EdgeInsets.only(left:23.0),
                                                          child: Text(snapshot.data.documents[index]['Phone_number'],
                                                            style: TextStyle(
                                                              fontSize: 18.0,
                                                            ),),

                                                        )
                                                    ),
                                                    SizedBox(height: 10.0),

                                                    ListTile(
                                                        title: Row(
                                                          children: <Widget>[
                                                            Icon(Icons.person_pin, color: Colors.lightGreenAccent,)
                                                            , Text('Address ',
                                                              style: TextStyle(
                                                                  fontSize: 17.0,fontWeight: FontWeight.w500),
                                                              maxLines: 3,
                                                            )
                                                            ,],
                                                        ),
                                                        subtitle:
                                                        Padding(padding: EdgeInsets.only(left:23.0),
                                                          child: Text(snapshot.data.documents[index]['Address'],
                                                            style: TextStyle(
                                                              fontSize: 18.0,
                                                            ),),

                                                        )
                                                    ),
                                                    SizedBox(height: 10.0),
                                                    ListTile(
                                                        title: Row(
                                                          children: <Widget>[
                                                            Icon(Icons.supervised_user_circle, color: Colors.lightGreenAccent,)
                                                            , Text('Role ',
                                                              style: TextStyle(
                                                                  fontSize: 17.0,fontWeight: FontWeight.w500),
                                                              maxLines: 3,
                                                            )
                                                            ,],
                                                        ),
                                                        subtitle:
                                                        Padding(padding: EdgeInsets.only(left:23.0),
                                                          child: Text(snapshot.data.documents[index]['Role'],
                                                            style: TextStyle(
                                                              fontSize: 18.0,
                                                            ),),

                                                        )
                                                    ),
                                                    SizedBox(height: 10.0),
                                                    ListTile(
                                                        title: Row(
                                                          children: <Widget>[
                                                            Icon(Icons.perm_identity, color: Colors.lightGreenAccent,)
                                                            , Text('UserID ',
                                                              style: TextStyle(
                                                                  fontSize: 17.0,
                                                                  fontWeight: FontWeight.w500),
                                                              maxLines: 3,
                                                            )
                                                            ,],
                                                        ),
                                                        subtitle:
                                                        Padding(padding: EdgeInsets.only(left:23.0),
                                                          child: Text(snapshot.data.documents[index]['userId'],
                                                            style: TextStyle(
                                                              fontSize: 18.0,
                                                            ),),

                                                        )
                                                    ),
                                                    SizedBox(height:10.0),
                                                    ListTile(
                                                        title: Row(
                                                          children: <Widget>[
                                                            Icon(Icons.calendar_today, color: Colors.lightGreenAccent,)
                                                            , Text('Date ',
                                                              style: TextStyle(
                                                                  fontSize: 17.0,
                                                                  fontWeight: FontWeight.w500),
                                                              maxLines: 3,
                                                            )
                                                            ,],
                                                        ),
                                                        subtitle:
                                                        Padding(padding: EdgeInsets.only(left:23.0),
                                                          child: Text(snapshot.data.documents[index]['Date'],
                                                            style: TextStyle(
                                                              fontSize: 18.0,
                                                            ),),

                                                        )
                                                    ),
                                                    SizedBox(height:10.0),
                                                    ListTile(
                                                        title: Row(
                                                          children: <Widget>[
                                                            Icon(Icons.calendar_today, color: Colors.lightGreenAccent,)
                                                            , Text('Answer',
                                                              style: TextStyle(
                                                                  fontSize: 17.0,
                                                                  fontWeight: FontWeight.w500),
                                                              maxLines: 3,
                                                            )
                                                            ,],
                                                        ),
                                                        subtitle:
                                                        Padding(padding: EdgeInsets.only(left:23.0),
                                                          child: Text(snapshot.data.documents[index]['Answer'],
                                                            style: TextStyle(
                                                              fontSize: 18.0,
                                                            ),),

                                                        )
                                                    ),

                                                    SizedBox(height:5.0),
                                                    ElevatedButton(
                                                      onPressed: (){
                                                        updateDialog(context,snapshot.data.documents[index].documentID);
                                                      },
                                                      child: Text('Update'),
                                                    ),
                                                SizedBox(height:1.0),
                                            ElevatedButton(
                                              onPressed: (){
                                                updateDialog1(context,snapshot.data.documents[index].documentID);
                                              },
                                              child: Text('Answer'),
                                            )

                                          ]
                                              ),
                                            ),
                                          ]
                                      )

                                  );
                                }
                            );

                          }
                      );
                    }
                  }
                  return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.green,
                      )
                  );
                  }
            )


    )
    ]
    ));
  }

 late String userDetails;

  Future<void> _userDetails(userID) async {
    final userDetails = await getData(userID);
    setState (() {
      uid = userDetails;
      Text(uid);
      return uid;
    }

    );
  }
  getData(userID) async{
    DocumentSnapshot result = await FirebaseFirestore.instance.collection('User_information').doc(userID).get();
    return result;
  }

  Future<bool> updateDialog(BuildContext context, selectedDoc) async{
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
            Row(
                children:<Widget>[
                  Text('Update Data',
                      style: TextStyle(
                          fontSize: 17.0)),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: Navigator.of(context).pop,
                    padding: EdgeInsets.only(left: 100.0),
                  ),
                ]
            ),

            content:
            ListView(
                children: <Widget>[
                  Form(
                      key: _formkey,
                      child:
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                            child:
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              maxLength: 20,
                              maxLines: 2,
                              // ignore: missing_return
                              validator: (input){
                                if (input.isEmpty) {
                                  return 'Please Enter your name';
                                }
                              },
                              onSaved:  (input) {
                                this._name = input;
                              },
                              decoration: InputDecoration(
                                labelText: 'Name',
                                hintText: 'Stephen Curry',

                                labelStyle: TextStyle(
                                    fontSize: 17.0,
                                    fontStyle: FontStyle.normal
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                            child:
                            TextFormField(
                              maxLines: 1,
                              maxLength: 35,
                              validator: (input){
                                if (input.isEmpty) {
                                  return 'Please enter your email';
                                }
                               },
                              onSaved:  (input) {
                                this._email = input;
                              },
                              decoration: InputDecoration(
                                labelText: 'Email',
                                hintText: 'example20@yahoo.com',
                                hintMaxLines: 1,
                                labelStyle: TextStyle(
                                    fontSize: 17.0,
                                    fontStyle: FontStyle.normal
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                            child:
                            TextFormField(
                              maxLines: 1,
                              maxLength: 11,
                              validator: (input){
                                if (input.isEmpty) {
                                  return 'Please enter your email';
                                }
                               },
                              onSaved:  (input) {
                                this._phone = input;
                              },
                              decoration: InputDecoration(
                                labelText: 'Phone number',
                                hintText: '07123346578',
                                hintMaxLines: 1,
                                labelStyle: TextStyle(
                                    fontSize: 17.0,
                                    fontStyle: FontStyle.normal
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                            child:

                            TextFormField(
                              maxLength: 30,
                              validator: (input){
                                if (input.isEmpty) {
                                  return 'Please Enter your address';
                                }

                               },
                              onSaved: (input) {
                                this._address= input;
                              },
                              decoration: InputDecoration(
                                labelText: 'Address',
                                hintText: '24 Apollo crescent',
                                labelStyle: TextStyle(
                                    fontSize: 17.0,
                                    fontStyle: FontStyle.normal
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                            child:
                            TextFormField(
                              textInputAction: TextInputAction.done,
                              maxLength: 20,
                              validator: (input){
                                if (input.isEmpty) {
                                  return 'Please Enter your role';
                                }
                               },
                              onSaved:  (input) {
                                this._role = input;
                              },
                              decoration: InputDecoration(
                                labelText: 'Role',
                                hintText: 'student',
                                labelStyle: TextStyle(
                                    fontSize: 17.0,
                                    fontStyle: FontStyle.normal
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height:25.0),
                          RaisedButton(
                            onPressed: (){
                              if (_formkey.currentState.validate()) {
                                //no error in validator
                                _formkey.currentState.save();
                               // showToast();
                                Navigator.of(context).pop;
                                updateData(selectedDoc, {
                                  "Name": this._name,
                                  "Email": this._email,
                                  "Address": this._address,
                                  "Phone_number": this._phone,
                                  "Role": this._role,
                                }
                                );
                              }
                              else{
                                //validation error
                                setState(() {
                                  var _validate = true;
                                });
                              }

                            },
                            child: Text('Update'),

                          )
                        ],
                      )
                  )

                ]
            ),
          );
        }
    );
  }

  Future<bool> updateDialog1(BuildContext context, selectedDoc) async{
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
            Row(
                children:<Widget>[
                  Text('Answer the question',
                      style: TextStyle(
                          fontSize: 17.0)),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: Navigator.of(context).pop,
                    padding: EdgeInsets.only(left: 100.0),
                  ),
                ]
            ),

            content:
            ListView(
                children: <Widget>[
                  Form(
                      key: _formkey,
                      child:
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                            child:
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              maxLength: 20,
                              maxLines: 2,
                              // ignore: missing_return
                              validator: (input){
                                if (input.isEmpty) {
                                  return 'Please Enter your answer';
                                }
                              },
                              onSaved:  (input) {
                                this._answer = input;
                              },
                              decoration: InputDecoration(
                                labelText: 'Answer',
                                hintText: 'Stephen Curry',

                                labelStyle: TextStyle(
                                    fontSize: 17.0,
                                    fontStyle: FontStyle.normal
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height:25.0),
                          RaisedButton(
                            onPressed: (){
                              if (_formkey.currentState.validate()) {
                                //no error in validator
                                _formkey.currentState.save();
                                // showToast();
                                Navigator.of(context).pop;
                                updateData1(selectedDoc,{
                                  'Answer': this._answer
                                });
                              }
                              else{
                                //validation error
                                setState(() {
                                  var _validate = true;
                                });
                              }

                            },
                            child: Text('Answer'),

                          )
                        ],
                      )
                  )

                ]
            ),
          );
        }
    );
  }


}
void showToast() {
  Fluttertoast.showToast(
      msg: 'Document updated',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 2,
      backgroundColor: Colors.green,
      textColor: Colors.white
  );
}
updateData(selectedDoc, newValues) {
  Firestore.instance.collection('User_information')
      .document(selectedDoc)
      .updateData(newValues)
      .catchError((e) {
    print(e);
  }
  );
  showToast();

}

updateData1(selectedDoc,newValues) {
  FirebaseFirestore.instance.collection('User_information')
      .doc(selectedDoc)
      .set(newValues)
      .catchError((e) {
    print(e);
  }
  );
  showToast();

}

