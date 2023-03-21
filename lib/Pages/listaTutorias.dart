
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
              return Column(
                //shrinkWrap: true,                        
                //physics: BouncingScrollPhysics(),
                //scrollDirection: Axis.vertical,
                
                  children: [                      
                     //-----------------------------------------------------------------------------------------------------
                      Text("Todas las Tutorías:"),
                       
                      //-----------------------------------------------------------------------------------------------------                      
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
                      ),
                      //-----------------------------------------------------------------------------------------------------
                      
                      //-----------------------------------------------------------------------------------------------------
                      DefaultTabController(length: this.rol_usuario=="E"?2:3, 
                      child: Column(
                        //shrinkWrap: true,                        
                        //physics: BouncingScrollPhysics(),
                        //scrollDirection: Axis.vertical,
                        children:  [
                          TabBar(
                            indicatorColor: Colors.red,
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            tabs: [
                              Tab(text:  this.rol_usuario=="E"?"En progreso":"Impartidas",icon: Icon(Icons.access_time)),
                              if(this.rol_usuario=="P")Tab(text: "Publicadas",icon: Icon(Icons.public)),
                              Tab(text: "Hisorial",icon: Icon(Icons.manage_history )),
                              ]
                          ),
                          
                          Container(
                            height: 500,
                            child: TabBarView(
                            children: [
                                this.rol_usuario=="E"? TutoriasEstudiante(): TutoriasProfesor(),
                                if(this.rol_usuario=="P")TutoriasPublicadas(),
                                TutoriasHistorial(),
                            ]                            
                            ),
                          ),

                           
                          
                          
                        ],
                      )
                      
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

 
Widget TutoriasEstudiante(){
  return  ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: this.tutoriasEnProgresoEstudiante.length,
                            itemBuilder: (BuildContext context, int index){
                            if(this.tutoriasEnProgresoEstudiante[index]["estado"]=="ACTIVA"){
                            return  
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  //color: Colors.green[700],
                                  gradient: LinearGradient(
                                    colors: [Colors.green.shade800,Colors.green.shade400],
                                    begin: Alignment.topLeft, 
                                    end: Alignment.bottomRight
                                    ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.shade700,
                                      blurRadius: 12,
                                      offset: Offset(0, 6)
                                    )
                                  ]
                                ),
                                child: ListTile(
                                  title: Text(this.tutoriasEnProgresoEstudiante[index]["nombre"].toString(),style: TextStyle(fontWeight: FontWeight.bold)),
                                  subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(this.tutoriasEnProgresoEstudiante[index]["descripcion"],style: TextStyle(fontSize: 10),),
                                      Text("Estado: "+this.tutoriasEnProgresoEstudiante[index]["estado"],style: TextStyle(fontSize: 10,))
                                    ],
                                  ),
                                  trailing: Icon(Icons.arrow_forward_ios),
                                  leading: Icon(Icons.flutter_dash_sharp,size: 30,),
                                  //isThreeLine: true,
                                  iconColor: Colors.white,
                                  textColor: Colors.white,
                                  contentPadding: EdgeInsets.all(10.0),
                                  //tileColor: Colors.indigo,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  onTap: () {
                                    print("'id_tutoria' : "+this.tutoriasEnProgresoEstudiante[index]["_id"]['\$oid'].toString());
                                    Navigator.pushNamed(
                                      context, "/panelTutoria",
                                      arguments: {'id_tutoria': this.tutoriasEnProgresoEstudiante[index]["_id"]['\$oid']}
                                    );
                                  },
                                ),
                              ),
                            ); 
                            }
                            else{return Container(height: 0,);}
                          }
                        );
                      
}


Widget TutoriasProfesor(){
     return ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: this.tutoriasEnProgresoProfesor.length,
                            itemBuilder: (BuildContext context, int index){
                              

                            if(this.tutoriasEnProgresoProfesor[index]["estado"]=="ACTIVA"){
                            return 
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  //color: Colors.green[700],
                                  gradient: LinearGradient(
                                    colors: [Colors.green.shade800,Colors.green.shade400],
                                    begin: Alignment.topLeft, 
                                    end: Alignment.bottomRight
                                    ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.shade700,
                                      blurRadius: 12,
                                      offset: Offset(0, 6)
                                    )
                                  ]
                                ),
                                child: ListTile(
                                  title: Text(this.tutoriasEnProgresoProfesor[index]["nombre"].toString(),style: TextStyle(fontWeight: FontWeight.bold)),
                                  subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(this.tutoriasEnProgresoProfesor[index]["descripcion"],style: TextStyle(fontSize: 10),),
                                      Text("Estado: "+this.tutoriasEnProgresoProfesor[index]["estado"],style: TextStyle(fontSize: 10,))
                                    ],
                                  ),
                                  trailing: Icon(Icons.arrow_forward_ios),
                                  leading: Icon(Icons.flutter_dash_sharp,size: 30,),
                                  //isThreeLine: true,
                                  iconColor: Colors.white,
                                  textColor: Colors.white,
                                  contentPadding: EdgeInsets.all(10.0),
                                  //tileColor: Colors.indigo,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  onTap: () {
                                    print("'id_tutoria' : "+this.tutoriasEnProgresoProfesor[index]["_id"]['\$oid'].toString());
                                      Navigator.pushNamed(
                                        context, "/panelTutoria",
                                        arguments: {'id_tutoria': this.tutoriasEnProgresoProfesor[index]["_id"]['\$oid']}
                                      );
                                  },
                                ),
                              ),
                            );  
                          
                            }
                            else{return Container(height: 0,);}
                          
                          
                          }
                        );

                    
                      
}

Widget TutoriasPublicadas(){
  return ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: tutoriasPublicadas.length,
                            itemBuilder: (BuildContext context, int index){
                            return Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    //color: Colors.green[700],
                                    gradient: LinearGradient(
                                      colors: [Colors.amber.shade700,Colors.amber],
                                      begin: Alignment.topLeft, 
                                      end: Alignment.bottomRight
                                      ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.amber.shade900,
                                        blurRadius: 12,
                                        offset: Offset(0, 6)
                                      )
                                    ]
                                  ),
                                  child: ListTile(
                                    title: Text(tutoriasPublicadas[index]["nombre"].toString(),style: TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(this.tutoriasPublicadas[index]["descripcion"],style: TextStyle(fontSize: 10),),
                                        Text("Tutor: "+tutoriasPublicadas[index]["id_profesor"][0]["nombre"],style: TextStyle(fontSize: 10,))
                                      ],
                                    ),
                                    trailing: Icon(Icons.arrow_forward_ios),
                                    leading: Icon(Icons.flutter_dash_sharp,size: 30,),
                                    //isThreeLine: true,
                                    iconColor: Colors.white,
                                    textColor: Colors.white,
                                    contentPadding: EdgeInsets.all(10.0),
                                    //tileColor: Colors.indigo,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    onTap: () {
                                      
                                    },
                                  ),
                                ),
                              ); 


                          }
                        );
                    
}

Widget TutoriasHistorial(){

  List myLista=this.tutoriasEnProgresoProfesor;
  if(this.rol_usuario=="E"){myLista=this.tutoriasEnProgresoEstudiante;}


  return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: myLista.length,
                            itemBuilder: (BuildContext context, int index){
                              

                            if(myLista[index]["estado"]=="FINALIZADA"){
                            return Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    //color: Colors.green[700],
                                    gradient: LinearGradient(
                                      colors: [Colors.pink,Colors.red],
                                      begin: Alignment.topLeft, 
                                      end: Alignment.bottomRight
                                      ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.red,
                                        blurRadius: 12,
                                        offset: Offset(0, 6)
                                      )
                                    ]
                                  ),
                                  child: ListTile(
                                    title: Text(myLista[index]["nombre"].toString(),style: TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(myLista[index]["descripcion"],style: TextStyle(fontSize: 10),),
                                        Text("Estado: "+myLista[index]["estado"],style: TextStyle(fontSize: 10,))
                                      ],
                                    ),
                                    trailing: Icon(Icons.arrow_forward_ios),
                                    leading: Icon(Icons.flutter_dash_sharp,size: 30,),
                                    //isThreeLine: true,
                                    iconColor: Colors.white,
                                    textColor: Colors.white,
                                    contentPadding: EdgeInsets.all(10.0),
                                    //tileColor: Colors.indigo,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    onTap: () {
                                      print("'id_tutoria' : "+myLista[index]["_id"]['\$oid'].toString());
                                      Navigator.pushNamed(
                                        context, "/panelTutoria",
                                        arguments: {'id_tutoria': myLista[index]["_id"]['\$oid']}
                                      );
                                    },
                                  ),
                                ),
                              );  
                          
                            }
                            else{return Container(height: 0,);}
                          
                          
                          }
                        );
}


}


