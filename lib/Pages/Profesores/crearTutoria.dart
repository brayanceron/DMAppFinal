
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class crearTutoria extends StatefulWidget {
  const crearTutoria({super.key});

  @override
  State<crearTutoria> createState() => _crearTutoriaState();
}

class _crearTutoriaState extends State<crearTutoria> {
  Map argumentosRecividos = new Map();
  String id_usuario="";


  TextEditingController nombre = new TextEditingController();
  TextEditingController descripcion = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    argumentosRecividos = (ModalRoute.of(context)?.settings.arguments) as Map; 
    this.id_usuario = argumentosRecividos["id_usuario"].toString();
    print("usuario: "+this.id_usuario);
    return Scaffold(
      appBar: AppBar(title: Text("Crear Tutoria"),),
      body: ListView(
        children:   [
          Text("Nueva tutoria",style: TextStyle(fontSize: 40, color: Colors.black,fontWeight: FontWeight.bold)),
          SizedBox(height: 30,),
          Padding(padding: EdgeInsets.only(left: 15),child: Text("Nombre de la tutoria"),),
          Padding(
            padding: EdgeInsets.all(15),
            child: TextField(
              decoration: InputDecoration(border: OutlineInputBorder(),),
              controller: nombre,
              ),
          ),
          Padding(padding: EdgeInsets.only(left: 15),child: Text("Descripción de la tutoria"),),
          Padding(
            padding: EdgeInsets.all(15),
            child: TextField(
              decoration: InputDecoration( border: OutlineInputBorder()),
              minLines: 5,
              maxLines: 5,
              controller: descripcion,
              ),
          ),
          
          Padding(
            padding: EdgeInsets.all(15),
            child: MaterialButton(
              child: Text("Publicar Tutoria"),
              color: Colors.blueAccent,
              onPressed: registrarTutoria,
            )          
          )
        ],
      ),
    );
  }

registrarTutoria(){

  var url = Uri.parse("http://192.168.1.57:8000/registrarTutoria/");
  print("n="+nombre.text+" d="+descripcion.text);
  
  http.post(url, body: jsonEncode({"nombre":nombre.text,"id_profesor":id_usuario,"descripcion":descripcion.text}))
  .then((value){
    print(value);
  });
  
}


}
