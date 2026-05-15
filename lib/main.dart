import 'package:flutter/material.dart';
import 'package:Notes/data/local/db_helper.dart';

import 'home_page.dart';

void main(){
  runApp(const FlutterApp());
}

class FlutterApp extends StatelessWidget{
  const FlutterApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'FlutterApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

