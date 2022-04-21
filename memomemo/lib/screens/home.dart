import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'edit.dart';
import 'package:memomemo/database/memo.dart';
import 'package:memomemo/database/db.dart';
import 'package:memomemo/screens/view.dart';
import 'package:flutter/src/material/text_button.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String deleteId = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20, top: 40, bottom: 20),
            child: Container(
              child: Text(
                '메모메모',
                style: TextStyle(fontSize: 36, color: Colors.blue),
              ),
              alignment: Alignment.centerLeft,
            ),
          ),
          Expanded(child: memoBuilder(context))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, //화면이동시 항상 함께
              CupertinoPageRoute(builder: (context) => EditPage()));
        },
        tooltip: '메모룰 추가하려면 클릭하세요',
        label: Text('메모 추가'),
        icon: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  Future<List<Memo>> loadMemo() async {
    DBHelper sd = DBHelper();
    return await sd.memos();
  }

  Future<void> deleteMemo(String id) async {
    DBHelper sd = DBHelper();
    await sd.deleteMemo(id);
  }
  void _showMyDialog(parentcontext) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('삭제 알림'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('해당 메모를 삭제합니다.'),
                Text('다시 복구할수 없습니다. 괜찮습니까?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('삭제'),
              onPressed: () {
                Navigator.of(context).pop();
                setState((){
                  deleteMemo(deleteId);
                  print("삭제");
                });
                deleteId = '';
              },
            ),
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                deleteId = '';
                Navigator.of(context).pop();
              },
            ),
          ],

        );
      },
    );
  }
  
  Widget memoBuilder(BuildContext parentcontext) {
    return FutureBuilder(
      builder: (context, Snap) {
        if (Snap.data == null) {
          return Container(
            alignment: Alignment.center,
            child: Text(
                '지금 바로 "메모 추가" 버튼을 눌러\n 새로운 메모를 추가해 보세요!\n\n\n\n\n\n\n\n',
                style: TextStyle(fontSize: 15, color: Colors.pink),
                textAlign: TextAlign.center),
          );
        }
        return ListView.builder(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(20),
          itemCount: (Snap.data as List).length,
          itemBuilder: (context, index) {
            Memo memo = (Snap.data as List)[index];
            return InkWell(
                onTap: () {
                  Navigator.push(
                      parentcontext, CupertinoPageRoute(builder: (context) => ViewPage(id: memo.id)));
                },
                onLongPress: () {
                  deleteId = memo.id;
                  _showMyDialog(parentcontext);
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(15),
                  alignment: Alignment.center,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(230, 230, 230, 1),
                    border: Border.all(
                      color: Colors.blue,
                      width: 3,
                    ),
                    boxShadow: const [
                      BoxShadow(color: Colors.lightBlue, blurRadius: 3)
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            memo.title,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          Text(memo.text, style: TextStyle(fontSize: 15)),
                        ],
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              "최종 수정 시간:" + memo.createTime.split('.')[0],
                              style: TextStyle(fontSize: 11),
                              textAlign: TextAlign.end,
                            ),
                          ])
                      // Widget to display the list of project
                    ],
                  ),
                ));
          },
        );
      },
      future: loadMemo(),
    );
  }
}
