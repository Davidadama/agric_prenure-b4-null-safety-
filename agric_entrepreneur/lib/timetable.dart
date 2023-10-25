import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



class timetable extends StatelessWidget {
  final String title;
  timetable (this.title);


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
              Text('Timetable', style: TextStyle(
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
              child:StreamBuilder (
                  stream: FirebaseFirestore.instance.collection('Lunch').snapshots(),

                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return  Center(
                          child:  Text('Your timetable will appear here')
                      );

                    return
                      Column(
                          );
                  }
              ),

            ),
          ],
        )
    );
  }
}
