import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utilidades/utilidades.dart';


class crearEntrada extends StatefulWidget {
  const crearEntrada({super.key});

  @override
  State<crearEntrada> createState() => _crearEntradaState();
}

class _crearEntradaState extends State<crearEntrada> {
  //String URL="http://10.0.2.2:8000";
  String URL=SERVER_URL;
  
  Map argumentosRecividos = new Map();
  final user = FirebaseAuth.instance.currentUser!; 
  var usuarioInfo;

  String id_usuario_profesor="";
  String rol_usuario="";
  String id_tutoria="";
  

  TextEditingController tituloControlador = new TextEditingController();
  TextEditingController descripcionControlador = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(title: Text("Crear Entrada")),
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
                  );
              }
        },
        )
      
      
    );
  }

Future cargar_informacion() async{
    await cargar_info_usuario();
    argumentosRecividos = (ModalRoute.of(context)?.settings.arguments) as Map; 
    //this.id_usuario_profesor = argumentosRecividos["id_usuario_profesor"].toString();
    this.id_tutoria = argumentosRecividos["id_tutoria"].toString();

    this.rol_usuario = this.usuarioInfo[0]["rol"];
    this.id_usuario_profesor = this.usuarioInfo[0]["_id"]["\$oid"];
    
    print("El usuario: "+this.id_usuario_profesor+"/"+this.usuarioInfo[0]["nombre"] +" agregara una entrada a la tutoria "+this.id_tutoria);
}

Future cargar_info_usuario() async{
    var url = Uri.parse(URL+"/getInfoUsuario/");
    final res = await http.post(url, body: jsonEncode({"correo": this.user.email}));
    this.usuarioInfo = jsonDecode(res.body);
    print("ROL:"+this.usuarioInfo[0]["rol"]);

  }

registrarEntrada(){
  /*if(this.rol_usuario!='E'){*/
      var url = Uri.parse(URL+"/registrarEntrada/");
      //print("titulo="+tituloControlador.text+" desc="+descripcionControlador.text+" prof:"+id_usuario_profesor+" tutoria:"+id_tutoria);
  
      http.post(url, body: jsonEncode({"titulo":tituloControlador.text,'id_tutoria':id_tutoria,
      "id_profesor":id_usuario_profesor,"descripcion":descripcionControlador.text}))
      .then((value){
        print(value);
        Navigator.pushNamed(context, "/panelTutoria",arguments: {'id_tutoria':this.id_tutoria});
      });
  /*}
  else{
    print("Este Rol no puede agregar una entrada");
  }*/
  
  
}




}