
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

import '../utilidades/utilidades.dart';


class catalogoTutorias extends StatefulWidget {
  const catalogoTutorias({super.key});

  @override
  State<catalogoTutorias> createState() => _catalogoTutoriasState();
}

class _catalogoTutoriasState extends State<catalogoTutorias> {
  //String URL="http://10.0.2.2:8000";
  String URL=SERVER_URL;
  
  Map argumentosRecividos = new Map();
  final user = FirebaseAuth.instance.currentUser!; 
  var usuarioInfo;

  String id_usuario_profesor="";
  String rol_usuario="";
  String id_tutoria="";
  
  List catalogoTutorias=[];

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: Text("Catalogo de tutorias")) ,
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
                  
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Buscar",
                            border: OutlineInputBorder(),
                          ),
                        ),
                  ),
                 
                  MaterialButton(
                    color: Colors.blueAccent,
                    child: Text("Unirme"),
                    onPressed: (){btnUnirme(context);}),
                  Text("Tutorias Disponibles"),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: catalogoTutorias.length,
                    itemBuilder: (context, index) {
                    return  InkWell(
                              onTap: () {                                
                                print("'id_tutoria' : "+catalogoTutorias[index]["_id"]['\$oid'].toString());
                                print("Al hacer tap aqui, deberia llebarme a una pagina donde este toda la informacion de la tutoria(la general)");
                                /*Navigator.pushNamed(
                                  context, "/panelTutoria",
                                  arguments: {'id_tutoria': catalogoTutorias[index]["_id"]['\$oid']}
                                )*/;
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
                                          Text(catalogoTutorias[index]["nombre"].toString(),style: const TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold)),
                                          Text(catalogoTutorias[index]["id_profesor"][0]["nombre"].toString()),
                                          Text(catalogoTutorias[index]["descripcion"].toString()),
                                          Text(catalogoTutorias[index]["calificacion"].toString(),textDirection: TextDirection.ltr,),
                                          MaterialButton(
                                            color: Colors.green,
                                            child: Text("Inscribir"),
                                            onPressed: (){
                                              //print("id tutorira publicada: "+catalogoTutorias[index]["_id"]["\$oid"].toString());
                                              //print("id profesor: "+catalogoTutorias[index]["id_profesor"][0]["_id"]["\$oid"].toString());
                                              btnInscribir(catalogoTutorias[index]["_id"]["\$oid"],catalogoTutorias[index]["id_profesor"][0]["_id"]["\$oid"]);
                                          })
                                          
                                        ],
                                      ),
                                      )
                                    ],
                                  ),              
                            
                                ),
                              ),
                            );
                    },
                    
                    )
                ],
              );
            }
        },
        ),
      bottomNavigationBar: myBottomNavigationBar(email: this.user.email.toString(),opcionActual: 0,)
    );
  }

 
 
  Future cargar_informacion() async {
 
    await cargar_info_usuario();
 
    var url = Uri.parse(URL+"/getCatalogoTutorias/");
    final res = await http.get(url);
    var datarecived = jsonDecode(res.body);

    print("****CATALOGO DE TUTORIAS*****\n" + datarecived.toString());
    this.catalogoTutorias = jsonDecode(res.body);
    return datarecived;

  }

  Future cargar_info_usuario() async{
    var url = Uri.parse(URL+"/getInfoUsuario/");
    final res = await http.post(url, body: jsonEncode({"correo": this.user.email}));
    this.usuarioInfo = jsonDecode(res.body);
    print("ROL:"+this.usuarioInfo[0]["rol"]);

  }


  void btnInscribir(id_tutorira_publicada,id_profesor) async{
    if(this.usuarioInfo[0]["rol"]=='P'){ print("No eres estudiante");return null;}
    //print("id del solicitante: "+this.usuarioInfo[0]["_id"]["\$oid"]); //validar si ya no ha hecho otra solicitud a la misma tutoria
    //print("id tutoria publicada: "+id_tutorira_publicada);
    //print("id profesor: "+id_profesor);
    //print("inscribiendo...");

    var url = Uri.parse(URL+"/registrarSolicitud/");
    final res = await http.post(url, body: jsonEncode({
        "id_tutoria_publicada": id_tutorira_publicada, 
        "id_solicitante":this.usuarioInfo[0]["_id"]["\$oid"],
        "id_profesor": id_profesor
        }));
      
    if(res.statusCode==200){
      print("Accion realizada exitosamente");
      
    }else{ 
      print("Se presento un problema, no se puede continuar con la operacion");/*Pressentar esto en una ventana de dialogo */
    }
    Navigator.pushNamed(context, "/solicitudesEstudiante");


  }

  void btnUnirme(BuildContext context){
    showDialog(
      context: context, 
      builder: (context) {return unirmeDialogo();},
    );
  }


  Widget unirmeDialogo(){
    String unirme_totoria_resultado="";
    TextEditingController idTutoriaController=TextEditingController();
    return StatefulBuilder(
      builder: (context, setState) {
          return  SimpleDialog (
                    title: const Text("Unirme"),
                    children: [
                      Padding(
                        padding:  const EdgeInsets.all(15.0),
                          child: TextFormField(
                              controller: idTutoriaController,
                              decoration:  InputDecoration(
                              labelText: "Código de la tutoria",
                              border: OutlineInputBorder(),
                              ),
                          ),
                      ),
                      Text(unirme_totoria_resultado),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: MaterialButton(
                          child: Text("Unirme"),
                          color: Colors.blueAccent,
                          onPressed: () async {
                            String codres =await btnBuscarTutoriaId(idTutoriaController.text);
                            print("coderes "+ codres);
                            if(codres != "200"){
                                setState(() {                      
                                  unirme_totoria_resultado="Tutoria no encontrada";
                                });
                                
                            }
                            else{
                                print("paso"); //navegar hacia el panel de la tutoria
                                Navigator.pushNamed(context, "/panelTutoria",
                                  arguments: {'id_tutoria': idTutoriaController.text});
                            }
                          }
                        ),
                      ),
                      
                    ],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  );
      },
      );
     
  }

  Future<String> btnBuscarTutoriaId(String id_tutoria) async {
    print("print desde el boton de un dialog");
    var url = Uri.parse(URL+"/unirmeTutoria/");
    final res = await http.post(url, body: jsonEncode({"id_tutoria": id_tutoria,"id_usuario":this.usuarioInfo[0]["_id"]["\$oid"]}));
    //this.usuarioInfo = jsonDecode(res.body);
    print("respuest: "+res.statusCode.toString());
    //return res.statusCode.toString();
    return res.statusCode.toString();
  }


}