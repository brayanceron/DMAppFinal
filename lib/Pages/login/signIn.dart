import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../../utilidades/utilidades.dart';


class signIn extends StatefulWidget {
  const signIn({super.key});

  @override
  State<signIn> createState() => _signInState();
}

class _signInState extends State<signIn> {
  TextEditingController _username = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _lastname = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  final _keyForm =GlobalKey<FormState>();
  bool passwordVisible = true;
  bool _isactivated =false;
  String _selectedOption="estudiante";
  String _role="E";


  String URL=SERVER_URL;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:SingleChildScrollView(
            child: Center(
              child:_cuerpo()
            ),
          ),
         ),
      

    );
  }

  Widget _cuerpo(){
  return Center(
    child: Container(
      color: Colors.white,
      child: Column(
        children: [
          /*Container(
            margin: EdgeInsets.all(30),
            width: 400,
            height: 200,
            child: Image.asset("assets/login.png",fit: BoxFit.cover,),
          ),*/
          Container(
            margin: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children:[
              Text("Registrarse",style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
         
              ]
            ),
          ),

          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
               border: Border.all(
              color: Colors.grey
            ),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Form(
              key: _keyForm,
              child: Column(
                children: [
                      //campoUsername(),
                      campoNombre(),
                      campoApellidos(),
                      campoEmail(),
                      campoContrasena(),
                      campoRole(),
                      botonentrar()
                ],
              ),
            ),
          ),
          
          
          
        ],
      ),
    ),
  );
}

Widget campoUsername() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
      child: TextFormField(
        validator: (valor){
          if(valor!.isEmpty){
            return 'Escribir un nombre de usuario';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Nombre de Usuario",
          fillColor: Colors.white60,
          filled: true,
          suffixIcon: Icon(Icons.account_circle_rounded)
        ),
        controller: _username,
      ),
    );
  }

Widget campoNombre() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
      child: TextFormField(
        validator: (valor){
          if(valor!.isEmpty){
            return 'Escribir un nombre';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Nombre",
          fillColor: Colors.white60,
          filled: true,
          suffixIcon: Icon(Icons.account_circle_rounded)
        ),
        controller: _name,
      ),
    );
  }
Widget campoApellidos() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
      child: TextFormField(
        validator: (valor){
          if(valor!.isEmpty){
            return 'Escribir Apellidos';
          }
          return null;
        },
        decoration: InputDecoration(
         labelText: "Apellidos",
          fillColor: Colors.white60,
          filled: true,
          suffixIcon: Icon(Icons.account_circle_rounded)
        ),
        controller: _lastname,
      ),
    );
  }
Widget campoEmail() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
      child: TextFormField(
        validator: (valor){
          if(valor!.isEmpty){
            return 'Escribir correo válido';
          }
          if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(valor)){}
          else{return "Email no tiene formato válido";}
          return null;
        },
        decoration: InputDecoration(
          labelText: "Correo",
          fillColor: Colors.white60,
          filled: true,
          suffixIcon: Icon(Icons.email)
        ),
        controller: _email,
      ),
    );
  }
Widget campoContrasena() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
      child: TextFormField(
        validator: (valor){
          if(valor!.isEmpty){
            return 'Escribir contraseña';
          }
          return null;
        },
        obscureText: passwordVisible,
        decoration: InputDecoration(
          labelText: "Contraseña",
          fillColor: Colors.white60,
          filled: true,
          suffixIcon: IconButton(
            icon: Icon(

              passwordVisible
              ? Icons.visibility
              : Icons.visibility_off,
            ),
          onPressed: () {
            
            setState(() {
              passwordVisible= !passwordVisible;
            });
          },
          ),
        ),
        controller: _password,
      ),
    );
  }
Widget campoRole() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Radio(
            value: 'estudiante',
            groupValue: _selectedOption,
            onChanged: (value) {
              setState(() {
                _selectedOption = value.toString();
                _role="E";
              });
            },
          ),
          Text('Estudiante'),
          Radio(
            value: 'profesor',
            groupValue: _selectedOption,
            onChanged: (value) {
              setState(() {
                _selectedOption = value.toString();
                _role="P";
              });
            },
          ),
          Text('Profesor'),
        ],
      ),
    );
  }


Widget botonentrar() {
    return ElevatedButton(
      style:
          ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.blue)),
      onPressed: () async { 
        print("OKOKOK");
        
        if(_keyForm.currentState!.validate()){
          Map<String,dynamic> datos={
            'correo': _email.text,
            'rol':_role,
            'nombre':_name.text+" "+_lastname.text

          };
          print(datos.toString());
          print("Contrasena: "+_password.text);

          //registrando en firebase
          try{
                await FirebaseAuth.instance.createUserWithEmailAndPassword(email:_email.text.trim(), password: _password.text.trim());
                //AQUI, antes de hacer la redireccion hay que registrar el nuevo usuario en la base de datos del proyecto
                //Registrando en mongo
                try{
                  var url =Uri.parse(URL+'/registrarUsuario/');
                var response =await http.post(url, body: jsonEncode(datos));
                print(response.body);
                }
                catch(e){
                  exepcionMessageDialogo(context, "2. Error al regustrar el usuario");
                }
                Navigator.pushNamed(context, "/");
            }
            catch(e){
                print("el Error: "+e.toString());
                exepcionMessageDialogo(context, "1. Error al regustrar el usuario");
                
          }
          
          
          

          
        }else{
          print("Fallos en la validación");
        }
      
      
      },
      child: Text(
        "Registrar",
        style: TextStyle(fontSize: 25, color: Colors.white),
      ),
    );
  }






}