import 'dart:convert';
import 'dart:io';
import 'package:md5_plugin/md5_plugin.dart' as crypto;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:md5_plugin/md5_plugin.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  File imageFile;

  var ret = '';

  TextEditingController priceController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController description = TextEditingController();
  String dropdownValue = "ماگ";

  Color responseColor;
  String responseText;
  String category = "ماگ";
  bool sendCheck = true;
  int number = 2;
  Color goodColor = Colors.greenAccent[700];
  Color badColor = Colors.redAccent[700];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body:  Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text("No Image Selected !"),
              _decidedImageView(),
              RaisedButton(
                onPressed: () {
                  _showChoiceDialog(context);
                },
                child: Text("Select Image"),
              ),
              RaisedButton(
                onPressed: () {
                  calculateMD5SumAsyncWithPlugin(imageFile.path);
                },
                child: Text("MD5some"),
              ),
              RaisedButton(
                onPressed: () {
                  _asyncFileUpload('text' , imageFile);
                },
                child: Text("MD5some"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> calculateMD5SumAsyncWithPlugin(String filePath) async {

    var file = File(filePath);
    if (await file.exists()) {
      try {
        ret = await Md5Plugin.getMD5WithPath(filePath);
      } catch (exception) {
        print('Unable to evaluate the MD5 sum :$exception');
        return null;
      }
    } else {
      print('`$filePath` does not exits so unable to evaluate its MD5 sum.');
      return null;
    }
    return ret;
  }

  _asyncFileUpload(String text, File file) async{
    //create multipart request for POST or PATCH method
    var request = http.MultipartRequest("POST", Uri.parse("127.0.0.1:8000/api/add/"));
    //add text fields
    request.fields["text_field"] = text;
    //create multipart using filepath, string or bytes
    var pic = await http.MultipartFile.fromPath("file_field", file.path);
    //add multipart to request
    request.files.add(pic);
    var response = await request.send();

    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
  }

  _openGallery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  Widget _decidedImageView() {
    if(imageFile == null){
      return Text("no Image Selected !");
    }else{
      return Image.file(imageFile , width: 400.0, height: 400.0,);
    }
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Make a Choice !"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _openGallery(context);
                    },
                    child: Text(
                      'Gallery',
                      style:
                      TextStyle(color: Colors.blueAccent, fontSize: 18.0),
                    ),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      _openCamera(context);
                    },
                    child: Text('Camera',
                        style: TextStyle(
                            color: Colors.blueAccent, fontSize: 18.0)),
                  )
                ],
              ),
            ),
          );
        });
  }
}
