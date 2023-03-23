import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';

import '../../utilidades/utilidades.dart';

class crearTutoria extends StatefulWidget {
  const crearTutoria({super.key});

  @override
  State<crearTutoria> createState() => _crearTutoriaState();
}

class _crearTutoriaState extends State<crearTutoria> {
  Map argumentosRecividos = new Map();
  FilePickerResult? archivosSeleccionados;
  String id_usuario="";
  String rol_usuario="";
  //String URL="http://10.0.2.2:8000";
  String URL=SERVER_URL;

  TextEditingController nombre = new TextEditingController();
  TextEditingController descripcion = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    argumentosRecividos = (ModalRoute.of(context)?.settings.arguments) as Map; 
    this.id_usuario = argumentosRecividos["id_usuario"].toString();
    //this.rol_usuario='ESTUDIANTE';
    this.rol_usuario=argumentosRecividos["rol_usuario"].toString();;
    
    print("usuario: "+this.id_usuario);

     return Scaffold(
      appBar: AppBar(title: Text("Crear Tutoría"),),
      body:  ListView(
        children:   [
          Text("Nueva tutoría",style: TextStyle(fontSize: 40, color: Colors.black,fontWeight: FontWeight.bold)),
          SizedBox(height: 30,),
          Padding(padding: EdgeInsets.only(left: 15),child: Text("Nombre de la tutoría"),),
          Padding(
            padding: EdgeInsets.all(15),
            child: TextField(
              decoration: InputDecoration(border: OutlineInputBorder(),),
              controller: nombre,
              ),
          ),
          Padding(padding: EdgeInsets.only(left: 15),child: Text("Descripción de la tutoría"),),
          Padding(
            padding: EdgeInsets.all(15),
            child: TextField(
              decoration: InputDecoration( border: OutlineInputBorder()),
              minLines: 5,
              maxLines: 5,
              controller: descripcion,
              ),
          ),
          
          Padding(
            padding: const EdgeInsets.only(left:15.0,right: 15.0),
            child: MaterialButton(
                    child: Text("Selección Archivo"),
                    color: Colors.blueAccent,
                    onPressed: selecionar_archivos
            ),
          ),
           if(this.rol_usuario!="E") 
           Padding(
            padding: EdgeInsets.only(left:15.0,right: 15.0),
            child: MaterialButton(
              child: Text("Publicar Tutoría"),
              color: Colors.blueAccent,
              onPressed: registrarTutoria,
            )          
          ),
          
        ],
      ),
    );
    
  }

selecionar_archivos() async {
    //this.archivosSeleccionados = await FilePicker.platform.pickFiles(allowMultiple: true);
    this.archivosSeleccionados = await FilePicker.platform.pickFiles(allowMultiple: false);
  }

registrarTutoria() async{
  var url = Uri.parse(URL+"/publicarTutoria/");

  if(nombre.text=="" || nombre.text==null || descripcion=="" || descripcion==null){
        exepcionMessageDialogo(context, "Debe llenar todos los campos");
        return null;
  }


  if (this.archivosSeleccionados != null)  {  //validar que las cajas de texto tampoco sean nulas esto para crear tutoria y pra crear entrada
     
      try{
      List<File> files = this.archivosSeleccionados!.paths.map((path) => File(path.toString())).toList();

      print("--------------");
      for (File file in files) {
        /*print(file.name);
              print(file.bytes);
              print(file.size);
              print(file.extension);*/
        print(file.path);

        var request = http.MultipartRequest('POST', url);
        request.files.add(await http.MultipartFile.fromPath("Myarchivo", file.path.toString()));
        request.fields["nombre"]=nombre.text;
        request.fields["id_profesor"]=id_usuario;
        request.fields["descripcion"]=descripcion.text;
        var res = await request.send()
        .then((response) {
          print(response.toString());
          //if (response.statusCode == 200) {print('Uploaded!');Navigator.pushNamed(context, "/listaTutorias");};
          if (response.statusCode == 200) {print('Uploaded!');Navigator.popAndPushNamed(context, "/listaTutorias");};
        });
      }
      print("--------------");

      //print(res.body);

      //print(res.reasonPharse);
      //return res.reasonPhrase;
      return "0";
      }
      catch(e){
        exepcionMessageDialogo(context, "No se pudo completar la operación");
      }



    } else {
      print("NO HAY NINGUN ARCHIVO SELECCIONADO"); 
      exepcionMessageDialogo(context, "Debe seleccionar una imagen");
    }


  
}

}

