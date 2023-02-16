import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Map argumentosRecividos= new Map();

  @override
  Widget build(BuildContext context) {
    argumentosRecividos = (ModalRoute.of(context)?.settings.arguments) as Map;
    print(argumentosRecividos);

    return Scaffold(
      appBar: AppBar(title: Text("Page Home"),),
      
    );
  }
}