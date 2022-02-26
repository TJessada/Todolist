import 'package:flutter/material.dart';
// http method package 3 รายการ
import 'package:http/http.dart' as http; //as http คือตั้งชื่อเล่น อันนี้ไปติดตั้งที่ pubspec.yaml depedencies แล้ว
import 'dart:async';
import 'dart:convert';

class AddPage extends StatefulWidget {
  const AddPage({ Key? key }) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController todo_title = TextEditingController();
  TextEditingController todo_detail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('เพิ่มรายการใหม่'),),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TextField(
                    controller : todo_title,
                    decoration: InputDecoration(
                      labelText: 'รายการที่ต้องทำ', 
                      border: OutlineInputBorder())),
            SizedBox(height: 30,),
            TextField(
                    minLines: 4,
                    maxLines: 8,
                    controller : todo_detail,
                    decoration: InputDecoration(
                      labelText: 'รายละเอียด', 
                      border: OutlineInputBorder())),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                      onPressed: () {
                         print('------------');
                         print('title: ${todo_title.text}');
                         print('detail: ${todo_detail.text}');
                         postTodo();
                         setState(() {
                           todo_title.clear();
                           todo_detail.clear();
                         });
                      }, 
                      child: Text("เพิ่มรายการ"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(50, 20, 50, 20)),
                        textStyle: MaterialStateProperty.all(TextStyle(fontSize: 20))
                      ),
              ),
            ),

          ],
        ),
      ),
      
    );
  }

  Future postTodo() async {
    //async คือฟังก์ชั่นที่ใช้สำหรับลักษณะการทำงานที่ต้องรอระยะเวลา เนื่องจากแอปจะทำงานเป็น loop refresh หน้าตลอดเวลา
    // มีการ request หรือ post ขึ้นไปมันจะมีช่วงระบะเวลาที่มันต้องรอเวลาจากการ response ของทาง server
    
    //var url = Uri.https('9168-2403-6200-8890-c3dd-b9f2-4349-7c2e-bda8.ngrok.io','/api/post-todolist/');
    var url = Uri.http('192.168.1.35:8000','/api/post-todolist/');  // localhost ต้องเป็น http ไม่มี s ----ดู ipv4 ใน ipconfig
    
    Map<String, String> header = {"Content-type":"application/json"};
    String jsondata = '{"title":"${todo_title.text}", "detail":"${todo_detail.text}"}'; // data ที่เราจะส่งไปให้ server
    var response = await http.post(url, headers: header, body: jsondata); // http นี้มาจาก package ที่เรา import มาจากข้างบน
    print('-------------result-----------');
    print(response.body);

    // ***** อย่าลืมต้องไปเพิ่มข้อความใน AndroidManifest.xml 2 บรรทัด

  }




}