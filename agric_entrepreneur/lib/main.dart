import 'package:agric_entrepreneur/Q&A.dart';
import 'package:agric_entrepreneur/courses.dart';
import 'package:agric_entrepreneur/downloads.dart';
import 'package:agric_entrepreneur/profile.dart';
import 'package:agric_entrepreneur/syllabus.dart';
import 'package:agric_entrepreneur/test.dart';
import 'package:agric_entrepreneur/timetable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Welcome.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();

 runApp(MyApp());
}
  User? status;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 
   @override
          void initState() {  
        super.initState();
        signInStatus().whenComplete((){
          setState(() {
          
               }
                  );
       });
      }

        signInStatus() async{
              try{
             FirebaseAuth.instance.authStateChanges().listen((User? user) {status = user;}) ;
              }
              catch(e){
                print(e);
              }
        }


  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme:  ThemeData(
        primaryColor: Colors.black,
      ),
      home:
      StreamBuilder(
           builder:  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(status == null){
                  return WelcomePage();
                }
                else return HomePage('title');
           }
           
         ),
       
        routes: <String, WidgetBuilder>{

      "/a": (BuildContext context) =>  Profile("new page"),
      "/b": (BuildContext context) => HomePage("new page"),
      "/c": (BuildContext context) => downloads("new page"),
      "/d": (BuildContext context) => syllabus("title"),
    //  "/e": (BuildContext context) => test("title"),
      "/f": (BuildContext context) => courses("title"),
      "/g": (BuildContext context) => syllabus("title"),
    },
    );
  }
}

 late String userID;
 late final DocumentSnapshot? userInfo;
late String? _email ;

 late final  User _user = FirebaseAuth.instance.currentUser!;


class HomePage extends StatefulWidget {


  final String title;
  HomePage(this.title);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? get title => null;


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
        try {
          userInfo = await FirebaseFirestore.instance
              .collection('User_information')
              .doc(_user.uid)
              .get().whenComplete(() => userID = _user.uid);
          
                  } catch (e) {
          print(e);
        }
      }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color(0xFF0D5035),
        appBar: AppBar(
          title:
          Text("agric Entrepreneur", style: TextStyle(fontSize: 13.0,color:  Colors.green[700])),
          centerTitle: true,
        ),

        drawer: Drawer(

          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Color(0xff8D6E63),
                  child: Icon(Icons.person),
                ),
                  accountName: Text('name'),              //  ('$_displayName'),
                accountEmail: Text('$_email'),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: <Color>[
                    Colors.green,
                    Colors.lightGreen,
                  ]
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home,
                  color: Colors.lightGreen,
                ),
                title: Text('Home', style: TextStyle(
                    fontSize: 17.0, fontStyle: FontStyle.normal),),
                onTap: () => Navigator.of(context).pushNamed('/b'),
              ),
              ListTile(
                title: Text('Profile', style: TextStyle(
                    fontSize: 17.0, fontStyle: FontStyle.normal),),
                leading: Icon(Icons.person,
                  color: Colors.lightGreen,),
                onTap: () => Navigator.of(context).pushNamed('/a'),
              ),
              ListTile(
                title: Text('Downloads', style: TextStyle(
                    fontSize: 17.0, fontStyle: FontStyle.normal),),
                  leading: Icon(Icons.cloud_download, color: Colors.lightGreen,),
                onTap: () => Navigator.of(context).pushNamed('/c'),

              ),
              ListTile(
                title: Text('Courses', style: TextStyle(
                    fontSize: 17.0, fontStyle: FontStyle.normal),),
                leading: Icon(Icons.library_books, color: Colors.lightGreen,),
                onTap: () => Navigator.of(context).pushNamed('/f'),
              ),
              ListTile(
                title: Text('Syllabus', style: TextStyle(
                    fontSize: 17.0, fontStyle: FontStyle.normal),),
                leading: Icon(Icons.book, color: Colors.lightGreen,),
                onTap: () => Navigator.of(context).pushNamed('/d'),
              ),
              ListTile(
                  title: Text('Close', style: TextStyle(
                      fontSize: 17.0, fontStyle: FontStyle.normal),),
                  leading: Icon(Icons.close, color: Colors.lightGreen,),
                  onTap: () => Navigator.of(context).pop()
              ),
              Divider(
                height: 20.0,
              ),

              ListTile(
                title: Text('Sign out', style: TextStyle(
                    fontSize: 17.0, fontStyle: FontStyle.normal),),
                onTap: _signOut,
              ),


            ],
          ),
        ),
        body: ListView(
            children: <Widget>[

              Container(
                child: FutureBuilder(
                   // future: _future,
                    builder: (context,AsyncSnapshot<FirebaseAuth> snapshot){
                      if (snapshot.connectionState==ConnectionState.done) {
                
  final Stream<QuerySnapshot> _usersStream = 
  FirebaseFirestore.instance.collection('User_information').where('userId', isEqualTo: userID).snapshots();

                        return  StreamBuilder(
                            stream: _usersStream,
                            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.connectionState ==
                               ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.green,
                                    )
                                );
                              }
                                    
                                           return new ListView(
                children:  snapshot.data!.docs.map (
                  (DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                                      return ListTile(
                                          title:
                                          Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(left: 15.0,right: 5.0,top: 57.0,bottom: 1.0),
                                                  child: Text('Hello',style: TextStyle(fontSize: 25.0,),
                                                  ),
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(left: 3.0,right: 5.0,top: 57.0,bottom: 1.0),
                                                    child: Text(data['Name'] + ',',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 25.0
                                                      ),
                                                    )
                                                )
                                              ]
                                    ),
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
                 
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.contain,
                        colorFilter: ColorFilter.mode(Colors.transparent.withOpacity(0.2), BlendMode.dstATop),
                        image:
                        AssetImage('assets/icons/53.jpg')
                    ),
                    shape: BoxShape.rectangle,
                    color: const Color(0xff7c94b6),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(90.0),
                      bottomRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(90.0),
                    ),
                    border: Border(
                    )
                ),
                height: 150.0,
              ),
              SizedBox(height:50.0),
              Container
                (
                padding: EdgeInsets.only(right: 15.0,left: 15),
                width: MediaQuery.of(context).size.width - 30.0,
                height: MediaQuery.of(context).size.height - 100.0,
                child: GridView.count(crossAxisCount: 2,
                    primary: false,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 15.0,
                    childAspectRatio: 0.7,
                    children: <Widget>[
                      InkWell(
                        onTap: () =>  Navigator.push(
                            context, MaterialPageRoute(builder: (context) =>courses(title!))),
                        child:
                        _buildCard('courses',
                            'assets/icons/28.jpg',
                            context),
                      ),
                      InkWell(
                        onTap: () =>  Navigator.push(
                            context, MaterialPageRoute(builder: (context) =>questions(title!, title: '',))),
                        child:
                        _buildCard('Q & A',
                            'assets/icons/q n a.jpg',
                            context),
                      ),
                      InkWell(
                        onTap: () =>  Navigator.push(
                            context, MaterialPageRoute(builder: (context) =>timetable(title!))),
                        child:
                        _buildCard('timetable',
                            'assets/icons/timetable.jpg',
                            context),
                      ),
                      InkWell(
                        /**   onTap: () =>  Navigator.push(
                              context, MaterialPageRoute(builder: (context) =>test(title!))), **/
                          child:
                          _buildCard('test',
                              'assets/icons/44.jpg',
                              context)
                      )

                    ]

                ),
              ),

            ]
        )
    );
  }

  Future<void> _signOut() async{
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => WelcomePage()));
    } catch (e) {
      print(e); // TODO: show dialog with error
    }
  }


  Widget _buildCard(String name,String imgPath, context) {
    return Padding(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
        child:
        Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 3.0,
                      blurRadius: 3.0)
                ],
                color: Colors.white),
            child: Column(
                children: [
                  Hero(
                      tag: imgPath,
                      child: Container(
                          height: 183.0,
                          width: 140.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(imgPath),
                                  fit: BoxFit.contain)))),
                  SizedBox(height: 6.0),
                  Text(name, style: TextStyle(
                      color: Colors.lightGreen,
                      fontSize: 14.0)),
                ]
            )
        )

    );
  }
}
