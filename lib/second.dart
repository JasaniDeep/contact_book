import 'dart:convert';

import 'package:contact_book/edit.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common/sqlite_api.dart';

class second extends StatefulWidget {
  Database? database;
  second(this.database);

  @override
  State<second> createState() => _secondState();
}

class _secondState extends State<second> {
  List name = [];
  List contact = [];
  List image = [];
   Future get_data()
  async {
    String qry="select * from contact_book";
    print(qry);
    List list=[];
    list=await widget.database!.rawQuery(qry);
    return list;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("contact book"),),
      body: FutureBuilder(future: get_data(),builder: (context, snapshot) {
        if(snapshot.connectionState==ConnectionState.done)
        {
          List<Map> mylist=snapshot.data as List<Map>;
          return ListView.builder(itemCount:mylist.length,itemBuilder: (context, index) {
            Map m=mylist[index];

            return Card(
                elevation: 7,
                color: Color(0xFFD99559),
                shadowColor: Color(0xFF261615),
                margin: EdgeInsets.all(8),
                child:ListTile(
                  hoverColor: Color(0xFFF6B352),
                  title: Text("${m['name']}"),
                subtitle: Text("${m['contact']}"),
                leading: Image.memory(base64Decode("${m['image']}")),
                  trailing: Column(
                    children: [
                      Expanded(child: IconButton(onPressed: () async {
                        String del="delete from contact_book where id=${m['id']}";
                        print(del);
                        int d= await widget.database!.rawDelete(del);
                        print(d);
                        if(d==1) {
                          setState(() {});
                        }
                        else
                        {
                          print("not deleted");
                        }
                      }, icon:Icon(Icons.delete))),
                      Expanded(child: IconButton(onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return edit(m['id'],m['name'],m['contact'],m['image'],widget.database);
                        },));
                      }, icon:Icon(Icons.edit)))
                    ],
                  ),
              )

            );
          },);
        }
        else
        {
          return Center(child: CircularProgressIndicator(),);
        }
      },
      ),
    );
  }
}
