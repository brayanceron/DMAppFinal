import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:firebase_auth/firebase_auth.dart';

class homeuno extends StatefulWidget {
  const homeuno({super.key});

  @override
  State<homeuno> createState() => _homeunoState();
}

class _homeunoState extends State<homeuno> {

@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser; 
    String m ="";
    if(user == null){ m="No hay un usuario registrado";}
    else{m=user.email.toString()+" -- "+user.emailVerified.toString(); }

    return Scaffold(
      appBar: AppBar(title: Text("homeunologin")),
      body: ListView(
        children: [
          Text(m),
          MaterialButton(
            color: Colors.blueAccent,
            child: Text("Cerrrar Cesion"),
            onPressed: (){signOut();}),
          MaterialButton(
            color: Colors.blueAccent,
            child: Text("Home 2"),
            onPressed: (){ Navigator.pushNamed(context, "/homedoslogin");})
        ],
      ),
    );

  }
   void signOut() async{
      await FirebaseAuth.instance.signOut();
  }
}