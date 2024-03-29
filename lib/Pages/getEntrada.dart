import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
        
//import 'dart:html' as html;
//import 'package:html/dom.dart';
//import 'package:html' as html;



import '../utilidades/utilidades.dart';

class getEntrada extends StatefulWidget {
  const getEntrada({super.key});

  @override
  State<getEntrada> createState() => _getEntradaState();
}

class _getEntradaState extends State<getEntrada> {
  String URL=SERVER_URL;
  final user = FirebaseAuth.instance.currentUser!; 
  var usuarioInfo;

  Map argumentosRecividos = new Map();

  String id_tutoria = "";
  String id_entrada = "";
  String id_usuario = "";
  String rol_usuario = "";
  List entrada = [];



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
                                   
                  if(this.rol_usuario!="E") IconButton(alignment: Alignment.bottomLeft,
                               icon: Icon(Icons.edit_note,size: 30,color: Colors.redAccent),
                              onPressed: () {
                                Navigator.pushNamed(context, "/editarEntrada",
                                arguments: {'id_tutoria':this.id_tutoria,'id_entrada':this.id_entrada});
                              },
                  ),

                  Text("Contenido Adjunto:"),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: this.entrada[0]["archivos"].length,
                    itemBuilder:(context, index) {
                      return Column(
                        children: [
                          Text("archivo: "+this.entrada[0]["archivos"][index]["nombre"].toString()),
                          Text("url: "+this.entrada[0]["archivos"][index]["url"].toString()),
                          Text("exten: "+this.entrada[0]["archivos"][index]["nombre"].toString()),
                          MaterialButton(
                            color: Colors.blue,
                            child: Text("Descacargar"),
                            onPressed: (){btnDescargar(this.entrada[0]["archivos"][index]["url"]);}),
                          Text("-------------------------------------------")
                        ],
                      );
                      
                    }
                  ),
                ],
              );
            }
            },      
          ),
    );
  }

 Future cargar_informacion() async {
    argumentosRecividos = (ModalRoute.of(context)?.settings.arguments) as Map;
    await cargar_info_usuario();

    this.id_tutoria = argumentosRecividos["id_tutoria"].toString();
    this.id_entrada = argumentosRecividos["id_entrada"].toString();
    this.id_usuario = this.usuarioInfo[0]["_id"]["\$oid"] ;
    this.rol_usuario = this.usuarioInfo[0]["rol"];
    //this.id_usuario = argumentosRecividos["id_usuario"].toString();
    //this.rol_usuario = argumentosRecividos["rol_usuario"].toString();

    

    
    //print("--->" + id_tutoria);

    var url = Uri.parse(URL+"/getEntrada/");

    final res = await http.post(url, body: jsonEncode({"id_entrada": this.id_entrada,"current_user_id": this.id_usuario}));
    var datarecived = jsonDecode(res.body);

    print("nueva forma" + datarecived.toString());
    this.entrada = jsonDecode(res.body);
    print("*** Entrada ***");
    print(this.entrada.toString());
    return datarecived;
  }

Future cargar_info_usuario() async{
    var url = Uri.parse(URL+"/getInfoUsuario/");
    final res = await http.post(url, body: jsonEncode({"correo": this.user.email}));
    this.usuarioInfo = jsonDecode(res.body);
    print("ROL:"+this.usuarioInfo[0]["rol"]);

  }


void btnDescargar(String url) async {
  print("ok: "+SERVER_URL+url);
}

}