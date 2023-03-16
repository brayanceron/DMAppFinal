import 'dart:io';

import 'package:appfinal/Pages/catalogoTutorias.dart';
import 'package:appfinal/Pages/listaTutorias.dart';
import 'package:appfinal/Pages/rutas.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import '../utilidades/utilidades.dart';

String URL=SERVER_URL;
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String URL=SERVER_URL;
  Map argumentosRecividos = new Map();
  FilePickerResult? archivosSeleccionados;

  List body = const [
      catalogoTutorias(),
      listaTutorias(),//Icon(Icons.person),
      Rutas()
    ];
  int opcionActual=0;



  @override
  Widget build(BuildContext context) {
    this.argumentosRecividos = (ModalRoute.of(context)?.settings.arguments) as Map;
    

    return Scaffold(
        //appBar: AppBar(title: Text("Page Home"),),
        body:HomePage(),
        bottomNavigationBar: barraNavegacion()
        );
  }

  subir_archivos()async{
    var URL = Uri.parse(SERVER_URL+'/subirArchivotest/');
    if (this.archivosSeleccionados != null)  {
      //PlatformFile file = result.files.first;
      List<File> files = this.archivosSeleccionados!.paths.map((path) => File(path.toString())).toList();

      print("--------------");
      for (File file in files) {
        /*print(file.name);
              print(file.bytes);
              print(file.size);
              print(file.extension);*/
        print(file.path);

        var request = http.MultipartRequest('POST', URL);
        request.files.add(await http.MultipartFile.fromPath(
            "Myarchivo", file.path.toString()));
        var res = await request.send().then((response) {
          print(response.toString());
          if (response.statusCode == 200) print('Uploaded!');
          /*
                http.Response.fromStream(response).then((onValue){
                  print(response.statusCode);                             
                });
                */
        });
      }
      print("--------------");

      //print(res.body);

      //print(res.reasonPharse);
      //return res.reasonPhrase;
      return "0";
    } else {
      print("NO HAY NINGUN ARCHIVO SELECCIONADO"); 
    }
  }
  selecionar_archivos() async {
    this.archivosSeleccionados = await FilePicker.platform.pickFiles(allowMultiple: true);
    

    
  }

  Widget barraNavegacion() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            child: BottomNavigationBar(
                currentIndex: opcionActual,
                onTap: (nuevaOpcion) {
                  setState(() {
                    this.opcionActual = nuevaOpcion;
                    opcionActual=nuevaOpcion;
                    print(this.opcionActual);
                    //print(this.opcionActual.runtimeType);
                    //body=body[opcionActual];

                  });
                },
                items: const [
                  BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
                  BottomNavigationBarItem(label: "Profile", icon: Icon(Icons.person)),
                  BottomNavigationBarItem(label: "Menu", icon: Icon(Icons.menu)),
                ]),
          )),
    );
  }

  Widget HomePage(){
     return RefreshIndicator(
          onRefresh: () async {},
          child: ListView(
            children: [
              Text("ok"),
              Text("Imagen"),
              SizedBox(
                width: 100,
                height: 100,
                child: Image.network(
                URL+'/media/f6a8942f-4e20-4dd6-b675-15f93872aba4software-de-codificación-mujer-programadora-desarrolladora-programador-desarrollador-en-computadora-231060005.jpg'
                ),
              ),
              
              MaterialButton(
                  child: Text("Seleccion Archivo"),
                  color: Colors.blueAccent,
                  onPressed: selecionar_archivos),
              MaterialButton(
                  child: Text("Subir Archivo"),
                  color: Colors.blueAccent,
                  onPressed: subir_archivos),
              //Image.network('http://192.168.1.57:8000/media/Screenshot_20230218-013239_D8S4Wda.png'),
            ],
          ),
        );
       
  }


}
