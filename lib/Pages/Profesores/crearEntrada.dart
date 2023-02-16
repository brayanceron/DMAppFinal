import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class crearEntrada extends StatefulWidget {
  const crearEntrada({super.key});

  @override
  State<crearEntrada> createState() => _crearEntradaState();
}

class _crearEntradaState extends State<crearEntrada> {
  Map argumentosRecividos = new Map();
  String id_usuario_profesor="";
  String id_tutoria="";
  String URL="http://10.0.2.2:8000";

  TextEditingController tituloControlador = new TextEditingController();
  TextEditingController descripcionControlador = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    argumentosRecividos = (ModalRoute.of(context)?.settings.arguments) as Map; 
    this.id_usuario_profesor = argumentosRecividos["id_usuario_profesor"].toString();
    this.id_tutoria = argumentosRecividos["id_tutoria"].toString();
    print("usuario: "+this.id_usuario_profesor);


    return  Scaffold(
      appBar: AppBar(title: Text("Crear Entrada")),
      body: ListView(
        children: [
          Text("Nueva Entrada",style: TextStyle(fontSize: 40, color: Colors.black,fontWeight: FontWeight.bold)),
          SizedBox(height: 30,),
          Padding(padding: EdgeInsets.only(left: 15),child: Text("Titulo"),),
          Padding(
            padding: EdgeInsets.all(15),
            child: TextField(
              decoration: InputDecoration(border: OutlineInputBorder(),),
              controller: tituloControlador,
              ),              
          ),
          Padding(padding: EdgeInsets.only(left: 15),child: Text("Descripción de la entrada"),),
          Padding(
            padding: EdgeInsets.all(15),
            child: TextField(
              decoration: InputDecoration( border: OutlineInputBorder()),
              minLines: 5,
              maxLines: 5,
              controller: descripcionControlador,
              ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: MaterialButton(
              child: Text("Publicar Entrada"),
              color: Colors.blueAccent,
              onPressed: registrarEntrada,
            )          
          )

        ],
      )
    );
  }


registrarEntrada(){
  var url = Uri.parse(URL+"/registrarEntrada/");
  //print("titulo="+tituloControlador.text+" desc="+descripcionControlador.text+" prof:"+id_usuario_profesor+" tutoria:"+id_tutoria);
  
  http.post(url, body: jsonEncode({"titulo":tituloControlador.text,'id_tutoria':id_tutoria,
  "id_profesor":id_usuario_profesor,"descripcion":descripcionControlador.text}))
  .then((value){
    print(value);
  });
  
}




}