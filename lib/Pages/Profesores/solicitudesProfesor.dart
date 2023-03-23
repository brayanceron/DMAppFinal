import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

import '../../utilidades/utilidades.dart';

class solicitudesProfesor extends StatefulWidget {
  const solicitudesProfesor({super.key});

  @override
  State<solicitudesProfesor> createState() => _solicitudesProfesorState();
}

class _solicitudesProfesorState extends State<solicitudesProfesor> {
  Map argumentosRecividos = new Map();
  //String URL="http://10.0.2.2:8000";
  String URL=SERVER_URL;

  final user = FirebaseAuth.instance.currentUser!; 
  var usuarioInfo;

  List solicitudesProfesor=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text("Solicitudes Profesor")),
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
                  //Text("Solicitudes Pendientes"),
                  barraBusqueda(),
                  Text("Solicitudes Pendientes",style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                   /*
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
                                        Text("El estudiante XXXX ha pedido uniser a la tutoria YYYY",style: TextStyle(fontSize: 13),),
                                        Text("Estado: Espera",style: TextStyle(fontSize: 10,)),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: MaterialButton(height: 27, 
                                                color: Colors.black,
                                                child: Text("Aceptar",style: TextStyle(color: Colors.white)),
                                                onPressed: (){
                                                  
                                                },),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: MaterialButton(height: 27,
                                                color: Colors.black,
                                                child: Text("Reach",style: TextStyle(color: Colors.white),),
                                                onPressed: (){
                                                  
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
                                              backgroundImage: NetworkImage("http://192.168.1.57:8000/api/media/2e33a8bd-d7e4-46a0-9371-b1ac37390455IBSJ-_-ML.jpg"),
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
                              ), 
                    */
                  //----------------------------------------------------------------
                 
                 //----------------------------------------------------------------
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: solicitudesProfesor.length,
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
                                        Text('El estudiante '+this.solicitudesProfesor[index]["id_solicitante"][0]["nombre"]+' ha pedido uniser a la tutoría "'+
                                        this.solicitudesProfesor[index]["id_tutoria_publicada"][0]["nombre"]+'"',style: TextStyle(fontSize: 13),),
                                        Text("Estado: "+this.solicitudesProfesor[index]["estado"],style: TextStyle(fontSize: 10,)),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: MaterialButton(height: 27, 
                                                color: Colors.black,
                                                child: Text("Aceptar",style: TextStyle(color: Colors.white)),
                                                onPressed: (){
                                                  btnAceptar(this.solicitudesProfesor[index]["_id"]["\$oid"],this.solicitudesProfesor[index]["id_profesor"][0]["_id"]["\$oid"]);
                                                },),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: MaterialButton(height: 27,
                                                color: Colors.black,
                                                child: Text("Rechazar",style: TextStyle(color: Colors.white),),
                                                onPressed: (){
                                                   btnRechazar(this.solicitudesProfesor[index]["_id"]["\$oid"],this.solicitudesProfesor[index]["id_profesor"][0]["_id"]["\$oid"]);
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
                                              //backgroundImage: NetworkImage("http://192.168.1.57:8000/api/media/2e33a8bd-d7e4-46a0-9371-b1ac37390455IBSJ-_-ML.jpg"),
                                              backgroundImage: NetworkImage(SERVER_URL+this.solicitudesProfesor[index]["id_solicitante"][0]["foto"]["url"].toString()),
                                              
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
                  if( solicitudesProfesor.length==0)Center(child: Text("sin solicitudes"))
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


 void btnAceptar(String id_solicitud,String id_profesor_propietario_tutoria) async{

    try{
    print("Aceptando la solicitud "+id_solicitud);
    print("Id del usuario que inicio sesion "+this.usuarioInfo[0]["_id"]["\$oid"]);
    print("Id del profesor dueño de la tutoria "+id_profesor_propietario_tutoria);

    if(this.usuarioInfo[0]["rol"]=='P' && this.usuarioInfo[0]["_id"]["\$oid"]==id_profesor_propietario_tutoria){
      print("SI se puede puede aceptar la solicitud");
      var url = Uri.parse(URL+"/aceptarSolicitud/");
      final res = await http.post(url, body: jsonEncode({"id_solicitud": id_solicitud, "id_usuario":this.usuarioInfo[0]["_id"]["\$oid"]}));
      
      if(res.statusCode==403 ){
        print("No tienes permisos");/*Pressentar esto en una ventana de dialogo */
        exepcionMessageDialogo(context,"No tienes permisos" );
      }
      else if(res.statusCode==500){
         print("Hubo un error interno en el servidor");
         exepcionMessageDialogo(context,"Hubo un error interno en el servidor" );
      }
      else if(res.statusCode==428){
         print("La solicitud ya no esta en estado espera");
         exepcionMessageDialogo(context,"La solicitud ya no esta en estado espera" );
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

void btnRechazar(String id_solicitud,String id_profesor_propietario_tutoria) async{
    try{
    print("Rechazando la solicitud "+id_solicitud);
    print("Id del usuario que inicio sesion "+this.usuarioInfo[0]["_id"]["\$oid"]);
    print("Id del profesor dueño de la tutoria "+id_profesor_propietario_tutoria);

    if(this.usuarioInfo[0]["rol"]=='P' && this.usuarioInfo[0]["_id"]["\$oid"]==id_profesor_propietario_tutoria){
      print("SI se puede rechazar la solicitud");
      var url = Uri.parse(URL+"/rechazarSolicitud/");
      final res = await http.post(url, body: jsonEncode({"id_solicitud": id_solicitud, "id_usuario":this.usuarioInfo[0]["_id"]["\$oid"]}));
      
      if(res.statusCode==403 ){
        print("No tiene permisos para realizar esta accion");/*Pressentar esto en una ventana de dialogo */
        exepcionMessageDialogo(context,"No tiene permisos para realizar esta acción" );
      }
      else if(res.statusCode==500){
        print("Hubo un error interno en el servidor y no puedo completarse la acción");
        exepcionMessageDialogo(context,"Hubo un error interno en el servidor y no puedo completarse la acción" );
      }
      else if(res.statusCode==428){
        print("La solicitud ya no esta en estado espera");
        exepcionMessageDialogo(context,"La solicitud ya no esta en estado espera" );
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


  void recargar(){
    Navigator.pushNamed(context, "/solicitudesProfesor",arguments: {
                    'id_tutoria_publicada':this.argumentosRecividos["id_tutoria_publicada"].toString(),
                    'id_solicitante':this.argumentosRecividos["id_tutoria_publicada"].toString(),//(leonor castillo) //deberia ir this.id_usuario
                    'id_profesor':this.argumentosRecividos["id_tutoria_publicada"].toString()                    
                    });
  }

  Future cargar_informacion() async {
    
    try{
      await cargar_info_usuario();
 
    var url = Uri.parse(URL+"/getSolicitudesProfesor/");
    final res = await http.post(url, body: jsonEncode({"correo": this.user.email}));
    var datarecived = jsonDecode(res.body);
    //var datarecived = res.body;
    print("SOLICITUDES ENCONTRADAS ****" + datarecived.toString());
    this.solicitudesProfesor = jsonDecode(res.body);
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
    //print("id:"+this.usuarioInfo[0]["_id"]["\$oid"]); Accediendo al id del usuario

  }


}