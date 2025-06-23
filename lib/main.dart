import 'package:flutter/material.dart';
import 'first_post_page.dart';

void main() {
  runApp(const MyBlogApp());
}

class MyBlogApp extends StatelessWidget {
  const MyBlogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '재미있는 블로그',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BlogHomePage(),
      routes: {
        '/first': (context) => LadderGamePage(), // 수정: FirstPostPage → LadderGamePage
      },
    );
  }
}

// ...existing code...
class BlogHomePage extends StatelessWidget {
  const BlogHomePage({super.key});

  final List<Map<String, String>> posts = const [
    {
      'title': '식사내기 사다리 게임',
      'summary': '식사내기 사다리 게임입니다. ',
      'date': '2025-06-23',
    },
    // 필요시 다른 글 추가
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('재미있는 블로그')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => Navigator.pushNamed(context, '/first'),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['title']!,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      post['summary']!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        post['date']!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
// ...existing code...