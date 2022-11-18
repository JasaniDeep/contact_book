import 'dart:convert';
import 'dart:io';

import 'package:contact_book/second.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class first extends StatefulWidget {
  const first({Key? key}) : super(key: key);

  @override
  State<first> createState() => _firstState();
}

class _firstState extends State<first> {
  TextEditingController t1=TextEditingController();
  TextEditingController t2=TextEditingController();
  Database? database;
  bool t=false;
  XFile? image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
        get_data();
  }
  get_data()
  async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'contact_book.db');
// open the database
     database= await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE contact_book (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, contact TEXT,image TEXT)');
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contact Book"),),
      body: SingleChildScrollView(
        child:  Column(
          children: [
            Container(
              height: 60,
              width: double.infinity,
              margin: EdgeInsets.all(10),
              child: TextField(
                controller: t1,
                decoration: InputDecoration(
                  labelText: "Enter Name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(40)),),
                ),
              ),
            ),
            Container(
              height: 60,
              width: double.infinity,
              margin: EdgeInsets.all(10),
              child: TextField(
                controller: t2,
                decoration: InputDecoration(
                  labelText: "Enter Contact",
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(40)),),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                showDialog(context: context, builder: (context){
                  return AlertDialog(title: Text("select camera or gallery"),
                    actions: [
                      TextButton(onPressed: () async {
                        image = await _picker.pickImage(source: ImageSource.gallery);
                        setState((){
                          t=true;
                        });
                        Navigator.pop(context);
                      }, child: Text("gallery")),
                      TextButton(onPressed: () async {
                        image = await _picker.pickImage(source: ImageSource.camera);
                        setState((){
                          t=true;
                        });
                        Navigator.pop(context);
                      }, child: Text("camera"))
                    ],
                  );
                });
              },
              child: Container(
                height: 100,
                width: 100,
                child: (t==true)? Image.file(File(image!.path)) : Icon(Icons.supervised_user_circle,size: 60,),
              ),
            ),
            ElevatedButton(onPressed: () async{
              String str1,str2,img;
              str1=t1.text;
              str2=t2.text;
              img=base64Encode(await image!.readAsBytes());
              String sql="insert into contact_book values(null,'$str1','$str2','$img')";
              print(sql);
              int r_id;
              r_id=await database!.rawInsert(sql);
              print(r_id);

            }, child: Text("submit")),
            ElevatedButton(onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                return second(database);
              },));
            }, child: Text("View Conatct"))
          ],
        ),
      )
    );
  }
}
