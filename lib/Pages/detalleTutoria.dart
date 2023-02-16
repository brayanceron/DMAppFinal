import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

class detalleTutoria extends StatefulWidget {
  const detalleTutoria({super.key});

  @override
  State<detalleTutoria> createState() => _detalleTutoriaState();
}

class _detalleTutoriaState extends State<detalleTutoria> {
  String id_tutoria = "";
  String id_usuario = "";
  String rol_usuario = "";
  List tutoria = [];
  String URL="http://10.0.2.2:8000";

  Map argumentosRecividos = new Map();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Detalle de la tutoria")),
        body: FutureBuilder(
          future: cargar_informacion(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } 
            else if (snapshot.connectionState == ConnectionState.none) {
              return const Text("error");
            } 
            else {
              return ListView(
                children: [
                  Text(tutoria[0]["nombre"].toString(),style: const TextStyle(fontSize: 40, color: Colors.black,fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: Icon(Icons.open_in_new_rounded ,size: 30, color: Colors.blueAccent),
                    onPressed: (){print("object");}
                  ),
                  Text("Puntiación: " +tutoria[0]["calificacion"].toString() +" *"),
                  Text("Fecha de creación: 03/06/2022"),
                  Text(tutoria[0]["descripcion"].toString() + " *"),
                  Text("Profesor: "),
                  InkWell(
                    onTap: () {
                      print("'id_profesor' : " + tutoria[0]["id_profesor"][0]['_id']["\$oid"] + "  'nombre':" + tutoria[0]["id_profesor"][0]["nombre"]);
                    },
                    child: Card(
                      elevation: 5,
                      margin: const EdgeInsets.all(6),
                      child: SizedBox(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.account_circle_rounded,size: 50,color: Colors.blueAccent,),
                            Expanded(child: Text(tutoria[0]["id_profesor"][0]["nombre"].toString())),
                            const Icon(Icons.chat,size: 30, color: Colors.blueAccent)
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),

                  const Text("Integrantes: "),
                  ListView.builder(
                    //scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: tutoria[0]["id_estudiantes"].length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          print("'id_estudiante' : " +tutoria[0]["id_estudiantes"][index]['_id']["\$oid"] +"  'nombre':" +tutoria[0]["id_estudiantes"][index]["nombre"]);
                        },
                        child: Card(
                          elevation: 5,
                          margin: const EdgeInsets.all(6),
                          child: SizedBox(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon( Icons.account_circle_rounded,size: 50,color: Colors.blueAccent,),
                                Expanded(child: Text(tutoria[0]["id_estudiantes"][index]["nombre"])),
                                const Icon(Icons.chat,size: 30, color: Colors.blueAccent)
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
        ));
  }

  Future cargar_informacion() async {
    argumentosRecividos = (ModalRoute.of(context)?.settings.arguments) as Map;
    this.id_tutoria = argumentosRecividos["id_tutoria"].toString();
    this.id_usuario = argumentosRecividos["id_usuario"].toString();
    this.rol_usuario = argumentosRecividos["rol_usuario"].toString();
    
    print("--->" + id_tutoria);

    var url = Uri.parse(URL+"/getTutoria/");

    /*await http.post(url,body: jsonEncode({"id_tutoria":this.id_tutoria})).then((res) {
      //var datarecived = jsonDecode(res.body);
      print("Peticion recivida: " + jsonDecode(res.body).toString());           
    });*/
    final res =
    await http.post(url, body: jsonEncode({"id_tutoria": this.id_tutoria}));
    var datarecived = jsonDecode(res.body);

    print("nueva forma" + datarecived.toString());
    this.tutoria = jsonDecode(res.body);
    return datarecived;
  }


}
