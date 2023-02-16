import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class editarEntrada extends StatefulWidget {
  const editarEntrada({super.key});

  @override
  State<editarEntrada> createState() => _editarEntradaState();
}

class _editarEntradaState extends State<editarEntrada> {
  Map argumentosRecividos = new Map();
  String id_usuario_profesor="";
  String id_tutoria="";
  String id_entrada="";
  String URL="http://10.0.2.2:8000";

  //List entrada = [];

  TextEditingController tituloControlador = new TextEditingController();
  TextEditingController descripcionControlador = new TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Editar Entrada")),
      body: FutureBuilder(
        future: cargar_informacion(),
        builder:(context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } 
            else if (snapshot.connectionState == ConnectionState.none) {
              return const Text("error");
            }
            else{
              return  ListView(
                        children: [
                          Text("Editar Entrada",style: TextStyle(fontSize: 40, color: Colors.black,fontWeight: FontWeight.bold)),
                          SizedBox(height: 30,),
                          Padding(padding: EdgeInsets.only(left: 15),child: Text("Titulo"),),
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: TextField(
                              decoration: InputDecoration(border: OutlineInputBorder(),),
                              controller: tituloControlador,
                              ),              
                          ),
                          Padding(padding: EdgeInsets.only(left: 15),child: Text("Descripción de la entrada"),),
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: TextField(
                              decoration: InputDecoration( border: OutlineInputBorder()),
                              minLines: 5,
                              maxLines: 5,
                              controller: descripcionControlador,
                              ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: MaterialButton(
                              child: Text("Actualizar Entrada"),
                              color: Colors.blueAccent,
                              onPressed: actualizarEntrada,
                            )          
                          )

                        ],
                      );
    
              
            }
        },
        ),
    );
  }


  actualizarEntrada(){
    var url = Uri.parse(URL+"/updateEntrada/");
  //print("titulo="+tituloControlador.text+" desc="+descripcionControlador.text+" prof:"+id_usuario_profesor+" tutoria:"+id_tutoria);
  
    http.post(url, body: jsonEncode(
      {"titulo":tituloControlador.text,
      'id_tutoria':this.id_tutoria,
      "id_entrada":this.id_entrada,
      "descripcion":descripcionControlador.text}
    ))
    .then((value){
      print(value);
    });
  }

   Future cargar_informacion() async {
    argumentosRecividos = (ModalRoute.of(context)?.settings.arguments) as Map;
    this.id_tutoria = argumentosRecividos["id_tutoria"].toString();
    this.id_entrada = argumentosRecividos["id_entrada"].toString();
    this.id_usuario_profesor = argumentosRecividos["id_usuario_profesor"].toString();
    //this.rol_usuario = argumentosRecividos["rol_usuario"].toString();
    
    print("--->" + id_tutoria);

    var url = Uri.parse(URL+"/getEntrada/");

    final res = await http.post(url, body: jsonEncode({"id_entrada": this.id_entrada}));
    var datarecived = jsonDecode(res.body);

    print("nueva forma" + datarecived.toString());
    //this.entrada = jsonDecode(res.body);
    tituloControlador.text=datarecived[0]["titulo"];
    descripcionControlador.text=datarecived[0]["descripcion"];

    return datarecived;
  }





}