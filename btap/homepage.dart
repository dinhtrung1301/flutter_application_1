import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class homepage extends StatelessWidget {
  const homepage({super.key});

  @override
  Widget build(BuildContext contexxt) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back_ios_new_outlined),
        title: const Text('MY APP'),
        backgroundColor: Colors.blue,
        actions: const [
          Icon(Icons.notifications),
          Icon(Icons.settings),
        ],
      ),
      body: const Center(
        child: Text(
          'body',
          style: TextStyle(
            fontSize: 24
          ),      
        ),
      ),
    );
  }
}