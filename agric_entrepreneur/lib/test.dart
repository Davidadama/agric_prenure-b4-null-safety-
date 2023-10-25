/** 
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class test extends StatefulWidget {
  final String title;
  const test(String s,  {Key key, this.title}) : super(key: key);

  @override
  _testState createState() => _testState();
}

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
class _testState extends State<test> {

  String _path;
  String _extension;
  Map<String, String> _paths;
  FileType _pickType;
  bool _multiPick = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<StorageUploadTask> _tasks = <StorageUploadTask>[];

  Key get key => null;


//dropdown function
  dropDown() {
    return DropdownButton(
        hint: Text('Select'),
        value: _pickType,
        items: <DropdownMenuItem>[
          DropdownMenuItem(
            child: Text('Image'),
            value: FileType.image,
          ),
          DropdownMenuItem(
            child: Text('Audio'),
            value: FileType.audio,
          ),
          DropdownMenuItem(
            child: Text('Video'),
            value: FileType.video,
          ),
          DropdownMenuItem(
            child: Text('Any'),
            value: FileType.any,
          ),
        ],
        onChanged: (value) {
          setState(() {
            _pickType = value;
          });
        }
    );
  }

  //file_explorer function
  void openFileExplorer() async {
      try {
      _path = null;
      if (_multiPick){
      _paths = await FilePicker.getMultiFilePath(type: _pickType, allowedExtensions:( _extension?.isNotEmpty??false)?
                  _extension?.replaceAll(' ', ' ')?.split(','): null
      );

      }
      else{
      _path = await FilePicker.getFilePath(type: _pickType, allowedExtensions: (_extension?.isNotEmpty?? false)?
                  _extension?.replaceAll(' ', ' ')?.split(','): null            
      );
      }

      uploadToFirebase();
      }

      on PlatformException catch (e){
      print('Unsupported operation' + e.toString());
      }
      if (!mounted) return;
      }

//upload_to_firebase_function
  uploadToFirebase(){
if(_multiPick){
  _paths.forEach((fileName, filePath) => {
    upload(fileName,filePath)
  }
  );
}
else{
  String fileName = _path.split('.').last;
  String filePath = _path;
  upload(fileName, filePath);
}
  }

  //upload operation
  Future<String>  upload(fileName, filePath) async {
      _extension = fileName
          .split('.')
          .last;
      StorageReference storageReference = FirebaseStorage.instance.ref().child(fileName);

  //task to put selected file in firebase
      final StorageUploadTask uploadTask = storageReference.putFile(File(filePath));

          StorageMetadata(contentType: '$_pickType/$_extension');

      setState(() {
        _tasks.add(uploadTask);
      });

      //we get the download url of uploaded file after upload is complete
    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

    String url = downloadUrl.toString();

    //add download url to firestore so it can be viewed in a stream
    await Firestore.instance.collection('images').add({'name': fileName, 'downloadUrl': url});


    }
  void showToast() {
    Fluttertoast.showToast(
        msg: 'upload complete',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 2,
        backgroundColor: Colors.green,
        textColor: Colors.white
    );
  }
// download(uploaded) function
  Future<void> downloadFile(StorageReference ref) async{
    final String url = await ref.getDownloadURL();
    final http.Response downloadData = await http.get(url);
    final Directory systemTempDir = Directory.systemTemp;
    final File tempfile = File('${systemTempDir.path}/tmp.jpg');

    if(tempfile.existsSync()){
      await tempfile.delete();
    }
    await tempfile.create();
    final StorageFileDownloadTask task =ref.writeToFile(tempfile);
    final int byteCount = (await task.future).totalByteCount;
    var bodyBytes = downloadData.bodyBytes;
    final String name = await ref.getName();
    final String path = await ref.getPath();
    print(
      'Success\nDownloaded $name\nUrl: $url\nPath:$path\nBytes Count:byteCount');
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.white,
      content: Image.memory(bodyBytes,
      fit: BoxFit.fill),

    ));
  }


  @override
  Widget build(BuildContext context) {

    final List<Widget> children = <Widget>[];

    _tasks.forEach((StorageUploadTask task){

      final Widget tile = uploadTaskList(key,task,

                () {setState(() {_tasks.remove(task);});},

                () {downloadFile(task.lastSnapshot.ref);}
      );
      children.add(tile);
    });

    return new Scaffold(
       key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Test',style: TextStyle(color: Colors.green[400]),),
          centerTitle: true,
        ),
        body:

        Column(
          children: <Widget>[
            dropDown(),
            SwitchListTile.adaptive(
              title: Text(
                  'select multiple files'
              ),
              value: _multiPick,
              onChanged: (bool value){
                setState(() {
                  _multiPick = value;
                });
              },
            ),

            OutlineButton(
                child: Text('open file explorer'),
                onPressed: (){
                  openFileExplorer();
                }
            ),
            SizedBox(height: 20.0,),
            Flexible(
                child: ListView(
                  children: children,
                )
            )

          ],
        )
    );
  }

}
 class uploadTaskList extends StatelessWidget{


  const uploadTaskList(Key key, this.task, this.onDismissed, this.onDownload)

      : super(key: key);

  final StorageUploadTask task;
  final VoidCallback onDismissed;
  final VoidCallback onDownload;
  

//uploading status
  String get status {
    String result;
    if (task.isComplete){

      if(task.isSuccessful){
        result = 'Complete';
      }

      else if (task.isCanceled){
        result = 'Cancelled';
      }

      else{
        result = 'Failed Error ${task.lastSnapshot.error}';
      }

      if(task.isInProgress){
      result = 'Uploading';
    }
      else if(task.isPaused){
        result = 'Paused';
      }
      return result;
    }
    //return result;
  }


  String bytesTransferred(StorageTaskSnapshot snapshot){
    return '${snapshot.bytesTransferred}/${snapshot.totalByteCount}';
  }

  @override
    Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<StorageTaskEvent>(
      stream: task.events,
      builder: (BuildContext context, AsyncSnapshot<StorageTaskEvent> asyncSnapshot){
      Widget   subtitle;
      if (asyncSnapshot.hasData){
        final StorageTaskEvent event = asyncSnapshot.data;
        final StorageTaskSnapshot snapshot = event.snapshot;

        subtitle = Text('$status: ${bytesTransferred(snapshot)}bytes sent');
      }
      else{
        subtitle = Text('Starting...');
      }

      return
          Dismissible(
              key: Key(task.hashCode.toString()),
              onDismissed: (_) => onDismissed(),
          child: ListTile(
            title: Text('upload task ${task.hashCode}'),
            subtitle: subtitle,
            trailing:
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Offstage(
                  offstage: !task.isInProgress,
                  child: IconButton(
                      icon: Icon(Icons.pause
                      ), onPressed: () => task.pause()),
                ),
               Offstage(
                  offstage: !task.isInProgress,
                  child: IconButton(
                      icon: Icon(Icons.cancel
                      ), onPressed: () => task.cancel()),
                ),

                Offstage(
                  offstage: !task.isPaused,
                  child: IconButton(
                      icon: Icon(Icons.file_upload
                      ), onPressed: () => task.resume()),
                ),
           /**     Offstage(
                  offstage: !task.isComplete,
                  child: IconButton(
                      icon: Icon(Icons.cancel
                      ), onPressed: () => task.cancel()),
                ),**/
                Offstage(
                  offstage: !(task.isComplete && task.isSuccessful),
                  child: IconButton(
                      icon: Icon(Icons.file_download
                      ), onPressed: () => onDownload
                  ),
                )
              ],
            ),
          )
          );
      }
    );
  }
 }
 
 **/