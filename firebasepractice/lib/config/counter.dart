import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  const Counter({Key? key}) : super(key: key);

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  final int price = 2000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stream builder'),
      ),
      body: StreamBuilder<int>(
        initialData: price,
        stream: addStreamValue(),
        builder: (context, snapshot){
          final priceNumber = snapshot.data.toString();
          return Center(
            child: Text(priceNumber,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
              color: Colors.blue),
            ),
          );
        },//snapshot:스트림의 결과물 스트림빌더에게 이 데이터를 사용하라고 지정해줘야한다.
      ),
    );
  }

  Stream<int> addStreamValue(){
    return Stream<int>.periodic(
      Duration(seconds: 1),
        (count) => price + count
    );
  }
}
