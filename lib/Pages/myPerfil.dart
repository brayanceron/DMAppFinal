import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utilidades/utilidades.dart';

class myPerfil extends StatefulWidget {
  const myPerfil({super.key});

  @override
  State<myPerfil> createState() => _myPerfilState();
}

class _myPerfilState extends State<myPerfil> {
  String URL=SERVER_URL;
  
  final user = FirebaseAuth.instance.currentUser!; 
  var usuarioInfo;
  double coverHeigth=280;
  double profilHeigth=144;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: cargar_informacion(),
        builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } 
              else if (snapshot.connectionState == ConnectionState.none) {
                return const Text("error");
              }
              else if (snapshot.connectionState==ConnectionState.done){
                try{
                return  ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    buildTop(),
                    buildContent(),
                    
                    MaterialButton(
                      child: Text("Cerrar Sesión"),
                      color: Colors.indigo,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      onPressed: () {
                        signOut();
                    },)
                  ],
                );
                }
                catch(e){
                  return const Text("error");
                }
              }
              else{
                exepcionDialogo(context);
                return const Text("error");
                
              }
        },
      ),
     
      bottomNavigationBar: myBottomNavigationBar(email: this.user.email.toString(),opcionActual: 3,)
    );
    
  }

 Future cargar_informacion() async { 
   try{
    await cargar_info_usuario();
   }
   catch(e){
      exepcionDialogo(context,);
   }

  }


  Future cargar_info_usuario() async{
    var url = Uri.parse(URL+"/getInfoUsuario/");
    final res = await http.post(url, body: jsonEncode({"correo": this.user.email}));
    this.usuarioInfo = jsonDecode(res.body);
    print("INFO USUARIO :"+this.usuarioInfo.toString());
    print(this.usuarioInfo[0]["nombre"]);
    print(this.usuarioInfo[0]["rol"]);
    print(this.usuarioInfo[0]["correo"]);
    print(this.usuarioInfo[0]["foto"]["url"]);
    //print("ID:"+this.usuarioInfo[0]["_id"]["\$oid"]); //id del usuario
  }


void signOut() async{
      await FirebaseAuth.instance.signOut();
       //Navigator.pushNamed(context, "/");
       Navigator.pushNamedAndRemoveUntil(context, "/", (Route<dynamic> route) => false);
       
  }


Widget buildContent(){
  return Column(
    children: [
      const SizedBox(height: 8,),
      Text(
        this.usuarioInfo[0]["nombre"].toString(),
        style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8,),
      if(this.usuarioInfo[0]["rol"]=="E") 
      Text("Estudiante",style: TextStyle(fontSize: 20),)
      else if(this.usuarioInfo[0]["rol"]=="P") 
      Text("Profesor",style: TextStyle(fontSize: 20)),
      const SizedBox(height: 16,),
      Text(this.usuarioInfo[0]["correo"].toString()),
      Divider()

    ],
  );
}

Widget buildTop(){
  final top=coverHeigth-profilHeigth/2;
  final bottom=coverHeigth/2;
  return Stack(
    
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: bottom),
          child: buildCoverImage(),
        ),
        Positioned(
          top: top,
          child: buildProfileImage()
          )
      ],
    );
}

Widget buildCoverImage(){
    return Container(
      color: Colors.grey,
      child: Image.network(
        SERVER_URL+"/media/portada.jpg",
        width: double.infinity,
        height: coverHeigth,
        fit: BoxFit.cover,
      ),
    );
  }


Widget buildProfileImage(){
  print("Nok");
  //if(this.usuarioInfo[0]["foto"]["url"]){print("*****EXISTE IMAGEN POR DEFECTO");}
  return CircleAvatar(
    radius: profilHeigth/2,
    backgroundColor: Colors.grey,
    //backgroundImage: NetworkImage(SERVER_URL+this.usuarioInfo[0]["foto"]["url"]),
    backgroundImage: 
    (this.usuarioInfo[0]["foto"]["url_google"]== null)?  NetworkImage(SERVER_URL+this.usuarioInfo[0]["foto"]["url"]):NetworkImage(this.usuarioInfo[0]["foto"]["url_google"])
    
  );
}

}