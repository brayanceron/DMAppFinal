import 'package:flutter/material.dart';



class myWebView extends StatefulWidget {
  const myWebView({super.key});

  @override
  State<myWebView> createState() => _myWebViewState();
}

class _myWebViewState extends State<myWebView> {
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("imagen")),
      body: const Center(
        child:  Text("Ok")
      ),
    );
  }
}

