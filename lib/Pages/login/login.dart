import 'package:appfinal/utilidades/utilidades.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class login extends StatefulWidget {
  const login({super.key});

  
  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController emailC = new TextEditingController();
  TextEditingController passC = new TextEditingController();
  String _selectedOptionG="estudiante";
  String _roleG="E";
  String URL=SERVER_URL;

 

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      //appBar: AppBar(title: Text('login'),),
      body: ListView(
        children: [
          
          SizedBox(height: 150,),
          Padding(            
            padding: const EdgeInsets.only(left: 45,right: 45),
            child: Center(child: Text("Iniciar sesión", style: TextStyle(fontSize: 40),)),
          ),
          SizedBox(height: 50,),
          //Text("email"),
          Padding(
            padding: const EdgeInsets.only(left: 45, right: 45.0,bottom: 20),
            child: TextField(controller: emailC, decoration: InputDecoration(labelText: "Correo",suffixIcon: Icon(Icons.account_circle_rounded)),),
          ),
          //Text("pass"),
          Padding(
            padding: const EdgeInsets.only(left:45.0,right: 45.0,top: 20,bottom: 80),
            child: TextField(controller: passC,obscureText: true,decoration: InputDecoration(labelText: "Contraseña",suffixIcon: Icon(Icons.visibility_off))),
          ),
          Padding(
           padding: const EdgeInsets.only(left: 45,right: 45),
            child: MaterialButton(
              child: Text("Login"),
              color: Colors.blueAccent,
              onPressed: (){loginbtn();}
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 45,right: 45),
            child: MaterialButton(
              child: Text("Google"),
              color: Colors.blueAccent,
              onPressed: (){
                //sesionConGoogle();
                rolUsuarioDaialog(context);
                }
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 45,right: 45),
            child: MaterialButton(
              child: Text("Registrarse"),
              color: Colors.blueAccent,
              onPressed: (){              
                try{
                  print("Registro..");
                  Navigator.pushNamed(context, "/signin");
                }
                catch(e){
                  print("Exception: "+e.toString());
                }
                
                }
            ),
          ),
          
        ],
      ),
    );
  }

  Future<void> sesionConGoogle() async {
  //print("######################################################################");
  final googleSignIn = GoogleSignIn();
  final googleAccount= await googleSignIn.signIn();
  if(googleAccount != null){
    final googleAuth = await googleAccount.authentication;
    if(googleAuth.accessToken != null && googleAuth.idToken != null){
      try{
        await FirebaseAuth.instance.signInWithCredential(
          GoogleAuthProvider.credential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken )
        );       
        print("*******Cueenta: "+googleAccount.email);
        print("*******Nombre: "+googleAccount.displayName.toString());
        print("*******Url: "+googleAccount.photoUrl .toString());
        print("*******Rol: "+_roleG.toString());
        try{
            var url =Uri.parse(URL+'/loginGoogle/');
            var response =await http.post(url, body: jsonEncode(
            {"correo": googleAccount.email,
            "nombre":googleAccount.displayName.toString(),
            "rol":_roleG.toString(),
            "url_google":googleAccount.photoUrl .toString()
            }
            ));
          //print(response.body);
        }
          catch(e){
            exepcionMessageDialogo(context, "2. Error al regustrar el usuario");
        }
        //AQUI, antes de hacer la redireccion hay que registrar el nuevo usuario en la base de datos del proyecto
      }
      catch(e){
        print(e);
      }
    }

    //authInstance.signInWithCredential();
     
  }
}
//--------------------------------------------------------------
  void loginbtn() async{
    //FirebaseAuth.CreateUserWithEmailAndPassword(email:'miemail', password:"my pass");
    try{
      print(emailC.text+" "+emailC.text.trim()+" - "+passC.text+" "+passC.text.trim());
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailC.text.trim(), password: passC.text.trim());
      //await FirebaseAuth.instance.signInWithEmailAndPassword(email: "brayan0np@gmail.com", password: "madrid-44");
      Navigator.pushNamed(context, "/",);
      
    }
    catch(e){
      print("Error: "+e.toString());
      exepcionMessageDialogo(context, "Error al iniciar sesión");
    }
    
  }
//_----------------------------------------------------------
  void signUp() async{
	    
      try{
          await FirebaseAuth.instance.createUserWithEmailAndPassword(email:emailC.text.trim(), password: passC.text.trim());
          //AQUI, antes de hacer la redireccion hay que registrar el nuevo usuario en la base de datos del proyecto

          Navigator.pushNamed(context, "/");
      }
      catch(e){
          print("el Error: "+e.toString());
          exepcionMessageDialogo(context, e.toString());
          
    }
  }



void rolUsuarioDaialog(BuildContext context){
  showDialog(context: context, 
  builder: ((context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return SimpleDialog(
            title: Text("Seleccione"),
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text("Antes de continuar selecciona el rol con el que deseas continuar"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                    value: 'estudiante',
                    groupValue: _selectedOptionG,
                    onChanged: (value) {
                      setState(() {
                        _selectedOptionG = value.toString();
                        _roleG="E";
                      });
                    },
                  ),
                  Text('Estudiante'),
                  Radio(
                    value: 'profesor',
                    groupValue: _selectedOptionG,
                    onChanged: (value) {
                      setState(() {
                        _selectedOptionG = value.toString();
                        _roleG="P";
                      });
                    },
                  ),
                  Text('Profesor'),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: MaterialButton(
                  child: Text("Continuar",),
                  color: Colors.blue,
                  
                  onPressed: (){sesionConGoogle();Navigator.pop(context);},
                  ),
              )
            ],
        );
    
      },
     
    );
  }));
}


}