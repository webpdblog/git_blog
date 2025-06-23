import 'package:flutter/material.dart';

void main() {
  runApp(const MyBlogApp());
}

class MyBlogApp extends StatelessWidget {
  const MyBlogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '블로그',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BlogHomePage(),
    );
  }
}

class BlogHomePage extends StatelessWidget {
  const BlogHomePage({super.key});

  // 예시 게시글 데이터
  final List<Map<String, String>> posts = const [
    {
      'title': '첫 번째 글',
      'summary': '이것은 첫 번째 블로그 글의 요약입니다.',
      'date': '2025-06-23',
    },
    {'title': '두 번째 글', 'summary': '두 번째 글의 간단한 설명입니다.', 'date': '2025-06-20'},
    {'title': '세 번째 글', 'summary': '세 번째 글의 요약입니다.', 'date': '2025-06-15'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('블로그')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(post['title']!),
              subtitle: Text(post['summary']!),
              trailing: Text(post['date']!),
              onTap: () {
                // 상세 페이지로 이동하는 코드 추가 가능
              },
            ),
          );
        },
      ),
    );
  }
}
