import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utilidades/utilidades.dart';


class Rutas extends StatefulWidget {
  const Rutas({super.key});

  @override
  State<Rutas> createState() => _RutasState();
}


class _RutasState extends State<Rutas> {
  User? user = FirebaseAuth.instance.currentUser; 
  var usuarioInfo; 
  //this.usuarioInfo[0]["rol"] para saber el rol
  //this.usuarioInfo[0]["nombre"] para saber el nombre
  //this.usuarioInfo[0]["_id"]["\$oid"] para saber el id

  String URL=SERVER_URL;
  //String id_tutoria = "";
  String id_usuario = "";
  String rol_usuario = "";


  

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        //appBar: AppBar(title: const Text("Rutas")),
        body: StreamBuilder(
                stream:FirebaseAuth.instance.authStateChanges(),
                builder:(context,snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return Center(child:CircularProgressIndicator());
                  }
                  else if(snapshot.hasError){
                    return Text("Hubo un error");
                  }
                  else if(snapshot.hasData){
                    print("La app ya encontro una sesion");
                    return FutureBuilder(
                      future: cargar_info_usuario(),
                      builder: (context, snapshot) {
                        return columnarutas();
                      },
                      );
                  }
                  else{
                    print("No has iniciado sesion todabia");
                    return login();
                  }
                }
              ));
        
         }

  void peticionGet() {
    var url = Uri.parse(URL+"/rutaUno/");

    http.get(url).then((res) {
      var datarecived = jsonDecode(res.body);
      print("Peticion recivida: " + datarecived["atributo2"].toString());
    });
  }

  void peticionPost() {
    var url = Uri.parse(URL+"/rutaUno/");
    var datasend =  jsonEncode({"datos_peticion": "Brayan OK", "atributo2": "valor2"});
    http.post(url, body: datasend).then((res) {
      print("Peticion recivida: " + res.body);
    });
  }

  Future cargar_info_usuario() async{
    user = await FirebaseAuth.instance.currentUser; 
    var url = Uri.parse(URL+"/getInfoUsuario/");
    final res = await http.post(url, body: jsonEncode({"correo": this.user?.email}));
    this.usuarioInfo = jsonDecode(res.body);

    print("****MOVILE*****");
    print(this.usuarioInfo);
    //print("ROL:"+this.usuarioInfo[0]["rol"]);
    //print("_id: "+this.usuarioInfo[0]["_id"]["\$oid"]);
    this.id_usuario = this.usuarioInfo[0]["_id"]["\$oid"] ;
    this.rol_usuario = this.usuarioInfo[0]["rol"];
    

  }

  Widget columnarutas(){
    return Column(
      children: [
        SizedBox(height: 50,),
        MaterialButton(
                child: const Text("Home"),
                color: Colors.blueAccent,
                onPressed: () {
                  Navigator.pushNamed(context, "/home",
                      arguments: {'opt_actual': 0});
                }),
            MaterialButton(
                child: const Text("Login"),
                color: Colors.greenAccent,
                onPressed: () {
                  Navigator.pushNamed(context, "/webview",
                     );
                }),
            MaterialButton(
                child: const Text("homeunologin"),
                color: Colors.greenAccent,
                onPressed: () {
                  Navigator.pushNamed(context, "/homeunologin",
                      arguments: {'nombre': 'Bra Vegueta', 'age': 25});
                }),
            /*MaterialButton(
                child: const Text("homedoslogin"),
                color: Colors.greenAccent,
                onPressed: () {
                  Navigator.pushNamed(context, "/homedoslogin",
                      arguments: {'nombre': 'Bra Vegueta', 'age': 25});
                }),*/
            MaterialButton(
                child: const Text("catalogoTutorias"),
                color: Colors.blueAccent,
                onPressed: () {
                  Navigator.pushNamed(context, "/catalogoTutorias",
                      /*arguments: {'id_usuario':'63e9b904811ef54a3de59509'}*/);
                }),
            MaterialButton(
                child: const Text("listaTutorias"),
                color: Colors.blueAccent,
                onPressed: () {
                  Navigator.pushNamed(context, "/listaTutorias",
                      /*arguments: {'id_usuario':'63e9b904811ef54a3de59509'}*/);
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
                      arguments: {'id_tutoria': '63e9bc8d811ef54a3de5952c'});
                }),

            /*MaterialButton(
              child: const Text("Peticion GET"),
              color: Colors.blueAccent,
              onPressed: peticionGet,
            ),
            */
            MaterialButton(
              child: const Text("Peticion POST"),
              color: Colors.blueAccent,
              onPressed: peticionPost,
            ),

            MaterialButton(
              child: const Text("Crear Tutoria"),
              color: Colors.pink,
              onPressed: () {
                  //this.rol_usuario = 'E';
                  if(this.usuarioInfo[0]["rol"]!='P'){ return null;}
                  Navigator.pushNamed(context, "/crearTutoria",
                      arguments: {'id_usuario':this.id_usuario});
                },
            ),

            MaterialButton(
              child: const Text("Ver entrada"),
              color: Colors.blueAccent,
              onPressed: () {
                  Navigator.pushNamed(context, "/getEntrada",
                      arguments: {'id_tutoria':'63e9bc8d811ef54a3de5952c','id_entrada':'63ea94f6072e21c4c25f7eb1',
                      /*'id_usuario':'63ea888d072e21c4c25f7e88','rol_usuario':'ESTUDIANTE'*/} );
                },
            ),


            MaterialButton(
              child: const Text("Crear Entrada"),
              color: Colors.pink,
              onPressed: () {
                  Navigator.pushNamed(context, "/crearEntrada",
                      arguments: {'id_tutoria':'63e9bc8d811ef54a3de5952c'});
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

            MaterialButton(
              child: const Text("Solicitudes Profesor"),
              color: Colors.pink,
              onPressed: () {
                  if(this.usuarioInfo[0]["rol"]!='P'){ return null;}
                  Navigator.pushNamed(context, "/solicitudesProfesor",arguments: {
                    'id_tutoria_publicada':'63f8dd02b159d685dd68ec92',
                    'id_solicitante':'63e9b904811ef54a3de59509',//(leonor castillo) //deberia ir this.id_usuario
                    'id_profesor':'OPT'                    
                    });
                },
            ),

            MaterialButton(
              child: const Text("Solicitudes Estudiante"),
              color: Colors.blueAccent,
              onPressed: () {
                  if(this.usuarioInfo[0]["rol"]=='P'){ return null;}//esta condicion si funciona, esta desabilitada solamente para hacer pruebas, activarlo luego
                  Navigator.pushNamed(context, "/solicitudesEstudiante",arguments: {
                    'id_tutoria_publicada':'63f8dd02b159d685dd68ec92',
                    'id_solicitante':'63e9b904811ef54a3de59509',//(leonor castillo) //deberia ir this.id_usuario
                    'id_profesor':'OPT'                    
                    });
                },
            ),
            MaterialButton(
              child: const Text("Chat"),
              color: Colors.blueAccent,
              onPressed: () {
                  Navigator.pushNamed(context, "/chat");
                },
            ),

      ],
    );
  }

}
