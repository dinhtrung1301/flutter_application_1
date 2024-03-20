
import 'package:flutter/material.dart';

void main() {
  runApp(MyNewsApp());
}

class MyNewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NewsScreen(),
    );
  }
}

class NewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Reader App'),
      ),
      body: ListView.builder(
        itemCount: 10, // Giả sử có 10 bài báo
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.article),
            title: Text('Bài báo số $index'),
            subtitle: Text('Nội dung bài báo số $index'),
            onTap: () {
              // Xử lý khi người dùng chọn một bài báo
            },
          );
        },
      ),
    );
  }
}
