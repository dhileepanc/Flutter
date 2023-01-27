import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: Text("Simple Calculator"),
        backgroundColor: Colors.blueGrey,
      ),
      body: MyCalculator(),
    ));
  }
}

class MyCalculator extends StatefulWidget {
  _ComputeSum createState() => _ComputeSum();
}

class _ComputeSum extends State {
  TextEditingController tfnum1 = TextEditingController();
  TextEditingController tfnum2 = TextEditingController();
  String output = "";
  var n1 = 0;
  var n2 = 0;
  var sum = 0;
  void AddTwoNum() {
    n1 = int.parse(tfnum1.text);
    n2 = int.parse(tfnum2.text);
    sum = n1 + n2;
    setState(() {
      output = sum.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextField(
            controller: tfnum1,
            decoration: InputDecoration(
                labelText: "Enter Value for Num 1",
                hintText: "please enter value 1"),
          ),
          TextField(
              controller: tfnum2,
              decoration: InputDecoration(
                  labelText: "Enter Value for Num 2",
                  hintText: "please enter value 2")),
          ElevatedButton(
            onPressed: () {
              AddTwoNum();
            },
            child: Text("Compute"),
          ),
          Text(output)
        ],
      ),
    );
  }
}
