
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../utilidades/utilidades.dart';


class catalogoTutorias extends StatefulWidget {
  const catalogoTutorias({super.key});

  @override
  State<catalogoTutorias> createState() => _catalogoTutoriasState();
}

class _catalogoTutoriasState extends State<catalogoTutorias> {

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
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                          decoration:  InputDecoration(  
                            contentPadding: EdgeInsets.symmetric(vertical: 15.0),                         
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(width: 0.8)
                            ),
                            hintText: "Buscar tutoria",                            
                            prefixIcon: Icon(Icons.search, size: 30,),
                            suffixIcon: IconButton(icon: Icon(Icons.clear),
                            onPressed: (() {
                              
                            })
                          ),
                        ),
                  )),
                 
                  MaterialButton(
                    color: Colors.blueAccent,
                    child: Text("Unirme"),
                    onPressed: (){btnUnirme(context);}),
                  Row(children: [cardTutoria(),cardTutoria(),],),
                  
                  Text("Tutorias Disponibles"),

                  //--------------################################################################
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
                                )*/
                              },
                              child: Card(
                                elevation: 5,
                                margin: const EdgeInsets.all(6),
                                child: SizedBox(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 90,
                                        height: 90,
                                        child: Image.network(
                                          URL+catalogoTutorias[index]["foto"]["url"]
                                        ),
                                      ),
                                      
                                      SizedBox(width: MediaQuery.of(context).size.width-120,
                                        child: Column(
                                        crossAxisAlignment:CrossAxisAlignment.start,
                                        children: [                   
                                          Text(catalogoTutorias[index]["nombre"].toString(),style: const TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold)),
                                          Text(catalogoTutorias[index]["id_profesor"][0]["nombre"].toString()),
                                          Text(catalogoTutorias[index]["descripcion"].toString()),
                                          Text(catalogoTutorias[index]["calificacion"].toString(),textDirection: TextDirection.ltr,),
                                          MaterialButton(
                                            height: 15,
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
                    
                    ),
                  //--------------################################################################
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    //itemCount: tutoria[index]["archivos"].length,
                    itemCount: 5,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: (185 / 310)),
                    itemBuilder: (context, index) {
                        return 
                        
                        Center(
                          child: Container(
                            width: 185,
                            height: 310,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow:[
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 10,
                                offset: Offset(0, 3)
                              ),
                              ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Image.network(URL+catalogoTutorias[index]["foto"]["url"],height: 150,),
                                    ),
                                    Text((catalogoTutorias[index]["nombre"].toString()+"             ").substring(0,25)+"...",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),),
                                    SizedBox(height: 4,),
                                    Text("Tutor: "+catalogoTutorias[index]["id_profesor"][0]["nombre"].toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      ),),
                                      SizedBox(height: 6,),
                                    RatingBar.builder(
                                      
                                      initialRating:catalogoTutorias[index]["calificacion"].toString()=="-1"? 0 : double.parse(catalogoTutorias[index]["calificacion"].toString()),
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      itemCount: 5,
                                      itemSize: 16,
                                      itemPadding: EdgeInsets.symmetric(horizontal: 4),
                                      itemBuilder: (context, _)=>Icon(
                                        Icons.star,
                                        color: Colors.red ,
                                      ),
                                    onRatingUpdate: (index){},
                                    ),
                                  SizedBox(height: 6,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("\$0",style: TextStyle(fontSize: 18,color: Colors.red,fontWeight: FontWeight.bold),
                                      ),
                                      Icon(Icons.favorite_border,
                                      color: Colors.red,
                                      size: 28,)
                                    ],
                                  ),
                                  
                                  MaterialButton(
                                    height: 15,
                                    minWidth: double.infinity,
                                    color: Colors.red,
                                    child: Text("Inscribir",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold)),
                                    onPressed: (){btnInscribir(catalogoTutorias[index]["_id"]["\$oid"],catalogoTutorias[index]["id_profesor"][0]["_id"]["\$oid"]);}),
                                  
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
    //print("Estado de la respuesta: "+res.statusCode.toString());
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
      print("Se presento un problema, no se pudo registrar la solicitud");/*Pressentar esto en una ventana de dialogo */
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


Widget cardTutoria(){
  return Center(
        child: Container(
          width: 180,
          height: 265,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow:[
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 10,
              offset: Offset(0, 3)
            ),
            ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Image.network("http://192.168.1.57:8000/api/media/2f61a849-0340-4ae4-9be3-7890b61ab1d7WhatsApp%20Image%202023-03-15%20at%209.24.03%20PM.jpeg",height: 150,),
                  ),
                  Text("Hot burger fsadfdsafdsfdsffsfsd",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold),),
                  SizedBox(height: 4,),
                  Text("taste our hot burger",
                  style: TextStyle(
                    fontSize: 16,
                    ),),
                    SizedBox(height: 6,),
                  RatingBar.builder(
                    initialRating: 4,
                    minRating: 1,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemSize: 16,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4),
                    itemBuilder: (context, _)=>Icon(
                      Icons.star,
                      color: Colors.red ,
                    ),
                  onRatingUpdate: (index){},
                  ),
                SizedBox(height: 6,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("\$10",style: TextStyle(fontSize: 18,color: Colors.red,fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.favorite_border,
                    color: Colors.red,
                    size: 28,)
                  ],
                )
                ],
              ),
            ),
          ),
      );



}


}