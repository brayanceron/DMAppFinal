import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class solicitudesProfesor extends StatefulWidget {
  const solicitudesProfesor({super.key});

  @override
  State<solicitudesProfesor> createState() => _solicitudesProfesorState();
}

class _solicitudesProfesorState extends State<solicitudesProfesor> {
  Map argumentosRecividos = new Map();
  String URL="http://10.0.2.2:8000";

  final user = FirebaseAuth.instance.currentUser!; 
  var usuarioInfo;

  List solicitudesProfesor=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Solicitudes Profesor")),
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
                    itemCount: solicitudesProfesor.length,
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
                                child: SizedBox(
                                  child: Row(
                                    children: [
                                      Icon(Icons.account_tree,size: 50,color: Colors.blueAccent,),
                                      SizedBox(width: MediaQuery.of(context).size.width-70,
                                        child: Column(
                                        crossAxisAlignment:CrossAxisAlignment.start,
                                        children: [                   
                                          Text("Solicitud",style: const TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold)),
                                          Text("Tutoria: "+this.solicitudesProfesor[index]["id_tutoria_publicada"][0]["nombre"].toString()),
                                          //Text(this.tutoriasEnProgresoProfesor[index]["id_profesor"][0]["nombre"].toString()),
                                          //Text(this.solicitudes[index]["id_tutoria_publicada"][0]["descripcion"].toString()),
                                          Text("Solicitante: "+this.solicitudesProfesor[index]["id_solicitante"][0]["nombre"].toString(),textDirection: TextDirection.ltr,),
                                          Row(
                                            children: [
                                              MaterialButton(
                                                  color: Colors.green,
                                                  child: Text("Aceptar"),
                                                  onPressed: (){
                                                    //if(this.usuarioInfo[0]["rol"]=='P'){ print("No eres estudiante");return null;}  y validar si es el dueño de la tutoria para rechazarla
                                                    btnAceptar(this.solicitudesProfesor[index]["_id"]["\$oid"],this.solicitudesProfesor[index]["id_profesor"][0]["_id"]["\$oid"]);
                                                }),
                                                MaterialButton(
                                                  color: Colors.redAccent,
                                                  child: Text("Rechazar"),
                                                  onPressed: (){
                                                    btnRechazar(this.solicitudesProfesor[index]["_id"]["\$oid"],this.solicitudesProfesor[index]["id_profesor"][0]["_id"]["\$oid"]);
                                                    //print("Solicitud Rechazada");
                                                    //print("Id de la solicitud "+this.solicitudes[index]["_id"]["\$oid"]);
                                                    //print("Id del usuario que inicio sesion "+this.usuarioInfo[0]["_id"]["\$oid"]);
                                                    //print("Id del profesor dueño de la tutoria "+this.solicitudes[index]["id_profesor"][0]["_id"]["\$oid"].toString());                                                 
                                                }),
                                            ],
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
    );
  }


 void btnAceptar(String id_solicitud,String id_profesor_propietario_tutoria) async{

    print("Aceptando la solicitud "+id_solicitud);
    print("Id del usuario que inicio sesion "+this.usuarioInfo[0]["_id"]["\$oid"]);
    print("Id del profesor dueño de la tutoria "+id_profesor_propietario_tutoria);

    if(this.usuarioInfo[0]["rol"]=='P' && this.usuarioInfo[0]["_id"]["\$oid"]==id_profesor_propietario_tutoria){
      print("SI se puede puede aceptar la solicitud");
      var url = Uri.parse(URL+"/aceptarSolicitud/");
      final res = await http.post(url, body: jsonEncode({"id_solicitud": id_solicitud, "id_usuario":this.usuarioInfo[0]["_id"]["\$oid"]}));
      
      if(res.statusCode==403 || res.statusCode==500){
        print("No tienes permisos");/*Pressentar esto en una ventana de dialogo */
      }else{ 
        print("Accion realizada exitosamente");
        recargar();
      }
      
    } 
    else{print("No eres el dueño de esta tutoria para rechazar esta solicitud");}/*Pressentar esto en una ventana de dialogo */
    
  }

  void btnRechazar(String id_solicitud,String id_profesor_propietario_tutoria) async{
    
    print("Rechazando la solicitud "+id_solicitud);
    print("Id del usuario que inicio sesion "+this.usuarioInfo[0]["_id"]["\$oid"]);
    print("Id del profesor dueño de la tutoria "+id_profesor_propietario_tutoria);

    if(this.usuarioInfo[0]["rol"]=='P' && this.usuarioInfo[0]["_id"]["\$oid"]==id_profesor_propietario_tutoria){
      print("SI se puede rechazar la solicitud");
      var url = Uri.parse(URL+"/rechazarSolicitud/");
      final res = await http.post(url, body: jsonEncode({"id_solicitud": id_solicitud, "id_usuario":this.usuarioInfo[0]["_id"]["\$oid"]}));
      
      if(res.statusCode==403 || res.statusCode==500){
        print("No tienes permisos");/*Pressentar esto en una ventana de dialogo */
      }else{ 
        print("Accion realizada exitosamente");
        recargar();
      }
      
    } 
    else{print("No eres el dueño de esta tutoria para rechazar esta solicitud");}/*Pressentar esto en una ventana de dialogo */

  }


  void recargar(){
    Navigator.pushNamed(context, "/solicitudesProfesor",arguments: {
                    'id_tutoria_publicada':this.argumentosRecividos["id_tutoria_publicada"].toString(),
                    'id_solicitante':this.argumentosRecividos["id_tutoria_publicada"].toString(),//(leonor castillo) //deberia ir this.id_usuario
                    'id_profesor':this.argumentosRecividos["id_tutoria_publicada"].toString()                    
                    });
  }

  Future cargar_informacion() async {
 
    await cargar_info_usuario();
 
    var url = Uri.parse(URL+"/getSolicitudesProfesor/");
    final res = await http.post(url, body: jsonEncode({"correo": this.user.email}));
    var datarecived = jsonDecode(res.body);
    //var datarecived = res.body;
    print("SOLICITUDES ENCONTRADAS ****" + datarecived.toString());
    this.solicitudesProfesor = jsonDecode(res.body);

  }


  Future cargar_info_usuario() async{
    var url = Uri.parse(URL+"/getInfoUsuario/");
    final res = await http.post(url, body: jsonEncode({"correo": this.user.email}));
    this.usuarioInfo = jsonDecode(res.body);
    print("ROL:"+this.usuarioInfo[0]["rol"]);
    //print("id:"+this.usuarioInfo[0]["_id"]["\$oid"]); Accediendo al id del usuario

  }


}