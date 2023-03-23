
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//String SERVER_URL="http://10.0.2.2:8000";
//String SERVER_URL="http://192.168.1.57:8000/api";
//String SERVER_URL="http://172.16.8.4:8000/api";
String SERVER_URL="http://129.213.171.120:8000/api";
String MENSAJE_EXEPTION= "Ocurrio un error, vuelva a intentarlo";

class myBottomNavigationBar extends StatefulWidget {
  myBottomNavigationBar({super.key,required String this.email,required int this.opcionActual});
  String email="";
  int opcionActual=0;

  @override
  State<myBottomNavigationBar> createState() => _myBottomNavigationBarState(email: this.email,opcionActual: this.opcionActual);
}

class _myBottomNavigationBarState extends State<myBottomNavigationBar> {
  _myBottomNavigationBarState({required String this.email,required int this.opcionActual});
  String email="";
  String rol="";
  int opcionActual=0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
    future: cargar_rol_usuario(this.email),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
      } 
      else if (snapshot.connectionState == ConnectionState.none) {
        return const Text("error");
      }
      else{
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
                      unselectedItemColor:Colors.black,
                      selectedItemColor: Colors.red.shade700,
                      selectedIconTheme: const IconThemeData(color: Colors.red),
                      showUnselectedLabels: true,

                      currentIndex: this.opcionActual,
                      onTap: (nuevaOpcion) {
                          print(nuevaOpcion);
                        //
                          //print(body[opcionActual]);
                          try{
                          if(nuevaOpcion==0){Navigator.pushNamed(context, "/catalogoTutorias");}
                          if(nuevaOpcion==1){Navigator.pushNamed(context, "/listaTutorias");}
                          if(nuevaOpcion==2){
                            if(rol=="E"){
                              Navigator.pushNamed(context, "/solicitudesEstudiante");
                            }
                            else if(rol=="P")
                              Navigator.pushNamed(context, "/solicitudesProfesor");
                            }
                            else if(rol=="A"){
                              Navigator.pushNamed(context, "/solicitudesProfesor");
                            }
                          if(nuevaOpcion==3){Navigator.pushNamed(context, "/myPerfil");}
                          //if(nuevaOpcion==4){Navigator.pushNamed(context, "/myPerfil");}
                          }catch(e){exepcionDialogo(context);}
                          //Navigator.pushNamed(context, "/myPerfil",
                          //}
                          //Navigator.pushNamed(context, body[opcionActual],arguments: {'nombre': 'Bra Vegueta', 'age': 25});
                        
                      },
                      items:  [
                        const BottomNavigationBarItem(label: "Buscar",  icon: Icon(Icons.grid_view_rounded,color:Colors.black)),
                        //if(rol=="E")const BottomNavigationBarItem(label: "Aprender",      icon: Icon(Icons.lightbulb_circle,color:Colors.black),),
                        //if(rol=="P")const BottomNavigationBarItem(label: "Enseñar",      icon: Icon(Icons.lightbulb_circle,color:Colors.black),),
                        //if(rol=="A")const BottomNavigationBarItem(label: "Ver",      icon: Icon(Icons.lightbulb_circle,color:Colors.black),),
                        const BottomNavigationBarItem(label: "Tutorías",      icon: Icon(Icons.lightbulb_circle,color:Colors.black),),
                        const BottomNavigationBarItem(label: "Solicitudes",      icon: Icon(Icons.notifications_active_sharp,color:Colors.black)),
                        const BottomNavigationBarItem(label: "Perfil",    icon: Icon(Icons.account_circle_outlined ,color:Colors.black)),
                        //const BottomNavigationBarItem(label: "Perfil",    icon: Icon(Icons.account_circle_outlined ,color:Colors.black)),
                      ]),
                )),
          );
  
      }
      
    },
   );

  }




  Future cargar_rol_usuario(email) async{
    try{
      String URL=SERVER_URL;
      var url = Uri.parse(URL+"/getInfoUsuario/");
      final res = await http.post(url, body: jsonEncode({"correo":email}));
      var usuarioInfo = jsonDecode(res.body);
      this.rol= usuarioInfo[0]["rol"].toString();
    }
    catch(e){
      exepcionDialogo(context);
    }
    
  }
}


Widget barraBusqueda(){
  return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextField(
                                decoration:  InputDecoration(  
                                  contentPadding: EdgeInsets.symmetric(vertical: 15.0),                         
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide(width: 0.8)
                                  ),
                                  hintText: "Buscar tutoría",                            
                                  prefixIcon: Icon(Icons.search, size: 30,),
                                  suffixIcon: IconButton(icon: Icon(Icons.clear),
                                  onPressed: (() {
                                    
                                  })
                                ),
                              ),
                        ));
}


void exepcionDialogo(BuildContext context){
  showDialog(context: context, 
  builder: ((context) {
    return AlertDialog(
        title: Text("Error"),
        content: Text("Ocurrio un error, vuelva a intentarlo"),
        actions: [
          
          MaterialButton(
            child: Text("Cerrar",),
            color: Colors.grey,
            onPressed: (){Navigator.pop(context);},
            )
        ],
    );
  }));
}

void exepcionMessageDialogo(BuildContext context,String mensaje){
  showDialog(context: context, 
  builder: ((context) {
    return AlertDialog(
        title: Text("Error"),
        content: Text(mensaje),
        actions: [
          
          MaterialButton(
            child: Text("Cerrar",),
            color: Colors.grey,
            onPressed: (){Navigator.pop(context);},
            )
        ],
    );
  }));
}




