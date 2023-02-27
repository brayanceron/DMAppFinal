import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      //appBar: AppBar(title: Text('login'),),
      body: Column(
        children: [
          
          SizedBox(height: 150,),
          Text("Log In", style: TextStyle(fontSize: 40),),
          SizedBox(height: 50,),
          Text("email"),
          TextField(controller: emailC,),
          Text("pass"),
          TextField(controller: passC,),
          MaterialButton(
            child: Text("Login"),
            color: Colors.blueAccent,
            onPressed: (){signIn();}
          ),
          MaterialButton(
            child: Text("SignUp"),
            color: Colors.blueAccent,
            onPressed: (){signUp();}
          ),
          MaterialButton(
            child: Text("Google"),
            color: Colors.blueAccent,
            onPressed: (){sesionConGoogle();}
          ),
        ],
      ),
    );
  }

  Future<void> sesionConGoogle() async {
  print("######################################################################");
  final googleSignIn = GoogleSignIn();
  final googleAccount= await googleSignIn.signIn();
  if(googleAccount != null){
    final googleAuth = await googleAccount.authentication;
    if(googleAuth.accessToken != null && googleAuth.idToken != null){
      try{
        await FirebaseAuth.instance.signInWithCredential(
          GoogleAuthProvider.credential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken )
        );       
        print("Cueenta: "+googleAccount.email);
        //AQUI, antes de hacer la redireccion hay que registrar el nuevo usuario en la base de datos del proyecto
      }
      catch(e){
        print(e);
      }
    }

    //authInstance.signInWithCredential();
     
  }
}

  void signIn() async{
    //FirebaseAuth.CreateUserWithEmailAndPassword(email:'miemail', password:"my pass");
    try{
      print(emailC.text+" "+emailC.text.trim()+" - "+passC.text+" "+passC.text.trim());
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailC.text.trim(), password: passC.text.trim());
      //await FirebaseAuth.instance.signInWithEmailAndPassword(email: "brayan0np@gmail.com", password: "madrid-44");
      Navigator.pushNamed(context, "/",);
    }
    catch(e){
      print("Error: "+e.toString());
    }
    
  }

  void signUp() async{
	    
      try{
          await FirebaseAuth.instance.createUserWithEmailAndPassword(email:emailC.text.trim(), password: passC.text.trim());
          //AQUI, antes de hacer la redireccion hay que registrar el nuevo usuario en la base de datos del proyecto

          Navigator.pushNamed(context, "/");
      }
      catch(e){
          print("Error: "+e.toString());
    }
  }


}