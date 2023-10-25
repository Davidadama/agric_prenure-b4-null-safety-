import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String userID,uid ;

final GlobalKey<FormState> _formkey = GlobalKey<FormState>();


class allquestions extends StatefulWidget {
  String title;

  allquestions(String s);

  @override
  _allquestionsState createState() => _allquestionsState();
}
final nameController = TextEditingController();
final emailController = TextEditingController();
final addressController = TextEditingController();
final passController = TextEditingController();
final phoneController = TextEditingController();
final roleController = TextEditingController();

class _allquestionsState extends State<allquestions> {
  Future<FirebaseUser> _future;
  @override
  void initState(){
    _future = FirebaseAuth.instance.currentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green[900],
        body:
        ListPage()
    );
  }




  String userDetails;
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
    DocumentSnapshot result = await Firestore.instance.collection('User_information').document(userID).get();
    return result;
  }


}

class ListPage extends StatefulWidget
{

  @override
  _ListPageState createState() => _ListPageState();

}

class _ListPageState extends State<ListPage>
{
  Future<FirebaseUser> _future;

  @override
  void initState(){
    _future = FirebaseAuth.instance.currentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child:
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
                Text('questions', style: TextStyle(
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
                                stream: Firestore.instance.collection('Questions').where('userId', isEqualTo: 'userID')
                                    .orderBy('Date',descending: true).snapshots(),
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

                                        return ListTile(
                                          onTap: (){navigateToDetail(snapshot.data.documents[index]);},
                                          title: Text(snapshot.data.documents[index]['Title'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17.0,
                                            ),
                                          ),

                                          subtitle: Text(snapshot.data.documents[index]['Date']),
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
  //
  navigateToDetail(DocumentSnapshot question){
    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(question: question)));
  }
  String userDetails;
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
    DocumentSnapshot result = await Firestore.instance.collection('Questions').document(userID).get();
    return result;
  }

}
class DetailPage extends StatefulWidget {
  final DocumentSnapshot question;

  DetailPage({this.question});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Detailed answer',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
              color: Colors.lightGreen[700],
            ),
          ),
        ),
        body:
        Container(
            child:
            ListView(
                children: <Widget>[
                  Column(
                      children: <Widget>[
                        SizedBox(height: 5.0),
                        ListTile(
                            title: Row(
                              children: <Widget>[
                                Icon(Icons.content_copy, color: Colors.lightGreen,)
                                , Text( widget.question.data['Title'],
                                  style: TextStyle(
                                      fontSize: 17.0,fontWeight: FontWeight.w500),
                                  maxLines: 3,
                                )
                                ,],
                            ),
                            subtitle:
                            Padding(padding: EdgeInsets.only(left:20.0),
                              child: Text(widget.question.data['Body'],
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),),

                            )
                        ),
                        ListTile(
                            title: Row(
                              children: <Widget>[
                                Icon(Icons.calendar_today, color: Colors.lightGreen,)
                                , Text('Date asked',
                                  style: TextStyle(
                                      fontSize: 17.0,fontWeight: FontWeight.w500),
                                  maxLines: 3,
                                )
                                ,],
                            ),
                            subtitle:
                            Padding(padding: EdgeInsets.only(left:20.0),
                              child: Text(widget.question.data['Date'],
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),),

                            )
                        ),
                        ListTile(
                            title: Row(
                              children: <Widget>[
                                Icon(Icons.perm_identity, color: Colors.lightGreen,)
                                , Text('Asked by',
                                  style: TextStyle(
                                      fontSize: 17.0,fontWeight: FontWeight.w500),
                                  maxLines: 3,
                                )
                                ,],
                            ),
                            subtitle:
                            Padding(padding: EdgeInsets.only(left:20.0),
                              child: Text(widget.question.data['userId'],
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),),

                            )
                        ),

                      ]
                  ),
                ]
            )
        ));

  }
}
