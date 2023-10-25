import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import './questionsView.dart' as questionsView;


final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
late String userID,uid;


class questions extends StatefulWidget {
  final String title;

  const questions(String s,  { Key? key,  required this.title}) : super(key: key);

  @override
  _questionsState createState() => _questionsState();
}


late String _title,_body,_title1,_body1;

class _questionsState extends State<questions> with SingleTickerProviderStateMixin {

  late TabController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    super.initState();
    controller = new TabController(vsync:this, length: 2);
  }
  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:
        Row(
          children: [
           // Text('Questions',style: TextStyle(color: Colors.green[400], fontSize: 17.0),),
            SizedBox(width: 155.0,),
            IconButton(icon: Icon(Icons.search), onPressed: (){}),
            SizedBox(width: 15.0,),
           IconButton(icon: Icon(Icons.add), onPressed: (){questionDialog1(context);}),
          ],
        ),

        centerTitle: true,
      bottom: TabBar(
       controller: controller,
        tabs: [
          Tab(icon: Icon(Icons.question_answer_outlined),
            child: Text('questions'),
          ),
          Tab(icon: Icon(Icons.question_answer),
            child: Text('my questions'),
          )
        ],
      ),
      ),
      body: TabBarView(
        controller: controller,
        children: [
          ListPage(),
          questionsView.allquestions('title')
        ],
      )


    );
  }
}

class ListPage extends StatefulWidget
{

  @override
  _ListPageState createState() => _ListPageState();

}

class _ListPageState extends State<ListPage>
{

  @override
  Widget build(BuildContext context) {
    return
      Container(
        child:
        FutureBuilder(
            
            builder: (context,AsyncSnapshot<FirebaseAuth> snapshot){
              if (snapshot.connectionState==ConnectionState.done) {
                
                 final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('Questions')
                            .snapshots();


                return  StreamBuilder(
                    stream: _usersStream,
                    builder: (context, snapshot) {

                      if(!snapshot.hasData){
                        return Center(
                          // ignore: missing_return
                          child: Text('No question has been asked'),
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
                      return new ListView(

                        children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                    
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
                                            Icon(Icons.question_answer,color: Colors.green,),
                                            Text('Answer')
                                          ],
                                        )
                                    ),
                                    PopupMenuItem<String>(
                                        value: '2',
                                        child:
                                        Row(
                                          children: <Widget>[
                                            Icon(Icons.zoom_in,color: Colors.green,),
                                            Text('View Answers')
                                          ],
                                        )
                                    ),
                                  ],
                                  onSelected: (retValue) {
                                    if (retValue == '1') {
                                     answerDialog1(context,document);
                                    }
                              if (retValue == '2') {
                             answersDialog(context,document);
                               }
                              }

                              );
                            }
                            return ListTile(
                              onTap: (){navigateToDetail(document);},
                              title: Text(data['Title'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17.0,
                                ),
                              ),

                              subtitle: Text(data['Date']),
                              trailing:
                              popupMenuButton(),
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
        )
    );
  }
 //for questions
  navigateToDetail(DocumentSnapshot questions){
    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(question: questions)));
}
//for answer
  navigateAnswersDetail(DocumentSnapshot answer){
    Navigator.push(context, MaterialPageRoute(builder: (context) => AnswerDetail(answer: answer)));
  }
  Future<dynamic> answersDialog(BuildContext context,selectedDoc) async{

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {

          return AlertDialog(
               // insetPadding: EdgeInsets.symmetric(horizontal: 0.0,vertical: 100.0),
              title:
              Row(
                  children:<Widget>[
                    Text('Responses',
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
              Container(
                  child:
                  FutureBuilder(
                      builder: (context,AsyncSnapshot<FirebaseAuth> snapshot){
                        if (snapshot.connectionState==ConnectionState.done) {
                         
                          return  StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('Questions').doc(selectedDoc).collection('Answer').snapshots(),
                              builder: (context, snapshot) {

                                if(!snapshot.hasData){
                                  return Center(
                                    // ignore: missing_return
                                    child: Text('No reponse(s) yet'),
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
                                          onTap: (){navigateAnswersDetail(snapshot.data.documents[index]);},
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

                        return Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.green,
                            )
                        );
                      }
                  )
              )
          );

        }

    );
  }
}
Future<void> _userDetails(userID) async {
  final userDetails = await getData(userID);
  setState (() {
    uid = userDetails.toString();
    Text(uid);
  }
  );
}

getData(userID) async{
  DocumentSnapshot result = await Firestore.instance.collection('Questions').document(userID).get();
  return result;
}


//dialog for asking questions
Future<dynamic> questionDialog1(BuildContext context) async{
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
          Row(
              children:<Widget>[
                Text('Ask a question',
                    style: TextStyle(
                        fontSize: 17.0)),
                SizedBox(width: 0.0,),
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
                            maxLength: 40,
                            maxLines: 2,
                            // ignore: missing_return
                            validator: (input){
                              if (input!.isEmpty) {
                                return 'Please Enter Question title';
                              }
                            },
                            onSaved: (input) => _title = input!,
                            decoration: InputDecoration(
                              labelText: 'Title',
                              hintText: 'Livestock farming',

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
                            maxLines: 5,
                            // ignore: missing_return
                            validator: (input){
                              // ignore: missing_return
                              if (input!.isEmpty) {
                                return 'Please enter question body';
                              }
                            },
                            onSaved: (input) => _body = input! ,
                            decoration: InputDecoration(
                              labelText: 'Body',
                              hintText: 'What is livestock farming all about? Examples,places where its practised,'
                                  'profit and economic importance'
                                  'will really appreciate a response.Thanks',

                                   hintMaxLines: 4,

                              labelStyle: TextStyle(
                                  fontSize: 17.0,
                                  fontStyle: FontStyle.normal
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height:75.0),
                        ElevatedButton(
                          onPressed: (){
                            if (_formkey.currentState!.validate()) {
                              //no error in validator
                              _formkey.currentState!.save();
                              AddTo_Database();
                              // showToast();
                              Navigator.pop(context);


                            }
                            else{
                              //validation error
                              setState(() {
                                var _validate = true;
                              });
                            }
                            

                          },
                          child: Text('Ask'),

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

void setState(Null Function() param0) {
}

//dialog for answering question
Future<dynamic> answerDialog1(BuildContext context,selectedDoc) async{
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {

        return AlertDialog(
          title:
          Row(
              children:<Widget>[
                Text('Respond',
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
                            maxLines: 3,
                            // ignore: missing_return
                            validator: (input){
                              if (input!.isEmpty) {
                                return 'Please Enter answer title';
                              }
                            },
                            onSaved: (input) => _title1 = input!,
                            decoration: InputDecoration(
                              labelText: 'Title',
                              hintText: 'you should use the same title as that of the question {what is livestock farming?}',

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
                            maxLines: 5,
                            // ignore: missing_return
                            validator: (input){
                              // ignore: missing_return
                              if (input!.isEmpty) {
                                return 'Please enter answer body';
                              }
                            },
                            onSaved: (input) => _body1  = input! ,
                            decoration: InputDecoration(
                              labelText: 'Body',
                              hintText: 'livestock farming is simply the management and breeding of domestic, livestock or farm animals for the purpose of'
                                  'obtaining their...',
                              hintMaxLines: 5,
                              labelStyle: TextStyle(
                                  fontSize: 17.0,
                                  fontStyle: FontStyle.normal
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height:75.0),
                        ElevatedButton(
                          onPressed: (){
                            if (_formkey.currentState!.validate()) {
                              //no error in validator
                              _formkey.currentState!.save();
                              AddTo_Database1(selectedDoc);
                              Navigator.pop(context);
                              // showToast();
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




//function to add question to database/
AddTo_Database() {
  if (_formkey.currentState!.validate()) {
    //no error in validator
    _formkey.currentState!.save();

    //  showToast ();

    FirebaseFirestore.instance.runTransaction((Transaction transaction) async{
      CollectionReference reference = FirebaseFirestore.instance.collection('Questions');

      await reference.add({
        "userId": userID ,
        "Title": "$_title",
        "Body": "$_body",
        "Date": "${DateTime.now()}",

      });
    });
  }
  else{
    //validation error
    setState(() {
      var  _validate = true;
    }
    );
  }

}

//function to add answer to database
AddTo_Database1(selectedDoc) {
  if (_formkey.currentState!.validate()) {
    //no error in validator
    _formkey.currentState!.save();
    //  showToast ();

    FirebaseFirestore.instance.runTransaction((Transaction transaction) async{
      CollectionReference reference = FirebaseFirestore.instance.collection('Questions').
      doc(selectedDoc).collection('Answer');

      await reference.add({
          "userId":userID ,
        "Title": "$_title1",
        "Answer": "$_body1",
        "Date": "${DateTime.now()}",

      });
    });
  }
  else{
    //validation error
    setState(() {
      var  _validate = true;
    }
    );
  }
}


//for questions
class DetailPage extends StatefulWidget {
  final DocumentSnapshot question;

  DetailPage({required this.question});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Question Details',
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

//for answer
class AnswerDetail extends StatefulWidget {
  final DocumentSnapshot answer;

  AnswerDetail({required this.answer});

  @override
  _AnswerDetailState createState() => _AnswerDetailState();
}

class _AnswerDetailState extends State<AnswerDetail> {

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
                                , Text('Answer to'' '+widget.answer.data['Title'],
                                  style: TextStyle(
                                      fontSize: 17.0,fontWeight: FontWeight.w500),
                                  maxLines: 3,
                                )
                                ,],
                            ),
                            subtitle:
                            Padding(padding: EdgeInsets.only(left:20.0),
                              child: Text(widget.answer.data['Answer'],
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),),

                            )
                        ),
                        ListTile(
                            title: Row(
                              children: <Widget>[
                                Icon(Icons.calendar_today, color: Colors.lightGreen,)
                                , Text('Date answered',
                                  style: TextStyle(
                                      fontSize: 17.0,fontWeight: FontWeight.w500),
                                  maxLines: 3,
                                )
                                ,],
                            ),
                            subtitle:
                            Padding(padding: EdgeInsets.only(left:20.0),
                              child: Text(widget.answer.data['Date'],
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),),

                            )
                        ),
                        ListTile(
                            title: Row(
                              children: <Widget>[
                                Icon(Icons.perm_identity, color: Colors.lightGreen,)
                                , Text('Answered by',
                                  style: TextStyle(
                                      fontSize: 17.0,fontWeight: FontWeight.w500),
                                  maxLines: 3,
                                )
                                ,],
                            ),
                            subtitle:
                            Padding(padding: EdgeInsets.only(left:20.0),
                              child: Text(widget.answer.data['userId'],
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


