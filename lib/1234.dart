import 'package:flutter/material.dart';
void main() {
  runApp(const myapp());
}
class myapp extends StatefulWidget {
  const myapp({super.key});

  @override
  State<myapp> createState() => _myappState();
}

class _myappState extends State<myapp> {
  @override
  Widget build(BuildContext context) {
    String? title;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.person),
          title:  Text(title ?? '1301'),
        ),
        body: Container(),
      )
    );
  }
}
// const: hằng ko thể thay đổi, chỉ duy nhất
//title ?? 'ali 22': nếu title = nolll thfi hiện cái trong ''

