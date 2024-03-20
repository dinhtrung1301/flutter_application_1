
import 'dart:convert';
import 'package:async_flutter/article_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: FutureBuilder(
        future: getArticles(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              final data = snapshot.data ?? [];
              return Center(
                child: Text('Article : ${data.length}'),
              );
          }
        },
      ),
    );
  }

Future<List<Article>> getArticles() async {
  const url = 'https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=bd237b888d224fb2b084f0f913a806ac';
  final res = await http.get(Uri.parse(url));
  
  final Map<String, dynamic> decodedRes = json.decode(res.body) as Map<String, dynamic>;

  final List<Article> result = [];
  for (final article in decodedRes['articles']) {
    result.add(
      Article(
        title: article['title'],
        urlToImage: article['urlToImage'],
      ),
    );
  }

  return result;
}
}
