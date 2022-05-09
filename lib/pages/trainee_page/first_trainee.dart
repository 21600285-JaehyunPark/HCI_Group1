import 'package:flutter/material.dart';

class FirstTrainee extends StatelessWidget {
  const FirstTrainee({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Squat', style: TextStyle(color: Colors.black),),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
        child: Column(

        ),
      ),
    );
  }
}
