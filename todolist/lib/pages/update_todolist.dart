import 'package:flutter/material.dart';
// http method package 3 รายการ
import 'package:http/http.dart'
    as http; //as http คือตั้งชื่อเล่น อันนี้ไปติดตั้งที่ pubspec.yaml depedencies แล้ว
import 'dart:async';
import 'dart:convert';

class UpdatePage extends StatefulWidget {
  final v1, v2, v3;
  const UpdatePage(this.v1, this.v2, this.v3);

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  var _v1, _v2, _v3;
  TextEditingController todo_title = TextEditingController();
  TextEditingController todo_detail = TextEditingController();

  @override
  void initState() {
    //ดึงข้อมูลตอนเริ่มต้น
    // TODO: implement initState
    super.initState();
    _v1 = widget.v1; //id
    _v2 = widget.v2; //title
    _v3 = widget.v3; //detail
    todo_title.text = _v2;
    todo_detail.text = _v3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไข'),
        actions: [
          IconButton(
              onPressed: () {
                print("Delete ID: $_v1");
                deleteTodo();
                Navigator.pop(context, 'delete'); //เหมือนการกด back ถอยออกไปเลย
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TextField(
                controller: todo_title,
                decoration: InputDecoration(
                    labelText: 'รายการที่ต้องทำ',
                    border: OutlineInputBorder())),
            SizedBox(
              height: 30,
            ),
            TextField(
                minLines: 4,
                maxLines: 8,
                controller: todo_detail,
                decoration: InputDecoration(
                    labelText: 'รายละเอียด', border: OutlineInputBorder())),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  print('------------');
                  print('title: ${todo_title.text}');
                  print('detail: ${todo_detail.text}');
                  updateTodo();
                  
                  final snackBar = SnackBar(
                      content: const Text('อัพเดทรายการเรียบร้อยแล้ว'),);
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  
                  
                  
                  
                  },
                child: Text("แก้ไข"),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.fromLTRB(50, 20, 50, 20)),
                    textStyle:
                        MaterialStateProperty.all(TextStyle(fontSize: 20))),
              )             
            )
          ]),
      ),
          
    );
  }
  
      
    
  

  Future updateTodo() async {
    //async คือฟังก์ชั่นที่ใช้สำหรับลักษณะการทำงานที่ต้องรอระยะเวลา เนื่องจากแอปจะทำงานเป็น loop refresh หน้าตลอดเวลา
    // มีการ request หรือ post ขึ้นไปมันจะมีช่วงระบะเวลาที่มันต้องรอเวลาจากการ response ของทาง server

    //var url = Uri.https('9168-2403-6200-8890-c3dd-b9f2-4349-7c2e-bda8.ngrok.io','/api/update-todolist/');
    var url = Uri.http('192.168.1.35:8000','/api/update-todolist/$_v1');  // localhost ต้องเป็น http ไม่มี s ----ดู ipv4 ใน ipconfig

    Map<String, String> header = {"Content-type": "application/json"}; // ไว้ใส่ API Token ใช้แทน password
    String jsondata =
        '{"title":"${todo_title.text}", "detail":"${todo_detail.text}"}'; // data ที่เราจะส่งไปให้ server
    var response = await http.put(url,
        headers: header,
        body: jsondata); // http นี้มาจาก package ที่เรา import มาจากข้างบน
    print('-------------result-----------');
    print(response.body);

    // ***** อย่าลืมต้องไปเพิ่มข้อความใน AndroidManifest.xml 2 บรรทัด
  }

  Future deleteTodo() async {
    var url = Uri.http('192.168.1.35:8000','/api/delete-todolist/$_v1');
    Map<String, String> header = {"Content-type": "application/json"};
    var response = await http.delete(url, headers: header,); 
    print('-------------result-----------');
    print(response.body);
  }



}
