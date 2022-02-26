import 'package:flutter/material.dart';
import 'package:todolist/pages/add.dart';

import 'package:http/http.dart' as http; //as http คือตั้งชื่อเล่น อันนี้ไปติดตั้งที่ pubspec.yaml depedencies แล้ว
import 'dart:async';
import 'dart:convert';

import 'package:todolist/pages/update_todolist.dart';

class Todolist extends StatefulWidget {
  //const Todolist({ Key? key }) : super(key: key);

  @override
  _TodolistState createState() => _TodolistState();
}

class _TodolistState extends State<Todolist> {
  List todolistitems = ['A', 'B', 'C', 'D'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTodolist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddPage()))
              .then((value) {
            setState(() {
              getTodolist();
            }); // ใส่ .then**** เพื่อ refresh หน้า app เมื่อ back กลับมา
          });
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('All Todolist'),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  getTodolist();
                });
              },
              icon: Icon(
                Icons.refresh,
                color: Colors.green,
              ))
        ],
      ),
      body: todolistCreate(),
    );
  }

  Widget todolistCreate() {
    return ListView.builder(
        itemCount: todolistitems.length,
        itemBuilder: (context, index) {
          return Card(
              child: ListTile(
                title: Text(
                  "${todolistitems[index]['title']}",
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdatePage(
                        todolistitems[index]['id'],
                        todolistitems[index]['title'],
                        todolistitems[index]['detail']))).then((value) {
                          setState(() {
                  //ใส่ if...และ snackbar  ....โดยที่ใส่ 'delete' เพิ่มที่ navigator.pop จากการกดปุ่มลบ
                            print(value);
                            if (value == 'delete') {
                              final snackBar = SnackBar(
                                content: const Text('ลบรายการเรียบร้อยแล้ว'),
                      
                              );

                    // Find the ScaffoldMessenger in the widget tree
                    // and use it to show a SnackBar.
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                            getTodolist();
                          }); // ใส่ .then**setState**getTodolist** เพื่อ refresh หน้า app เมื่อ back กลับมา
                        });
                },
              ));
        }
    );
  }

  Future<void> getTodolist() async {
    List alltodo = [];
    var url = Uri.http('192.168.1.35:8000', '/api/all-todolist');
    var response = await http.get(url);
    //var result = json.decode(response.body);
    var result = utf8.decode(response.bodyBytes);
    print(result);
    setState(() {
      //todolistitems = result;
      todolistitems = jsonDecode(result);
    });
  }
}
