import 'package:appfinal/Pages/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';

class homedoslogin extends StatefulWidget {
  const homedoslogin({super.key});
  

  @override
  State<homedoslogin> createState() => _homedosloginState();
}




class _homedosloginState extends State<homedoslogin> {
  var user = FirebaseAuth.instance.currentUser;
  String useremail="";
  
  _homedosloginState(){
    
  }

  @override
  void initState() {
    
    super.initState();
  }


   validadSesion() async{
    if(user == null){ 
      print("No has iniciado sesion");
      if(user == null){ Navigator.pushNamed(context, "/login");}
    }
    else{
      this.useremail=""+user!.email.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    validadSesion();

  
    return Scaffold(
      appBar: AppBar(title: Text("homedoslogin")),
      body: Column(
                  children: [
                    Text("El usuario es: "+useremail),
                    MaterialButton(
                    color: Colors.blueAccent,
                    child: Text("Home 1"),
                    onPressed: (){ Navigator.pushNamed(context, "/homeunologin");}
                    )
                    ],
                )
      
    );
    


  }
  
}