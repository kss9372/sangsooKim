import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser; //값을 초기화시키지않음 nullable타입

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUSer();
  }

  void getCurrentUSer() {
    try {
      final user = _authentication.currentUser;

      if (user != null) {
        loggedUser = user;
        print(loggedUser!
            .email); //이메일 출력을 위해 서는 loggedUser가 null이면 안되기때문에 !을 붙여준다.
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Chat Screen'),
          actions: [
            IconButton(
              icon: Icon(
                Icons.exit_to_app_sharp,
                color: Colors.white,
              ),
              onPressed: () {
                _authentication.signOut();
                Navigator.pop(context);
              },
            )
          ],
        ),
        body: StreamBuilder(
          //flutter가 제공
          stream: FirebaseFirestore.instance
              .collection('chats/KxmVey7sAdN7dA7U1zVG/message')
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final docs = snapshot.data!.docs;
            return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      docs[index]['text'],
                      style: TextStyle(fontSize: 20.0),
                    ),
                  );
                });
          },
        ));
  }
}
