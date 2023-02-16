import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Rutas extends StatefulWidget {
  const Rutas({super.key});

  @override
  State<Rutas> createState() => _RutasState();
}

class _RutasState extends State<Rutas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Rutas")),
        body: Column(
          children: [
            MaterialButton(
                child: const Text("Home"),
                color: Colors.blueAccent,
                onPressed: () {
                  Navigator.pushNamed(context, "/home",
                      arguments: {'nombre': 'Bra Vegueta', 'age': 25});
                }),

            MaterialButton(
                child: const Text("listaTutorias"),
                color: Colors.blueAccent,
                onPressed: () {
                  Navigator.pushNamed(context, "/listaTutorias",
                      arguments: {'id_usuario':'63e9b904811ef54a3de59509','rol_usuario':"ESTUDIANTE"});
                }),

            MaterialButton(
                child: const Text("detalleTutoria"),
                color: Colors.blueAccent,
                onPressed: () {
                  Navigator.pushNamed(context, "/detalleTutoria",
                      arguments: {'id_tutoria': '63e9c124811ef54a3de5953e','id_usuario':'63ea888d072e21c4c25f7e88','rol_usuario':"ESTUDIANTE"});
                }),

            MaterialButton(
                child: const Text("panelTutoria"),
                color: Colors.blueAccent,
                onPressed: () {
                  Navigator.pushNamed(context, "/panelTutoria",
                      arguments: {'id_tutoria': '63e9bc8d811ef54a3de5952c','id_usuario':'63ea888d072e21c4c25f7e88','rol_usuario':"ESTUDIANTE"});
                }),

            MaterialButton(
              child: const Text("Peticion GET"),
              color: Colors.blueAccent,
              onPressed: peticionGet,
            ),

            MaterialButton(
              child: const Text("Peticion POST"),
              color: Colors.blueAccent,
              onPressed: peticionPost,
            ),

            MaterialButton(
              child: const Text("Crear Tutoria"),
              color: Colors.pink,
              onPressed: () {
                  Navigator.pushNamed(context, "/crearTutoria",
                      arguments: {'id_usuario':'63e9b9e1811ef54a3de5951e'});
                },
            ),

            MaterialButton(
              child: const Text("Ver entrada"),
              color: Colors.blueAccent,
              onPressed: () {
                  Navigator.pushNamed(context, "/getEntrada",
                      arguments: {'id_tutoria':'63e9bc8d811ef54a3de5952c','id_entrada':'63ea94f6072e21c4c25f7eb1',
                      'id_usuario':'63ea888d072e21c4c25f7e88','rol_usuario':'ESTUDIANTE'} );
                },
            ),


            MaterialButton(
              child: const Text("Crear Entrada"),
              color: Colors.pink,
              onPressed: () {
                  Navigator.pushNamed(context, "/crearEntrada",
                      arguments: {'id_usuario_profesor':'63e9b98e811ef54a3de59514','id_tutoria':'63e9bc8d811ef54a3de5952c'});
                },
            ),

            MaterialButton(
              child: const Text("Ediar Entrada"),
              color: Colors.pink,
              onPressed: () {
                  Navigator.pushNamed(context, "/editarEntrada",
                      arguments: {'id_entrada':'63ed43889d15bdc38e6edb8a','id_tutoria':'63e9bc8d811ef54a3de5952c','id_usuario_profesor':'63e9b98e811ef54a3de59514'});
                },
            ),


          ],
        ));
  }

  void peticionGet() {
    var url = Uri.parse("http://192.168.1.57:8000/rutaUno/");

    http.get(url).then((res) {
      var datarecived = jsonDecode(res.body);
      print("Peticion recivida: " + datarecived["atributo2"].toString());
    });
  }

  void peticionPost() {
    var url = Uri.parse("http://192.168.1.57:8000/rutaUno/");
    var datasend =  jsonEncode({"datos_peticion": "Brayan OK", "atributo2": "valor2"});
    http.post(url, body: datasend).then((res) {
      print("Peticion recivida: " + res.body);
    });
  }
}
