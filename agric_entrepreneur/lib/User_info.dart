import 'package:agric_entrepreneur/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Sign_in.dart';


final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

 class people extends StatefulWidget {


  @override
  _peopleState createState() => _peopleState();
}

class _peopleState extends State<people> {
  late String  _email,_name,_phone,_address,_role ,userID,uid;
    
    
   late final  User _user;
    late final DocumentSnapshot? userInfo;
    
   @override
          void initState() {  
        super.initState();
        _currentUser().whenComplete((){
          setState(() {
               }
                  );
       });
      }

       _currentUser() async {
        _user = FirebaseAuth.instance.currentUser! ;
        try {
          userInfo = await FirebaseFirestore.instance
              .collection('User_information')
              .doc(_user.uid)
              .get().whenComplete(() => userID = _user.uid );
           // userID = userInfo as String;

        } catch (e) {
          print("something went wrong");
        }
      }

    

  /**
Future<void> getID(userID) async{
      final userDetails = await getData(userID);
    setState (() {
      uid = userDetails.toString();
      userID = uid;
      //Text(uID);
    }
    );
    
  }
 **/
    
       @override

       
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:

      ListView(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: 13.0, top: 10.0),
              child:
          Row(children: <Widget>[
            IconButton(
                icon: Icon(Icons.arrow_back),
                color: Colors.black,
                onPressed: (){Navigator.of(context).pop();
                }
            )
          ],
          )
          ),
        SizedBox(height:20.0),
            Padding(
                  padding: EdgeInsets.only(top: 13.0, left: 95.0),
                  child:
                  Text('Add your information', style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green
                  ),
    ),
    ),
          SizedBox(height:20.0),

        
       
         Form(
              key: _formkey,
              child:
              Column(
                children: <Widget>[
                  Padding(
                  padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                  child:
                  TextFormField(
                    maxLength: 15,
                    maxLines: 1,
                    validator: (input){
                  if (input!.isEmpty) {
                  return 'Please Enter your name';
                  }
                    },
                    onSaved: (input) => _name = input!,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      hintText: 'Victor Oladipo',
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
                  maxLength: 11,
                  maxLines: 1,
                  validator: (input){
                      if (input!.isEmpty) {
                        return 'Please enter your phone number';
                      }
                    },
                    onSaved: (input) => _phone  = input! ,
                    decoration: InputDecoration(
                      labelText: 'Phone number',
                      hintText: '07038749869',
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
                maxLines: 1,
                validator: (input){
                      if (input!.isEmpty) {
                        return 'Please Enter your email';
                      }
                    },
                    onSaved: (input) => _email = input!,
                    decoration: InputDecoration(
                      labelText: 'Email',
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
      maxLines: 3,
      validator: (input){
                      if (input!.isEmpty) {
                        return 'Please Enter your address';
                      }
                    },
                    onSaved: (input) => _address = input!,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      hintText: 'Federal-lowcost',
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
                    validator: (input){
                      if (input!.isEmpty) {
                        return 'Please Enter your role';
                      }
                    },
                    onSaved: (input) => _role = input!,
                    decoration: InputDecoration(
                      labelText: 'Role',
                      hintText: 'User or Admin',
                      labelStyle: TextStyle(
                          fontSize: 17.0,
                          fontStyle: FontStyle.normal
                      ),
                    ),
                  ),
                      ),

                  SizedBox(height:25.0),
            ElevatedButton(
                onPressed: () async {
                  setState(() {
                    var  _validate = true;});

                    final formState = _formkey.currentState;
                    if (formState!.validate()) {
                      formState.save();
                      addUser();

                    //  Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPage()));
                    }
                
                  },

              child: Text('Add'),
                )
                ],
              )
          )
        ],
      ),
    );
  }

  void showToast() {
    Fluttertoast.showToast(
        msg: 'Information Added',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white
    );
  }

   Future<void> addUser() async{
      
         CollectionReference reference = FirebaseFirestore.instance.collection('User_information');

         await reference.add({
           "userId":userID,
           "Name": "$_name",
           "Phone_number": "$_phone",
           "Email": "$_email",
           "Address": "$_address",
           "Role": "$_role",
           "Date": '${DateTime.now()}'
         }
         ).then((value) =>
          Navigator.push(context,MaterialPageRoute(builder: (context) => MyApp())))
          .onError((error, stackTrace) => print(error));
       
         }
}

class Firestore {
  static var instance;
}
void setState(Null Function() param0) {
}


