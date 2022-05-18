import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  void getCurrentUSer(){
    try {
      final user = _authentication.currentUser;

      if (user != null) {
        loggedUser = user;
        print(loggedUser!.email); //이메일 출력을 위해 서는 loggedUser가 null이면 안되기때문에 !을 붙여준다.
      }
    }catch(e){
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
            onPressed: (){
              _authentication.signOut();
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Center(
        child: Text('Login Success!'),
      ),
    );
  }
}
