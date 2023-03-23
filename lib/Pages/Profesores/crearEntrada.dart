import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../../utilidades/utilidades.dart';


class crearEntrada extends StatefulWidget {
  const crearEntrada({super.key});

  @override
  State<crearEntrada> createState() => _crearEntradaState();
}

class _crearEntradaState extends State<crearEntrada> {
  //String URL="http://10.0.2.2:8000";
  String URL=SERVER_URL;
  
  Map argumentosRecividos = new Map();
  FilePickerResult? archivosSeleccionados;
  final user = FirebaseAuth.instance.currentUser!; 
  var usuarioInfo;

  String id_usuario_profesor="";
  String rol_usuario="";
  String id_tutoria="";
  

  TextEditingController tituloControlador = new TextEditingController();
  TextEditingController descripcionControlador = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(title: Text("Crear Entrada")),
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
                      Text("Nueva Entrada",style: TextStyle(fontSize: 40, color: Colors.black,fontWeight: FontWeight.bold) ,textAlign: TextAlign.center,),
                      SizedBox(height: 30,),
                      Padding(padding: EdgeInsets.only(left: 15),child: Text("Título"),),
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
                        padding: const EdgeInsets.only(left:15.0, right: 15.0),
                        child: MaterialButton(
                          child: Text("Seleccionar Archivos"),
                          color: Colors.blueAccent,
                          onPressed: selecionar_archivos
                          ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left:15.0, right: 15.0),
                        child: MaterialButton(
                          child: Text("Publicar Entrada"),
                          color: Colors.blueAccent,
                          onPressed: registrarEntrada,
                        )          
                      )

                    ],
                  );
              }
        },
        )
      
      
    );
  }

Future cargar_informacion() async{
    await cargar_info_usuario();
    argumentosRecividos = (ModalRoute.of(context)?.settings.arguments) as Map; 
    //this.id_usuario_profesor = argumentosRecividos["id_usuario_profesor"].toString();
    this.id_tutoria = argumentosRecividos["id_tutoria"].toString();

    this.rol_usuario = this.usuarioInfo[0]["rol"];
    this.id_usuario_profesor = this.usuarioInfo[0]["_id"]["\$oid"];
    
    print("El usuario: "+this.id_usuario_profesor+"/"+this.usuarioInfo[0]["nombre"] +" agregara una entrada a la tutoria "+this.id_tutoria);
}

Future cargar_info_usuario() async{
    var url = Uri.parse(URL+"/getInfoUsuario/");
    final res = await http.post(url, body: jsonEncode({"correo": this.user.email}));
    this.usuarioInfo = jsonDecode(res.body);
    print("ROL:"+this.usuarioInfo[0]["rol"]);

  }

registrarEntrada() async {
  /*if(this.rol_usuario!='E'){*/
   var url = Uri.parse(URL+"/registrarEntrada/");
      //print("titulo="+tituloControlador.text+" desc="+descripcionControlador.text+" prof:"+id_usuario_profesor+" tutoria:"+id_tutoria);
  

      /*
      http.post(url, body: jsonEncode({"titulo":tituloControlador.text,'id_tutoria':id_tutoria,
      "id_profesor":id_usuario_profesor,"descripcion":descripcionControlador.text}))
      .then((value){
        print(value);
        Navigator.pushNamed(context, "/panelTutoria",arguments: {'id_tutoria':this.id_tutoria});
      });*/



  /*}
  else{
    print("Este Rol no puede agregar una entrada");
  }*/
     //validar que las cajas de texto tampoco sean nulas esto para crear tutoria y pra crear entrada
      if(tituloControlador.text=="" || tituloControlador.text==null || descripcionControlador=="" || descripcionControlador==null){
        exepcionMessageDialogo(context, "Debe llenar todos los campos");
        return null;
      }

      print("--------------");
      
      try{
      var request = http.MultipartRequest('POST', url);
        
      request.fields["titulo"]=tituloControlador.text;
      request.fields["id_tutoria"]=id_tutoria;
      request.fields["id_profesor"]=id_usuario_profesor;
      request.fields["descripcion"]=descripcionControlador.text;
      request.fields["current_user_id"]=this.id_usuario_profesor;

      

      
      int a=0;
      if (this.archivosSeleccionados != null)  { 
      List<File> files = this.archivosSeleccionados!.paths.map((path) => File(path.toString())).toList();
      for (File file in files) {
        /*print(file.name);
              print(file.bytes);
              print(file.size);
              print(file.extension);*/
        print(file.path);
        request.files.add(await http.MultipartFile.fromPath("Myarchivo"+a.toString(), file.path.toString()));
        a++;        
      }
      }
      var res = await request.send()
        .then((response) {
          print(response.toString());
          //if (response.statusCode == 200) {print('Uploaded!');Navigator.popAndPushNamed(context, "/panelTutoria",arguments: {'id_tutoria':this.id_tutoria});};
          if (response.statusCode == 200) {print('Uploaded!');Navigator.popAndPushNamed(context, "/panelTutoria",arguments: {'id_tutoria':this.id_tutoria});};
        });

      print("--------------");
      return "0";
      }
      catch(e){
        exepcionMessageDialogo(context, "No se pudo completar la operación");
      }

  
  
}

registrarEntrada2(){
  /*if(this.rol_usuario!='E'){*/
      var url = Uri.parse(URL+"/registrarEntrada/");
      //print("titulo="+tituloControlador.text+" desc="+descripcionControlador.text+" prof:"+id_usuario_profesor+" tutoria:"+id_tutoria);
  
      http.post(url, body: jsonEncode({"titulo":tituloControlador.text,'id_tutoria':id_tutoria,
      "id_profesor":id_usuario_profesor,"descripcion":descripcionControlador.text}))
      .then((value){
        print(value);
        Navigator.pushNamed(context, "/panelTutoria",arguments: {'id_tutoria':this.id_tutoria});
      });
  /*}
  else{
    print("Este Rol no puede agregar una entrada");
  }*/
  
  
}

selecionar_archivos() async {
    //this.archivosSeleccionados = await FilePicker.platform.pickFiles(allowMultiple: true);
    this.archivosSeleccionados = await FilePicker.platform.pickFiles(allowMultiple: true);
  }


}