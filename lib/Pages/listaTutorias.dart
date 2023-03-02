
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

import '../utilidades/utilidades.dart';

class listaTutorias extends StatefulWidget {
  const listaTutorias({super.key});

  @override
  State<listaTutorias> createState() => _listaTutoriasState();
}

class _listaTutoriasState extends State<listaTutorias> {  
  
  Map argumentosRecividos = new Map();
  //String URL="http://10.0.2.2:8000";
  String URL=SERVER_URL;

  final user = FirebaseAuth.instance.currentUser!; 
  var usuarioInfo;

  String id_usuario = "";
  String rol_usuario = "";

  List tutoriasEnProgresoEstudiante=[];
  List tutoriasEnProgresoProfesor=[];
  List tutoriasPublicadas=[];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Mis Tutorias ")),
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
                      Text("Tutorias en progreso estudiante:"),
                      ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: this.tutoriasEnProgresoEstudiante.length,
                            itemBuilder: (BuildContext context, int index){
                            return  InkWell(
                              onTap: () {
                                print("'id_tutoria' : "+this.tutoriasEnProgresoEstudiante[index]["_id"]['\$oid'].toString());
                                Navigator.pushNamed(
                                  context, "/panelTutoria",
                                  arguments: {'id_tutoria': this.tutoriasEnProgresoEstudiante[index]["_id"]['\$oid']}
                                );
                              },
                              child: Card(
                                elevation: 5,
                                margin: const EdgeInsets.all(6),
                                child: SizedBox(
                                  child: Row(
                                    children: [
                                      Icon(Icons.account_tree,size: 50,color: Colors.blueAccent,),
                                      SizedBox(width: MediaQuery.of(context).size.width-70,
                                        child: Column(
                                        crossAxisAlignment:CrossAxisAlignment.start,
                                        children: [                   
                                          Text(this.tutoriasEnProgresoEstudiante[index]["nombre"].toString(),style: const TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold)),
                                          Text(this.tutoriasEnProgresoEstudiante[index]["id_profesor"][0]["nombre"].toString()),
                                          Text(this.tutoriasEnProgresoEstudiante[index]["descripcion"].toString()),
                                          Text(this.tutoriasEnProgresoEstudiante[index]["calificacion"].toString(),textDirection: TextDirection.ltr,),
                                          
                                          
                                        ],
                                      ),
                                      )
                                    ],
                                  ),              
                            
                                ),
                              ),
                            );
                          }
                        ),
                      //-----------------------------------------------------------------------------------------------------
                      Text("Tutorias en progreso profesor:"),
                       ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: this.tutoriasEnProgresoProfesor.length,
                            itemBuilder: (BuildContext context, int index){
                            return  InkWell(
                              onTap: () {
                                print("'id_tutoria' : "+this.tutoriasEnProgresoProfesor[index]["_id"]['\$oid'].toString());
                                Navigator.pushNamed(
                                  context, "/panelTutoria",
                                  arguments: {'id_tutoria': this.tutoriasEnProgresoProfesor[index]["_id"]['\$oid']}
                                );
                              },
                              child: Card(
                                elevation: 5,
                                margin: const EdgeInsets.all(6),
                                child: SizedBox(
                                  child: Row(
                                    children: [
                                      Icon(Icons.account_tree,size: 50,color: Colors.blueAccent,),
                                      SizedBox(width: MediaQuery.of(context).size.width-70,
                                        child: Column(
                                        crossAxisAlignment:CrossAxisAlignment.start,
                                        children: [                   
                                          Text(this.tutoriasEnProgresoProfesor[index]["nombre"].toString(),style: const TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold)),
                                          Text(this.tutoriasEnProgresoProfesor[index]["id_profesor"][0]["nombre"].toString()),
                                          Text(this.tutoriasEnProgresoProfesor[index]["descripcion"].toString()),
                                          Text(this.tutoriasEnProgresoProfesor[index]["calificacion"].toString(),textDirection: TextDirection.ltr,),
                                          
                                          
                                        ],
                                      ),
                                      )
                                    ],
                                  ),              
                            
                                ),
                              ),
                            );
                          }
                        ),
                      
                      //-----------------------------------------------------------------------------------------------------
                      Text("Tutorias Publicadas:"),
                      ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: tutoriasPublicadas.length,
                            itemBuilder: (BuildContext context, int index){
                            return  InkWell(
                              onTap: () {
                                print("Al hacer tap aqui, deberia llebarme a una pagina donde este toda la informacion de la tutoria(la general)");
                                //print("'id_tutoria' : "+tutorias[index]["_id"]['\$oid'].toString());
                                /*Navigator.pushNamed(
                                  context, "/panelTutoria",
                                  arguments: {'id_tutoria': tutoriasPublicadas[index]["_id"]['\$oid']}
                                );*/
                              },
                              child: Card(
                                elevation: 5,
                                margin: const EdgeInsets.all(6),
                                child: SizedBox(
                                  child: Row(
                                    children: [
                                      Icon(Icons.account_tree,size: 50,color: Colors.black,),
                                      SizedBox(width: MediaQuery.of(context).size.width-70,
                                        child: Column(
                                        crossAxisAlignment:CrossAxisAlignment.start,
                                        children: [                   
                                          Text(tutoriasPublicadas[index]["nombre"].toString(),style: const TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold)),
                                          Text(tutoriasPublicadas[index]["id_profesor"][0]["nombre"].toString()),
                                          Text(tutoriasPublicadas[index]["descripcion"].toString()),
                                          Text(tutoriasPublicadas[index]["calificacion"].toString(),textDirection: TextDirection.ltr,),
                                          
                                          
                                        ],
                                      ),
                                      )
                                    ],
                                  ),              
                            
                                ),
                              ),
                            );
                          }
                        ),
                      //-----------------------------------------------------------------------------------------------------
                      Text("Tutorias en Solicitud:"),
                      //-----------------------------------------------------------------------------------------------------
                      if(this.rol_usuario!="E")
                      MaterialButton(
                        child: const Text("Crear Tutoria"),
                        color: Colors.pink,
                        onPressed: () {
                            if(this.usuarioInfo[0]["rol"]!='P'){ return null;}
                            Navigator.pushNamed(context, "/crearTutoria",
                                arguments: {'id_usuario':this.id_usuario,'rol_usuario':this.rol_usuario});
                          },
                      )

                  ],
              );
              
            }

        },
      
      ),
      bottomNavigationBar:  myBottomNavigationBar(email: this.user.email.toString(),opcionActual: 1,),
      //floatingActionButton: FloatingActionButton(onPressed: (){print("ok");}),
    );
  }




  Future cargar_informacion() async {
    //argumentosRecividos = (ModalRoute.of(context)?.settings.arguments) as Map;
    await cargar_info_usuario();
    //this.rol_usuario = argumentosRecividos["rol_usuario"].toString();


    //--------------------------------------------------------------------------------
    //tutorias en progreso estudiante
    var url = Uri.parse(URL+"/getMisTutoriasEnProgresoEstudiante/");
    final res = await http.post(url, body: jsonEncode({"correo": this.user.email}));
    var datarecived = jsonDecode(res.body);

    print("TUTORIAS EN PROGRESO ESTUDIANTE ****" + datarecived.toString());
    this.tutoriasEnProgresoEstudiante = jsonDecode(res.body);
    //return datarecived;
    //--------------------------------------------------------------------------------
    //tutorias en progreso PROFESOR
    var url1 = Uri.parse(URL+"/getMisTutoriasEnProgresoProfesor/");
    final res1 = await http.post(url1, body: jsonEncode({"correo": this.user.email}));
    var datarecived1 = jsonDecode(res1.body);

    print("TUTORIAS EN PROGRESO PROFESOR ****" + datarecived1.toString());
    this.tutoriasEnProgresoProfesor = jsonDecode(res1.body);
    //return datarecived;
    //--------------------------------------------------------------------------------
    //tutorias publicadas
    var url2 = Uri.parse(URL+"/getMisTutoriasPublicadas/");
    final res2 = await http.post(url2, body: jsonEncode({"correo": this.user.email}));
    var datarecived2 = jsonDecode(res2.body);

    print("TUTORIAS PUBLICADAS **** " + datarecived2.toString());
    this.tutoriasPublicadas = jsonDecode(res2.body);
    return datarecived2;
  }

  Future cargar_info_usuario() async{
    var url = Uri.parse(URL+"/getInfoUsuario/");
    final res = await http.post(url, body: jsonEncode({"correo": this.user.email}));
    this.usuarioInfo = jsonDecode(res.body);

    print("ROL:"+this.usuarioInfo[0]["rol"]);

    this.id_usuario = this.usuarioInfo[0]["_id"]["\$oid"] ;
    this.rol_usuario = this.usuarioInfo[0]["rol"];

  }

 
}