import 'package:flutter/material.dart';
import 'package:memomemo/database/memo.dart';
import 'package:memomemo/database/db.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method

class  EditPage extends StatelessWidget {
  String title = '';
  String text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: (){},
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: saveDB,

          )
        ],
      ),
      body:
      Padding( padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              TextField(
                onChanged: (String title){this.title = title;},
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                //obscureText: true, //비밀번호만
                decoration: InputDecoration(
                  //border: OutlineInputBorder(),
                  hintText: '메모의 제목을 적어주세요.',
                ),
              ),
          Padding( padding: EdgeInsets.all(20)),
              TextField(
                onChanged: (String text){this.text = text;},
                //obscureText: true, //비밀번호만
                decoration: InputDecoration(
                  //border: OutlineInputBorder(),
                  hintText: '메모의 내용을 적어주세요.',
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ],
          )
      )
    );
  }

  Future<void> saveDB() async {
    DBHelper sd = DBHelper();
        var fido = Memo(
          id: Str2sha512(DateTime.now().toString()),
          title: this.title,
          text: this.text,
          createTime: DateTime.now().toString(),
          editTime: DateTime.now().toString(),

        );
      await sd.insertMemo(fido);

      print(await sd.memos());
  }
  String Str2sha512(String text) {
    var bytes = utf8.encode(text); // data being hashed
    var digest = sha512.convert(bytes);
    return digest.toString();
  }
}
