import 'dart:io';import 'dart:async';

import 'package:appfinal/Pages/catalogoTutorias.dart';
import 'package:appfinal/Pages/listaTutorias.dart';
import 'package:appfinal/Pages/rutas.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
//import 'package:video_player/video_player.dart';

import '../utilidades/utilidades.dart';
import 'package:newsfeed_multiple_imageview/newsfeed_multiple_imageview.dart';

import 'package:flutter_file_downloader/flutter_file_downloader.dart';






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

  //VideoPlayerController? controladorDevideo;
  
  @override
  void initState() {
    // TODO: implement initState
    /*controladorDevideo=VideoPlayerController.network("http://192.168.1.57:8000/api/media/792ef159-4abc-4fe6-8fed-a1a53c2e9c5eVID-20230313-WA0003.mp4/")
    ..initialize()
    .then((_){
        setState(() {
          
        });
    });*/
    super.initState();
           
            //_imageUrls.add("http://192.168.1.57:8000/api/media/792ef159-4abc-4fe6-8fed-a1a53c2e9c5eVID-20230313-WA0003.mp4");
  }


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
     List<String> _imageUrls = [];
            _imageUrls.add("https://media.istockphoto.com/photos/colorful-sunset-at-davis-lake-picture-id1184692500?k=20&m=1184692500&s=612x612&w=0&h=7noTRS8UjiAVKU92eIhPG17PIWVh-kCmH5jKX5GOcdQ=");
            _imageUrls.add("https://images.unsplash.com/photo-1573155993874-d5d48af862ba?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8cGFya3xlbnwwfHwwfHw%3D&w=1000&q=80");
            _imageUrls.add("https://images.pexels.com/photos/158028/bellingrath-gardens-alabama-landscape-scenic-158028.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500");
            _imageUrls.add("https://images.pexels.com/photos/158028/bellingrath-gardens-alabama-landscape-scenic-158028.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500");
            _imageUrls.add("https://images.pexels.com/photos/158028/bellingrath-gardens-alabama-landscape-scenic-158028.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500");

            _imageUrls.add("https://img.lalr.co/cms/2022/09/08070553/Lamborghini-Urus-Performante.jpg?size=xl");
            //_imageUrls.add("http://udenar.ml:8000/api/media/e882f446-0d31-4871-8169-f44a677ddcb4IA.png");
            
            //_imageUrls.add("http://192.168.1.57:8000/api/media/66b72221-1872-4e14-b6c1-77d8cbc1142bFB_IMG_1679192487662.jpg".toString());
            //_imageUrls.add("http://192.168.1.57:8000/api/media/936d2020-f845-4f52-bfb6-330c03cb3babFB_IMG_1679160300842.jpg".toString());
           
            
             
    double? _progres;
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
              MaterialButton(
                child: Text("Descargar"),
                onPressed: () {
                  FileDownloader.downloadFile(
                    url: "http://192.168.1.57:8000/api/media/3293b7f7-d8c4-4d72-8b00-b29be68b12d7FB_IMG_1678854392609.jpg",
                    onProgress: (fileName, progress) {
                      setState(() {
                        _progres=progress;
                      });
                    },
                    onDownloadCompleted: (path) {
                      print("path: "+path);
                      setState(() {
                        _progres=null;
                      });
                    },
                    onDownloadError: (errorMessage) {
                      print("***************");
                      print(errorMessage);
                    },
                    );
                      
                  
                },
              ),
              Text("Videos"),
              NewsfeedMultipleImageView(//imageUrls: ["https://img.lalr.co/cms/2022/09/08070553/Lamborghini-Urus-Performante.jpg?size=xl",URL+'/media/f6a8942f-4e20-4dd6-b675-15f93872aba4software-de-codificación-mujer-programadora-desarrolladora-programador-desarrollador-en-computadora-231060005.jpg/'],
              imageUrls: _imageUrls,
              marginLeft: 10.0,
              marginRight: 10.0,
              marginBottom: 10.0,
              marginTop: 10.0,
            )
              //this.controladorDevideo!.value.isInitialized? VideoPlayer(this.controladorDevideo!) :Text("video no cargado"),
              //VideoPlayer(video()),
            ],
          
          ),
        );
       
  }


 

}
