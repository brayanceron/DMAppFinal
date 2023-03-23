import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

import '../utilidades/utilidades.dart';

class solicitudesEstudiante extends StatefulWidget {
  const solicitudesEstudiante({super.key});

  @override
  State<solicitudesEstudiante> createState() => _solicitudesEstudianteState();
}

class _solicitudesEstudianteState extends State<solicitudesEstudiante> {
  Map argumentosRecividos = new Map();
  //String URL="http://10.0.2.2:8000";
  String URL=SERVER_URL;
  
  final user = FirebaseAuth.instance.currentUser!; 
  var usuarioInfo;

  List solicitudesEstudiante=[];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text("Solicitudes Estudiantes")),
      body: SafeArea(
        child: FutureBuilder(
          future: cargar_informacion(),
          builder: (context, snapshot) {
              if(snapshot.data==null){
                if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
                } 
                else if (snapshot.connectionState == ConnectionState.none) {
                  return Center(child: const Text("Error de conexión, intentelo nuevamente"));
                }
                else{
                  return Center(child: const Text("Error de conexión, intentelo nuevamente"));
                }
              }
              else{
                try{
                return ListView(
                  children: [
                    barraBusqueda(),
                    Text("Solicitudes Pendientes",style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
      
                    //--------------------------------------------------------
                   
      
      
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: solicitudesEstudiante.length,
                      itemBuilder: (context, index) {
                         return /*InkWell(
                                onTap: () {                                
                                  /*Navigator.pushNamed(context, "/panelTutoria",
                                    arguments: {'id_tutoria': this.tutoriasEnProgresoProfesor[index]["_id"]['\$oid']}
                                  );*/
                                },
                                child: Card(
                                  elevation: 5,
                                  margin: const EdgeInsets.all(6),
                                  child: Column(
                                          crossAxisAlignment:CrossAxisAlignment.start,
                                          children: [                   
                                            Text("Solicitud",style: const TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold)),
                                            Text("Tutoria: "+this.solicitudesEstudiante[index]["id_tutoria_publicada"][0]["nombre"].toString()),
                                            //Text(this.tutoriasEnProgresoProfesor[index]["id_profesor"][0]["nombre"].toString()),
                                            //Text(this.solicitudes[index]["id_tutoria_publicada"][0]["descripcion"].toString()),
                                            Text("Profesor: "+this.solicitudesEstudiante[index]["id_profesor"][0]["nombre"].toString(),textDirection: TextDirection.ltr,),
                                            Text("Estado: "+this.solicitudesEstudiante[index]["estado"]),
                                            Row(
                                              children: [
                                                if(this.solicitudesEstudiante[index]["estado"]!="ESPERA")MaterialButton(//ESte boton debe aparecer si la tutoria ya ha sido aprobada o rechazda
                                                    color: Colors.yellowAccent,
                                                    child: Text("Borrar Notificacion"),
                                                    onPressed: (){
                                                      //if(this.usuarioInfo[0]["rol"]=='P'){ print("No eres estudiante");return null;}
                                                      btnBorrarSolicitud(this.solicitudesEstudiante[index]["_id"]["\$oid"],this.usuarioInfo[0]["_id"]["\$oid"]);
                                                  }),
                                                  if(this.solicitudesEstudiante[index]["estado"]=="ESPERA") MaterialButton(//ESte boton debe aparecer si solamente la tutoria esta en espera
                                                    color: Colors.redAccent,
                                                    child: Text("Cancelar"),
                                                    onPressed: (){
                                                      btnCancelar(this.solicitudesEstudiante[index]["_id"]["\$oid"],this.solicitudesEstudiante[index]["id_solicitante"][0]["_id"]["\$oid"]);
                                                      //btnCancelar(this.solicitudesEstudiante[index]["_id"]["\$oid"],this.usuarioInfo[0]["_id"]["\$oid"]);
                                                  }),
                                              ],
                                            )
                                          ],
                                        ),
                                        
                                ),
                              );*/


                               Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    //color: Colors.green[700],
                                    gradient: LinearGradient(
                                      colors: [Colors.grey.shade50,Colors.grey.shade100],
                                      begin: Alignment.topLeft, 
                                      end: Alignment.bottomRight
                                      ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade400,
                                        blurRadius: 12,
                                        offset: Offset(0, 6)
                                      )
                                    ]
                                  ),
                                  child: ListTile(
                                    title: Text("Solicitud",style: TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Has solicitado a "+this.solicitudesEstudiante[index]["id_profesor"][0]["nombre"]+" unirte a la tutoria "+this.solicitudesEstudiante[index]["id_tutoria_publicada"][0]["nombre"],style: TextStyle(fontSize: 13),),
                                        Text("Estado: "+this.solicitudesEstudiante[index]["estado"],style: TextStyle(fontSize: 10,)),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            if(this.solicitudesEstudiante[index]["estado"]!="ESPERA") Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: MaterialButton(height: 27, 
                                                color: Colors.black,
                                                child: Text("Borrar",style: TextStyle(color: Colors.white)),
                                                onPressed: (){
                                                  btnBorrarSolicitud(this.solicitudesEstudiante[index]["_id"]["\$oid"],this.usuarioInfo[0]["_id"]["\$oid"]);
                                                },),
                                            ),
                                            if(this.solicitudesEstudiante[index]["estado"]=="ESPERA") Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: MaterialButton(height: 27,
                                                color: Colors.black,
                                                child: Text("Cancelar",style: TextStyle(color: Colors.white),),
                                                onPressed: (){
                                                   btnCancelar(this.solicitudesEstudiante[index]["_id"]["\$oid"],this.solicitudesEstudiante[index]["id_solicitante"][0]["_id"]["\$oid"]);
                                                },),
                                            )
      
                                          ],
                                        ),
                                      ],
                                    ),
                                    trailing: Icon(Icons.flutter_dash_sharp,size: 30),
                                    leading: CircleAvatar(
                                              radius: 20.0,
                                              backgroundColor: Colors.blue,
                                              //backgroundImage: NetworkImage(SERVER_URL+this.solicitudesEstudiante[index]["id_solicitante"][0]["foto"]["url"].toString()), //FOTO DEL ESTUDIANTE
                                              backgroundImage: NetworkImage(SERVER_URL+this.solicitudesEstudiante[index]["id_profesor"][0]["foto"]["url"].toString()),//FOTO DEL PROFESOR
                                              
                                              ) /*Icon(Icons.flutter_dash_sharp,size: 30,)*/,
                                    //isThreeLine: true,
                                    iconColor: Colors.black,
                                    textColor: Colors.black,
                                    contentPadding: EdgeInsets.all(10.0),
                                    //tileColor: Colors.indigo,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    
                                    onTap: () {
                                      
                                    },
                                  ),
                                ),
                              ); 
                    



                          
                      },
                    ),
                     if( solicitudesEstudiante.length==0)Center(child: Text("sin solicitudes"))
                  ],
                );
                }
                catch(e){
                  exepcionDialogo(context);
                  return const Text("error");
                }
              }
          },
        ),
      ),
      bottomNavigationBar:  myBottomNavigationBar(email: this.user.email.toString(),opcionActual: 2,)
        
    );
  }



  Future cargar_informacion() async {
    try{
      await cargar_info_usuario();
 
    var url = Uri.parse(URL+"/getSolicitudesEstudiante/");
    final res = await http.post(url, body: jsonEncode({"correo": this.user.email}));
    var datarecived = jsonDecode(res.body);
    //var datarecived = res.body;
    print("SOLICITUDES ENCONTRADAS ESTUDIANTE ****" + datarecived.toString());
    this.solicitudesEstudiante = jsonDecode(res.body);
    return datarecived;
    }
    catch(e){
      exepcionDialogo(context);
      return null;
    }
    

  }


  Future cargar_info_usuario() async{
    var url = Uri.parse(URL+"/getInfoUsuario/");
    final res = await http.post(url, body: jsonEncode({"correo": this.user.email}));
    this.usuarioInfo = jsonDecode(res.body);
    print("ROL:"+this.usuarioInfo[0]["rol"]);
    //print("ID:"+this.usuarioInfo[0]["_id"]["\$oid"]); //id del usuario
  }


void btnCancelar(String id_solicitud,String id_estudiante_propietario_solicitud) async{
  try{
  print("Rechazando la solicitud"+id_solicitud);
  print("Id del usuario que inicio sesion "+this.usuarioInfo[0]["_id"]["\$oid"]);
  print("Id del estudiante dueño de la solicitud "+id_estudiante_propietario_solicitud);

  if(this.usuarioInfo[0]["_id"]["\$oid"]==id_estudiante_propietario_solicitud){
      print("SI se puede rechazar la solicitud");
      var url = Uri.parse(URL+"/cancelarSolicitud/");
      final res = await http.post(url, body: jsonEncode({"id_solicitud": id_solicitud, "id_usuario":this.usuarioInfo[0]["_id"]["\$oid"]}));
      
      if(res.statusCode==403){
        print("No tienes permisos");
        exepcionMessageDialogo(context,"No tienes permisos" );
      }
      else if(res.statusCode==500){
        print("Ha ocurrido un error interno en el servidor");
        exepcionMessageDialogo(context,"Ha ocurrido un error interno en el servidor" );
      }
      else if(res.statusCode==428){
        print("La solicitud ya no esta en espera");
        exepcionMessageDialogo(context,"La solicitud ya no esta en espera" );
        recargar();
      }
      else{ 
        print("Accion realizada exitosamente");
        recargar();
      }
      
    } 
    else{
      print("No eres el dueño de esta tutoria para rechazar esta solicitud");
      exepcionMessageDialogo(context,"No eres el dueño de esta tutoría para rechazar esta solicitud");
      }/*Pressentar esto en una ventana de dialogo */
  }
  catch(e){exepcionDialogo(context,);}

}


void btnBorrarSolicitud(String id_solicitud,String id_current_user) async {
    try{
    print("Borrar...");
    var url = Uri.parse(URL+"/borrarSolicitud/");
      final res = await http.post(url, body: jsonEncode({"id_solicitud": id_solicitud, "id_usuario":id_current_user}));
      
      if(res.statusCode==403){
        print("No tienes permisos");
        exepcionMessageDialogo(context,"No tienes permisos" );
      }
      else if(res.statusCode==500){
        print("Ha ocurrido un error interno en el servidor");
        exepcionMessageDialogo(context,"Ha ocurrido un error interno en el servidor" );
      }
      else{ 
        print("Accion borrar notificacion realizada exitosamente");
        recargar();
      }
    }
    catch(e){exepcionDialogo(context,);}


 }


  void recargar(){
    Navigator.pushNamed(context, "/solicitudesEstudiante",arguments: {
                    'id_tutoria_publicada':this.argumentosRecividos["id_tutoria_publicada"].toString(),
                    'id_solicitante':this.argumentosRecividos["id_tutoria_publicada"].toString(),//(leonor castillo) //deberia ir this.id_usuario
                    'id_profesor':this.argumentosRecividos["id_tutoria_publicada"].toString()                    
                    });
  }

}