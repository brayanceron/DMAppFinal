import 'package:appfinal/Pages/rutas.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

import '../utilidades/utilidades.dart';
import 'catalogoTutorias.dart';
import 'listaTutorias.dart';

class panelTutoria extends StatefulWidget {
  const panelTutoria({super.key});

  @override
  State<panelTutoria> createState() => _panelTutoriaState();
}

class _panelTutoriaState extends State<panelTutoria> {
  //String URL="http://10.0.2.2:8000";
  String URL=SERVER_URL;

  final user = FirebaseAuth.instance.currentUser!; 
  var usuarioInfo;
  Map argumentosRecividos = new Map();

  String id_tutoria = "";
  String id_usuario = "";
  String rol_usuario = "";

  

  List tutoria=[];
  List infotutoria=[];
  

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: 
      AppBar(title:  const Text("Panel principal tutoria "),),

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
                            //Text(tutoria[0]["nombre"].toString(),style:  const TextStyle(fontSize: 40,color: Colors.black,fontWeight: FontWeight.bold)),
                            //Text(tutoria[0]["id_tutoria"][0]["nombre"].toString(),style:  const TextStyle(fontSize: 40,color: Colors.black,fontWeight: FontWeight.bold)),
                            Text(infotutoria[0]["nombre"].toString(),style:  const TextStyle(fontSize: 40,color: Colors.black,fontWeight: FontWeight.bold)),
                            Row(
                              children: [
                                Text("Compartir:  "+infotutoria[0]["_id"]["\$oid"].toString()),
                                IconButton(
                                  icon: Icon(Icons.copy),
                                  onPressed: (() {
                                    Clipboard.setData(ClipboardData(text: infotutoria[0]["_id"]["\$oid"]..toString()));
                                })),
                              ],
                            ),
                            
                            IconButton(alignment: Alignment.bottomLeft,
                              icon: const Icon(Icons.add_box,size: 30,color: Colors.blueAccent),
                              onPressed: () {
                                Navigator.pushNamed(context, "/detalleTutoria", 
                                arguments: {'id_tutoria': id_tutoria,'id_usuario':id_usuario,'rol_usuario':rol_usuario});
                              },
                            ),
                            /*if(this.rol_usuario!="E")*/
                            IconButton(alignment: Alignment.bottomLeft,
                               icon: Icon(Icons.fiber_new,size: 30,color: Colors.redAccent),
                              onPressed: () {
                                print("ok");
                                Navigator.pushNamed(context, "/crearEntrada",
                                  arguments: {'id_usuario_profesor':'63e9b98e811ef54a3de59514','id_tutoria':id_tutoria});
                              },
                              ),
                            SizedBox(height: 20,),
                            const Text("Entradas: "),
                            
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: (tutoria).length,
                              itemBuilder: (context, int index) {
                                return  InkWell(
                                  onTap: () {
                                    //print("id_tutoria' : "+this.id_tutoria+",  'id_entrada':"+tutoria[0]["entradas"][index]["_id"]["\$oid"].toString()+" id_usuario"+id_usuario+" rol:"+rol_usuario);
                                    //Desde aqui hay qllamar a verEntrada y mandarle los parmetros necesarios
                                    Navigator.pushNamed(context, "/getEntrada",
                                      //arguments: {'id_tutoria':id_tutoria,'id_entrada':tutoria[0]["entradas"][index]["_id"]["\$oid"],
                                      arguments: {'id_tutoria':id_tutoria,'id_entrada':tutoria[index]["_id"]["\$oid"]});
                                    
                                  },
                                  child: Card(
                                              elevation: 5,
                                              margin: const EdgeInsets.all(20),
                                              child: SizedBox(
                                                  child: Column(
                                                  children: [
                                                    Text(tutoria[index]["titulo"].toString(),style: const TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),                      
                                                    Row(
                                                      children: [
                                                        const Icon(Icons.account_circle_rounded,size: 30,color: Colors.blueAccent,),
                                                        Text(tutoria[index]["id_profesor"][0]["nombre"]),   
                                                      ],
                                                    ),
                                                    
                                                    const SizedBox(height: 10,),
                                                    Text(tutoria[index]["descripcion"]),
                                                    Padding(
                                                      padding: const EdgeInsets.only(bottom: 10,top: 15,left: 2,right: 4),
                                                      child: Row(
                                                      children: [
                                                        Expanded(child: Text(tutoria[index]["fecha_creacion"],style: TextStyle(fontSize: 10,color: Colors.black))),
                                                        Expanded(
                                                          child: Align(
                                                            alignment: Alignment.centerRight,
                                                            child: Text("Archivos: 2",style:  TextStyle(fontSize: 10,color: Colors.black)),
                                                          ),
                                                          )
                                                      ],
                                                    ),
                                                    )
                                                                                                                
                                                  ],
                                                ),              
                                
                                                
                                              ),
                                        ),
                                );

                              },
                            ),
                                             


                          ],
                        );
              }
            
          },
        ),
      bottomNavigationBar: myBottomNavigationBar(email: this.user.email.toString(),opcionActual: 1,)
    );
  }



  Future cargar_informacion() async {
    argumentosRecividos = (ModalRoute.of(context)?.settings.arguments) as Map;
    await cargar_info_usuario();

    this.id_tutoria = argumentosRecividos["id_tutoria"].toString();
    this.id_usuario = this.usuarioInfo[0]["_id"]["\$oid"] ;
    this.rol_usuario = this.usuarioInfo[0]["rol"];
    
    print("ooooo--->" + id_tutoria);



    //Obteniendo las entradas de la tutoria
    var url = Uri.parse(URL+"/getContenidoTutoria/");

    final res = await http.post(url, body: jsonEncode({"id_tutoria": this.id_tutoria,"current_user_id":this.id_usuario}));
    var datarecived = jsonDecode(res.body);

    print("Entradas tutoria" + datarecived.toString());
    this.tutoria = jsonDecode(res.body);
    //return datarecived;
    //Obteniendo la informacion de la tutoria---------------------
    var url2 = Uri.parse(URL+"/getTutoria/");

    final res2 = await http.post(url2, body: jsonEncode({"id_tutoria": this.id_tutoria}));
    var datarecived2 = jsonDecode(res2.body);

    print("nueva forma" + datarecived2.toString());
    this.infotutoria = jsonDecode(res2.body);

  }

  Future cargar_info_usuario() async{
    var url = Uri.parse(URL+"/getInfoUsuario/");
    final res = await http.post(url, body: jsonEncode({"correo": this.user.email}));
    this.usuarioInfo = jsonDecode(res.body);
    print("ROL:"+this.usuarioInfo[0]["rol"]);

  }



 
}