import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';



final GlobalKey<FormState> _formkey = GlobalKey<FormState>();


class courses extends StatefulWidget {
  final String title;
  const courses(String s,  {Key key, this.title}) : super(key: key);

  @override
  _coursesState createState() => _coursesState();
}


class _coursesState extends State<courses> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Courses',style: TextStyle(color: Colors.green[400]),),
        centerTitle: true,
      ),
      body: ListPage(),

    );
  }
}

class ListPage extends StatefulWidget
{

  @override
  _ListPageState createState() => _ListPageState();

}

/**final errandController = TextEditingController();
final descriptionController = TextEditingController();
final timeController = TextEditingController();
final payController = TextEditingController();
final locationController = TextEditingController();
final mobileController = TextEditingController();
**/


class _ListPageState extends State<ListPage>
{
  Future<FirebaseUser> _future;
  @override
  void initState(){
    _future = FirebaseAuth.instance.currentUser();
    super.initState();
  }

  navigateToDetail(DocumentSnapshot errand){
    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(errand: errand)));
  }
  late String userID,uid;
@override
  Widget build(BuildContext context) {
    return Container(
        child:
        FutureBuilder(
            future: _future,
            builder: (context,AsyncSnapshot<FirebaseUser> snapshot){
              if (snapshot.connectionState==ConnectionState.done) {
                userID = snapshot.data.uid;
                _userDetails(userID);
                return  StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('Courses').snapshots(),
                    builder: (context, snapshot) {

                      if(!snapshot.hasData){
                        return Center(
                          // ignore: missing_return
                          child: Text('No course is available at this time'),
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

                            Widget popupMenuButton() {
                              return PopupMenuButton<String>(

                                  icon: Icon(Icons.more_vert,
                                    color: Colors.green,
                                    size: 25.0,),
                                  itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[

                                    PopupMenuItem<String>(
                                        value: '1',
                                        child:
                                        Row(
                                          children: <Widget>[
                                            Icon(Icons.update,color: Colors.green,),
                                            Text('Duration')
                                          ],
                                        )
                                    ),
                                    PopupMenuItem<String>(
                                        value: '2',
                                        child:
                                        Row(
                                          children: <Widget>[
                                            Icon(Icons.directions_transit,color: Colors.green,),
                                            Text('prerequisite'),
                                          ],
                                        )

                                    ),
                                    PopupMenuItem<String>(
                                        value: '3',
                                        child:
                                        Row(
                                          children: <Widget>[
                                            Icon(Icons.view_agenda,color: Colors.green,),
                                            Text('overview')
                                          ],
                                        )
                                    ),
                                        PopupMenuItem<String>(
                                        value: '4',
                              child:
                              Row(
                              children: <Widget>[
                              Icon(Icons.question_answer,color: Colors.green,),
                              Text('Expectded learning outcome')
                              ],
                              )
                              )
                                  ],
                                  onSelected: (retValue) {
                                    if (retValue == '1') {
                                      showDialog(context: context,
                                          builder: (context) =>
                                              AlertDialog(
                                                title: Text('duration',style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize:20,
                                                )),

                                                content: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(snapshot.data.documents[index]['Duration']
                                                    )
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                  context)
                                                              // ignore: missing_return
                                                                  .pop(),
                                                          child:  Text('CANCEL',style: TextStyle(
                                                              color: Colors.green
                                                          ),)
                                                      ),
                                                      SizedBox(
                                                        height: 60.0,)
                                                    ],
                                                  ),

                                                ],
                                              )
                                      );

                                    }
                                    if (retValue == '2') {
                                      showDialog(context: context,
                                          builder: (context) =>
                                              AlertDialog(
                                                title: Text('prerequisite',style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize:20,
                                                )),
                                                content: Row(
                                                  children: [
                                                    Text(snapshot.data.documents[index]['prerequisite'],style: TextStyle(
                                                      fontSize: 17
                                                    ),
                                                    )
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      TextButton(
                                                          onPressed: () => Navigator.of(context)
                                                              // ignore: missing_return
                                                                  .pop(),
                                                          child:  Text('CANCEL',style: TextStyle(
                                                              color: Colors.green
                                                          ),)
                                                      ),
                                                      SizedBox(
                                                        height: 60.0,)
                                                    ],
                                                  ),

                                                ],
                                              )
                                      );
                                    }
                                    if (retValue == '3') {
                                      showDialog(context: context,
                                          builder: (context) =>
                                              AlertDialog(
                                                title: Text('overview',style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize:20,
                                                )),

                                                scrollable: true,
                                                content: Column(
                                                  children: [
                                                Text(snapshot.data.documents[index]['overview']
                                                )
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                  context)
                                                                  // ignore: missing_return
                                                                  .pop(),
                                                          child:  Text('CANCEL',style: TextStyle(
                                                              color: Colors.green
                                                          ),)
                                                      ),
                                                      SizedBox(
                                                        height: 60.0,)
                                                    ],
                                                  ),

                                                ],
                                              )
                                      );
                                    }
                                    if (retValue == '4') {
                                      showDialog(context: context,
                                          builder: (context) =>
                                              AlertDialog(
                                                title: Text('expected learning outcome',style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize:20,
                                                )),
                                                scrollable: true,
                                                content: Column(
                                                  children: [
                                                    Text(snapshot.data.documents[index]['Expected learning outcome']
                                                    )
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      FlatButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                  context)
                                                              // ignore: missing_return
                                                                  .pop(),
                                                          child:  Text('CANCEL',style: TextStyle(
                                                              color: Colors.green
                                                          ),)
                                                      ),
                                                      SizedBox(
                                                        height: 60.0,)
                                                    ],
                                                  ),

                                                ],
                                              )
                                      );

                                    }

                                  }
                              );
                            }
                            return ListTile(
                              onTap: (){navigateToDetail(snapshot.data.documents[index]);},
                              title: Text(snapshot.data.documents[index]['Title'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17.0,
                                ),
                              ),

                              subtitle: Text(snapshot.data
                                  .documents[index]['course_load']),
                              trailing:
                              popupMenuButton(),
                            );
                          }

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
        )
    );
  }
  String userDetails;
  Future<void> _userDetails(userID) async {
    final userDetails = await getData(userID);
    setState (() {
      uid = userDetails;
      Text(uid);
    }
    );
  }
  getData(userID) async{
    DocumentSnapshot result = await FirebaseFirestore.instance.collection('Courses').doc(userID).get();
    return result;
  }


}

class DetailPage extends StatefulWidget {
  final DocumentSnapshot errand;

  DetailPage({this.errand});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Details',
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
                                , Text('Content ',
                                  style: TextStyle(
                                      fontSize: 17.0,fontWeight: FontWeight.w500),
                                  maxLines: 3,
                                )
                                ,],
                            ),
                            subtitle:
                            Padding(padding: EdgeInsets.only(left:23.0),
                              child: Text(widget.errand.data['Content'],
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

