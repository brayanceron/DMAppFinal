import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class getEntrada extends StatefulWidget {
  const getEntrada({super.key});

  @override
  State<getEntrada> createState() => _getEntradaState();
}

class _getEntradaState extends State<getEntrada> {
  String id_tutoria = "";
  String id_entrada = "";
  String id_usuario = "";
  String rol_usuario = "";
  List entrada = [];

  Map argumentosRecividos = new Map();



  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: Text("get Entrada")),
      body: FutureBuilder(
            future: cargar_informacion(),
            builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } 
            else if (snapshot.connectionState == ConnectionState.none) {
              return const Text("error");
            } 
            else{
              return ListView(
                children: [
                  Text(entrada[0]["titulo"],style: const TextStyle(fontSize: 40, color: Colors.black,fontWeight: FontWeight.bold)),
                  Text("Creación: "+entrada[0]["fecha_creacion"]),                  
                  Row(
                      children: [
                                const Icon(Icons.account_circle_rounded,size: 30,color: Colors.blueAccent,),
                                Text("Profesor: "+entrada[0]["id_profesor"][0]["nombre"]),  
                      ],
                  ),
                  SizedBox(height: 20,),
                  Text(entrada[0]["descripcion"]),
                  SizedBox(height: 20,),
                  Text("Contenido Adjunto:"),
                ],
              );
            }
            },      
          ),
    );
  }

 Future cargar_informacion() async {
    argumentosRecividos = (ModalRoute.of(context)?.settings.arguments) as Map;
    this.id_tutoria = argumentosRecividos["id_tutoria"].toString();
    this.id_entrada = argumentosRecividos["id_entrada"].toString();
    this.id_usuario = argumentosRecividos["id_usuario"].toString();
    this.rol_usuario = argumentosRecividos["rol_usuario"].toString();
    
    print("--->" + id_tutoria);

    var url = Uri.parse("http://192.168.1.57:8000/getEntrada/");

    final res = await http.post(url, body: jsonEncode({"id_entrada": this.id_entrada}));
    var datarecived = jsonDecode(res.body);

    print("nueva forma" + datarecived.toString());
    this.entrada = jsonDecode(res.body);
    return datarecived;
  }



}