import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memomemo/database/memo.dart';
import 'package:memomemo/database/db.dart';

class ViewPage extends StatelessWidget {
  ViewPage({Key? key, required this.id}) : super(key: key);

  final String id;
  //findMemo(id)[0]

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {},
            )
          ],
        ),
        body: Padding(padding: EdgeInsets.all(20), child: LoadBuilder()));
  }

  Future<List<Memo>> loadMemo(String id) async {
    DBHelper sd = DBHelper();
    return await sd.findMemo(id);
  }

  LoadBuilder() {
    return FutureBuilder<List<Memo>>(
      future: loadMemo(id),
      builder: (BuildContext context, AsyncSnapshot<List<Memo>> snapshot) {
        if (snapshot.data == null) {
          return Container(
            alignment: Alignment.center,
            child: Text('데이터를 불러올수 없습니다.',
                style: TextStyle(fontSize: 15, color: Colors.pink),
                textAlign: TextAlign.center),
          );
        } else {
          Memo memo = snapshot.data![0];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                memo.title,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              ),
              Text(
                "메모 작성 시간: " + memo.createTime.split(',')[0],
                style: TextStyle(fontSize: 11),
                textAlign: TextAlign.end,
              ),
              Text(
                "메모 수정 시간: " + memo.editTime.split(',')[0],
                style: TextStyle(fontSize: 11),
                textAlign: TextAlign.end,
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              Expanded(child: Text(memo.text)),
            ],
          );
        }
      },
    );
  }
}
