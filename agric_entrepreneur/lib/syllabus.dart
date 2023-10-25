import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class syllabus extends StatelessWidget {
  final String title;
  syllabus (this.title);

   @override
  Widget build(BuildContext context) {
    return new Scaffold(

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
                      onPressed: (){Navigator.of(context).pop();} )
                ],
              ),
            ),
            SizedBox(height:20.0),
            Padding(
              padding: EdgeInsets.only(top: 15.0, left: 10.0),
              child:
              Text('Syllabus', style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightGreenAccent
              ),
              ),
            ),
            SizedBox(height:78.0),
            
            Container(
              height: MediaQuery.of(context).size.height - 185.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(60.0))
              ),
             child: 
             FutureBuilder(
               builder: (context,AsyncSnapshot<FirebaseAuth> snapshot){
            if (snapshot.connectionState==ConnectionState.done) {
                    
            final Stream<QuerySnapshot> _userStream = FirebaseFirestore.instance.collection('Syllabus').snapshots();

           return   StreamBuilder (
// final Stream<QuerySnapshot> _userStream = FirebaseFirestore.instance.collection('Syllabus').snapshots();

                  stream:_userStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                  return    Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.green,
                          )
                      );

                      
                    return
                   new  ListView(
                        
                         children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;

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
                                                     // Icon(Icons.person_pin, color: Colors.lightGreenAccent,)
                                                      ],
                                                  ),
                                                  subtitle:
                                                  Padding(padding: EdgeInsets.only(left:19.0),
                                                    child: Text(data['syllabus'],
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                      ),),

                                                  )
                                              ),

                                               ]
                                        ),
                                      ),
                                    ]
                                )

                            );
                           }
          ).toList(),
        );
                    
                        }
              );
               }
                 return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.green,
                      )
                  );
                
               }
            ),
               
            )]
        )
    );
  }
}
