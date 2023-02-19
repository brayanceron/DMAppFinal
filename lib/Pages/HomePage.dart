import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Map argumentosRecividos= new Map();


  @override
  Widget build(BuildContext context) {
    argumentosRecividos = (ModalRoute.of(context)?.settings.arguments) as Map;
    print(argumentosRecividos);

    return Scaffold(
      appBar: AppBar(title: Text("Page Home"),),
      body: ListView(
        children: [
          Text("ok"),
          MaterialButton(
            child: Text("Seleccion Archivo"),
            color: Colors.blueAccent,
            onPressed: selecionar_archivo
            ),
          //Image.network('http://192.168.1.57:8000/media/Screenshot_20230218-013239_D8S4Wda.png'),
        ],
      ),
      
    );
  }

   selecionar_archivo() async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
        var URL = Uri.parse('http://192.168.1.57:8000/subirArchivotest/');

        if(result != null) {
          //PlatformFile file = result.files.first;
          List<File> files = result.paths.map((path) => File(path.toString())).toList();
          
          print("--------------");
          for (File file in files){
              /*print(file.name);
              print(file.bytes);
              print(file.size);
              print(file.extension);*/
              print(file.path); 

    
              
              var request = http.MultipartRequest('POST', URL);
              request.files.add(await http.MultipartFile.fromPath("Myarchivo", file.path.toString()));
              var res = await request.send()
              .then((response){                

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
          // Usuario cancela carga
        }
  }





}