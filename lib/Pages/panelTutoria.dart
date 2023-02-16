import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class panelTutoria extends StatefulWidget {
  const panelTutoria({super.key});

  @override
  State<panelTutoria> createState() => _panelTutoriaState();
}

class _panelTutoriaState extends State<panelTutoria> {
  String id_tutoria = "";
  String id_usuario = "";
  String rol_usuario = "";

  Map argumentosRecividos = new Map();

  List tutoria=[];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: 
      AppBar(title: const Text("Panel principal tutoria"),),

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
                            Text(tutoria[0]["nombre"].toString(),style:  const TextStyle(fontSize: 40,color: Colors.black,fontWeight: FontWeight.bold)),
                            IconButton(alignment: Alignment.bottomLeft,
                              icon: const Icon(Icons.add_box,size: 30,color: Colors.blueAccent),
                              onPressed: () {
                                Navigator.pushNamed(context, "/detalleTutoria", 
                                arguments: {'id_tutoria': id_tutoria,'id_usuario':id_usuario,'rol_usuario':rol_usuario});
                              },
                            ),
                            IconButton(alignment: Alignment.bottomLeft,
                               icon: Icon(Icons.fiber_new,size: 30,color: Colors.redAccent),
                              onPressed: () {
                                print("ok");
                              },
                              ),
                            SizedBox(height: 20,),
                            const Text("Entradas: "),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: (tutoria[0]["entradas"]).length,
                              itemBuilder: (context, int index) {
                                return  InkWell(
                                  onTap: () {
                                    //print("id_tutoria' : "+this.id_tutoria+",  'id_entrada':"+tutoria[0]["entradas"][index]["_id"]["\$oid"].toString()+" id_usuario"+id_usuario+" rol:"+rol_usuario);
                                    //Desde aqui hay qllamar a verEntrada y mandarle los parmetros necesarios
                                    Navigator.pushNamed(context, "/getEntrada",
                                      arguments: {'id_tutoria':id_tutoria,'id_entrada':tutoria[0]["entradas"][index]["_id"]["\$oid"],
                                      'id_usuario':id_usuario,'rol_usuario':rol_usuario} );
                                    
                                  },
                                  child: Card(
                                              elevation: 5,
                                              margin: const EdgeInsets.all(20),
                                              child: SizedBox(
                                                  child: Column(
                                                  children: [
                                                    Text(tutoria[0]["entradas"][index]["titulo"].toString(),style: const TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),                      
                                                    Row(
                                                      children: [
                                                        const Icon(Icons.account_circle_rounded,size: 30,color: Colors.blueAccent,),
                                                        Text(tutoria[0]["id_profesor"][0]["nombre"]),   
                                                      ],
                                                    ),
                                                    
                                                    const SizedBox(height: 10,),
                                                    Text(tutoria[0]["entradas"][index]["descripcion"]),
                                                    Padding(
                                                      padding: const EdgeInsets.only(bottom: 10,top: 15,left: 2,right: 4),
                                                      child: Row(
                                                      children: [
                                                        Expanded(child: Text(tutoria[0]["entradas"][index]["fecha_creacion"],style: TextStyle(fontSize: 10,color: Colors.black))),
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
        )
    );
  }



  Future cargar_informacion() async {
    argumentosRecividos = (ModalRoute.of(context)?.settings.arguments) as Map;
    this.id_tutoria = argumentosRecividos["id_tutoria"].toString();
    this.id_usuario = argumentosRecividos["id_usuario"].toString();
    this.rol_usuario = argumentosRecividos["rol_usuario"].toString();
    
    print("--->" + id_tutoria);

    var url = Uri.parse("http://192.168.1.57:8000/getContenidoTutoria/");

    final res = await http.post(url, body: jsonEncode({"id_tutoria": this.id_tutoria}));
    var datarecived = jsonDecode(res.body);

    print("nueva forma" + datarecived.toString());
    this.tutoria = jsonDecode(res.body);
    return datarecived;
  }

}