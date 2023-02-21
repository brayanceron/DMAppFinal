
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:firebase_auth/firebase_auth.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController emailC = new TextEditingController();
  TextEditingController passC = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('login'),),
      body: Column(
        children: [
          Text("email"),
          TextField(controller: emailC,),
          Text("pass"),
          TextField(controller: passC,),
          MaterialButton(
            child: Text("Login"),
            color: Colors.blueAccent,
            onPressed: (){signIn();}
            )
        ],
      ),
    );
  }

  void signIn() async{
    //FirebaseAuth.CreateUserWithEmailAndPassword(email:'miemail', password:"my pass");
    try{
      print(emailC.text+" "+emailC.text.trim()+" - "+passC.text+" "+passC.text.trim());
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailC.text.trim(), password: passC.text.trim());
      //await FirebaseAuth.instance.signInWithEmailAndPassword(email: "brayan0np@gmail.com", password: "madrid-44");
    }
    catch(e){
      print("Error: "+e.toString());
    }
    
  }


}