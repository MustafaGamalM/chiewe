import 'package:flutter/material.dart';
import 'package:test_video_player/chiewe.dart';
import 'package:test_video_player/video_info.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChieweInfo(),
    );
  }
}
