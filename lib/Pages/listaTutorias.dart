import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class listaTutorias extends StatefulWidget {
  const listaTutorias({super.key});

  @override
  State<listaTutorias> createState() => _listaTutoriasState();
}

class _listaTutoriasState extends State<listaTutorias> {
  String id_tutoria = "";
  String id_usuario = "";
  String rol_usuario = "";
  Map argumentosRecividos = new Map();
  String URL="http://10.0.2.2:8000";

  List tutorias=[];

  /*
  @override
  void initState() {
    
    var url = Uri.parse("http://192.168.1.57:8000/misTutorias/");

    http.get(url).then((res) {
      //var datarecived = jsonDecode(res.body);
      //print("Peticion recivida: " + datarecived);
      setState(() {
        this.tutorias=jsonDecode(res.body);
      });
    });

    super.initState();
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Mis Tutorias")),
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
              return ListView.builder(
                        itemCount: tutorias.length,
                        itemBuilder: (BuildContext context, int index){
                        return  InkWell(
                          onTap: () {
                            print("'id_tutoria' : "+tutorias[index]["_id"]['\$oid'].toString());
                            Navigator.pushNamed(context, "/detalleTutoria",
                                    arguments: {'id_tutoria': tutorias[index]["_id"]['\$oid']});
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
                                      Text(tutorias[index]["nombre"].toString(),style: const TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold)),
                                      Text(tutorias[index]["id_profesor"][0]["nombre"].toString()),
                                      Text(tutorias[index]["descripcion"].toString()),
                                      Text(tutorias[index]["calificacion"].toString(),textDirection: TextDirection.ltr,),
                                      
                                      
                                    ],
                                  ),
                                  )
                                ],
                              ),              
                        
                            ),
                          ),
                        );
                      }
                    );
            }

        },
      
      )
    
    );
  }




  Future cargar_informacion() async {
    argumentosRecividos = (ModalRoute.of(context)?.settings.arguments) as Map;
    //this.id_tutoria = argumentosRecividos["id_tutoria"].toString();
    this.id_usuario = argumentosRecividos["id_usuario"].toString();
    this.rol_usuario = argumentosRecividos["rol_usuario"].toString();
    


    var url = Uri.parse(URL+"/getmisTutorias/");

    final res = await http.post(url, body: jsonEncode({"id_usuario": this.id_usuario}));
    var datarecived = jsonDecode(res.body);

    print("nueva forma" + datarecived.toString());
    this.tutorias = jsonDecode(res.body);
    return datarecived;
  }



}