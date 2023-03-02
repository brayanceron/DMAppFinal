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
      appBar: AppBar(title: Text("Solicitudes Estudiantes")),
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
                  Text("Solicitudes Pendientes"),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: solicitudesEstudiante.length,
                    itemBuilder: (context, index) {
                       return InkWell(
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
                                                    print("Borrar Notificacion");
                                                }),
                                                if(this.solicitudesEstudiante[index]["estado"]=="ESPERA") MaterialButton(//ESte boton debe aparecer si solamente la tutoria esta en espera
                                                  color: Colors.redAccent,
                                                  child: Text("Cancelar"),
                                                  onPressed: (){
                                                    btnCancelar(this.solicitudesEstudiante[index]["_id"]["\$oid"],this.solicitudesEstudiante[index]["id_solicitante"][0]["_id"]["\$oid"]);
                                                }),
                                            ],
                                          )
                                        ],
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
      bottomNavigationBar:  myBottomNavigationBar(email: this.user.email.toString(),opcionActual: 2,)
        
    );
  }



  Future cargar_informacion() async {
 
    await cargar_info_usuario();
 
    var url = Uri.parse(URL+"/getSolicitudesEstudiante/");
    final res = await http.post(url, body: jsonEncode({"correo": this.user.email}));
    var datarecived = jsonDecode(res.body);
    //var datarecived = res.body;
    print("SOLICITUDES ENCONTRADAS ESTUDIANTE ****" + datarecived.toString());
    this.solicitudesEstudiante = jsonDecode(res.body);

  }


  Future cargar_info_usuario() async{
    var url = Uri.parse(URL+"/getInfoUsuario/");
    final res = await http.post(url, body: jsonEncode({"correo": this.user.email}));
    this.usuarioInfo = jsonDecode(res.body);
    print("ROL:"+this.usuarioInfo[0]["rol"]);

  }


  void btnCancelar(String id_solicitud,String id_estudiante_propietario_solicitud) async{
  print("Rechazando la solicitud"+id_solicitud);
  print("Id del usuario que inicio sesion "+this.usuarioInfo[0]["_id"]["\$oid"]);
  print("Id del estudiante dueño de la solicitud "+id_estudiante_propietario_solicitud);

  if(this.usuarioInfo[0]["_id"]["\$oid"]==id_estudiante_propietario_solicitud){
      print("SI se puede rechazar la solicitud");
      var url = Uri.parse(URL+"/cancelarSolicitud/");
      final res = await http.post(url, body: jsonEncode({"id_solicitud": id_solicitud, "id_usuario":this.usuarioInfo[0]["_id"]["\$oid"]}));
      
      if(res.statusCode==403 || res.statusCode==500){
        print("No tienes permisos");
      }else{ 
        print("Accion realizada exitosamente");
        recargar();
      }
      
    } 
    else{print("No eres el dueño de esta tutoria para rechazar esta solicitud");}/*Pressentar esto en una ventana de dialogo */


}




  void recargar(){
    Navigator.pushNamed(context, "/solicitudesEstudiante",arguments: {
                    'id_tutoria_publicada':this.argumentosRecividos["id_tutoria_publicada"].toString(),
                    'id_solicitante':this.argumentosRecividos["id_tutoria_publicada"].toString(),//(leonor castillo) //deberia ir this.id_usuario
                    'id_profesor':this.argumentosRecividos["id_tutoria_publicada"].toString()                    
                    });
  }

}