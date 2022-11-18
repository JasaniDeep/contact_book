import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class edit extends StatefulWidget {

  int id;
  Database? database;
  String name,contact,image;
  edit(this.id,this.name, this.contact,this.image,this.database);

  @override
  State<edit> createState() => _editState();
}

class _editState extends State<edit> {
  TextEditingController t1=TextEditingController();
  TextEditingController t2=TextEditingController();
  String image="";

  @override
  void initState() {
    super.initState();
    t1.text=widget.name;
    t2.text=widget.contact;
    image=widget.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
            Container(
              height: 100,
              width: 100,
              child:Image.memory(base64Decode("$image"))
            ),

          ],
        ),
      ),
    );
  }
}
