
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
 
void main() {
  runApp(MaterialApp(
    home: NewsApp(),
  ));
}
 
class NewsApp extends StatefulWidget {
  @override
  _NewsAppState createState() => _NewsAppState();
}
 
class _NewsAppState extends State<NewsApp> {
  late List data;
 
  @override
  void initState() {
    super.initState();
    data = [];
    fetchData();
  }
 
  fetchData() async {
    http.Response response;
response = await http.get(Uri.parse('https://newsapi.org/v2/everything?q=tesla&from=2024-02-14&sortBy=publishedAt&apiKey=26fc8d0f1f1248e28cfb5e4b09d0200d'));
 
    setState(() {
      data = jsonDecode(response.body)['articles'];
    });
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
      ),
      body: data != null
          ? ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Container(
            height: 400,
            width: 300,
            child: ListTile(
leading: Image.network(data[index]['urlToImage']),
              title: Text(data[index]['title']),
              subtitle: Text(data[index]['description']),
            ),
          );
        },
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
