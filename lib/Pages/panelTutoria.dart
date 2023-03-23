import 'package:appfinal/Pages/rutas.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:newsfeed_multiple_imageview/newsfeed_multiple_imageview.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

import '../utilidades/utilidades.dart';
import 'catalogoTutorias.dart';
import 'listaTutorias.dart';


class panelTutoria extends StatefulWidget {
  const panelTutoria({super.key});

  @override
  State<panelTutoria> createState() => _panelTutoriaState();
}

class _panelTutoriaState extends State<panelTutoria> {
  //String URL="http://10.0.2.2:8000";
  String URL=SERVER_URL;

  final user = FirebaseAuth.instance.currentUser!; 
  var usuarioInfo;
  Map argumentosRecividos = new Map();

  String id_tutoria = "";
  String id_usuario = "";
  String rol_usuario = "";

  double estrellasTutor=0;
  double estrellasTutoria=0;

  List tutoria=[];
  List infotutoria=[];
  

  List formatoImagenesAceptada=["png","jpg","jpeg","bmp","gif","tif"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: 
      AppBar(title:  const Text("Panel principal tutoría "),),

      body: FutureBuilder(
          future: cargar_informacion(),
          builder: (context, snapshot) {
              if(snapshot.data==null){
                if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
                } 
                else if (snapshot.connectionState == ConnectionState.none) {
                  return Center(child: const Text("Error de conexión, intentelo nuevamente"));
                }
                else{
                  return Center(child: const Text("Error de conexión, intentelo nuevamente"));
                }
              }
              else{
                try{
                  return ListView(
                          children: [
                            //Text(tutoria[0]["nombre"].toString(),style:  const TextStyle(fontSize: 40,color: Colors.black,fontWeight: FontWeight.bold)),
                            //Text(tutoria[0]["id_tutoria"][0]["nombre"].toString(),style:  const TextStyle(fontSize: 40,color: Colors.black,fontWeight: FontWeight.bold)),
                            Text(infotutoria[0]["nombre"].toString(),style:  const TextStyle(fontSize: 30,color: Colors.black,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                            Row(
                              children: [
                                Text("Compartir:  "+infotutoria[0]["_id"]["\$oid"].toString()),
                                IconButton(
                                  icon: Icon(Icons.copy),
                                  onPressed: (() {
                                    Clipboard.setData(ClipboardData(text: infotutoria[0]["_id"]["\$oid"]..toString()));
                                })),
                              ],
                            ),
                            if(this.infotutoria[0]["estado"].toString()!="FINALIZADA" ) 
                            Row(
                              children: [
                                IconButton(alignment: Alignment.bottomLeft,
                                    icon: const Icon(Icons.people_alt,size: 30,color: Colors.blueAccent),
                                    onPressed: () {
                                      Navigator.pushNamed(context, "/detalleTutoria", 
                                      arguments: {'id_tutoria': id_tutoria,'id_usuario':id_usuario,'rol_usuario':rol_usuario});
                                    },
                                ),
                            
                                IconButton(alignment: Alignment.bottomLeft,
                                    icon: Icon(Icons.fiber_new,size: 30,color: Colors.redAccent),
                                    onPressed: () {
                                      print("ok");
                                      Navigator.pushNamed(context, "/crearEntrada",
                                        arguments: {'id_usuario_profesor':'63e9b98e811ef54a3de59514','id_tutoria':id_tutoria});
                                    },
                                ),
                                if(this.rol_usuario=="E")
                                MaterialButton(
                                    color: Colors.redAccent,
                                    child: Text("Finalizar la tutoria"),
                                    onPressed: () { dialogoCalificar(context);}
                                )

                              ],
                            ),
                            SizedBox(height: 20,),

                            
                            const Text("Entradas: "),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: (tutoria).length,
                              itemBuilder: (context, int index) {
                                return  InkWell(
                                  onTap: () {
                                    //print("id_tutoria' : "+this.id_tutoria+",  'id_entrada':"+tutoria[0]["entradas"][index]["_id"]["\$oid"].toString()+" id_usuario"+id_usuario+" rol:"+rol_usuario);
                                    //Desde aqui hay qllamar a verEntrada y mandarle los parmetros necesarios
                                    Navigator.pushNamed(context, "/getEntrada",
                                      //arguments: {'id_tutoria':id_tutoria,'id_entrada':tutoria[0]["entradas"][index]["_id"]["\$oid"],
                                      arguments: {'id_tutoria':id_tutoria,'id_entrada':tutoria[index]["_id"]["\$oid"]});
                                    
                                  },
                                  child: Card(
                                          elevation: 5,
                                              //margin: const EdgeInsets.all(20),
                                              /*child: SizedBox(
                                                  child: Column(
                                                  children: [
                                                    Text(tutoria[index]["titulo"].toString(),style: const TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),                      
                                                    Row(
                                                      children: [
                                                        const Icon(Icons.account_circle_rounded,size: 30,color: Colors.blueAccent,),
                                                        Text(tutoria[index]["id_profesor"][0]["nombre"]),   
                                                      ],
                                                    ),
                                                    
                                                    const SizedBox(height: 10,),
                                                    Text(tutoria[index]["descripcion"]),
                                                    //Text(tutoria[index]["archivos"].toString()),
                                                    //====================================================================================================
                                                    //if(tutoria[index]["archivos"].length>0 && existeMultimedia(tutoria[index]["archivos"]))
                                                    //mosaico(tutoria[index]["archivos"]),
                                                    //====================================================================================================
                                                    if(tutoria[index]["archivos"].length>0 && existeMultimedia(tutoria[index]["archivos"]))
                                                     GridView.builder(
                                                      shrinkWrap: true,
                                                      physics: NeverScrollableScrollPhysics(),
                                                      scrollDirection: Axis.vertical,
                                                      //itemCount: tutoria[index]["archivos"].length,
                                                      itemCount: ImagenesMostrar(tutoria[index]["archivos"]).length,
                                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: calcularFilasImagenes(ImagenesMostrar(tutoria[index]["archivos"]).length)),
                                                      itemBuilder: (context, index2) {
                                                          List imagenesEncontradas=ImagenesMostrar(tutoria[index]["archivos"]);
                                                          return  //Text("ok");
                                                          
                                                          CircleAvatar(
                                                            radius: 155,
                                                            
                                                            backgroundColor: Colors.blue,
                                                            backgroundImage: NetworkImage(URL+imagenesEncontradas[index2]["url"].toString()),
                                                            
                                                          );
                                                          //Image.network(URL+imagenesEncontradas[index2]["url"].toString());
                                                          //return Text("archivo ext: "+tutoria[index]["archivos"][index2]["extension"].toString());
                                                          /*if(this.formatoImagenesAceptada.contains(imagenesEncontradas[index2]["extension"].toString())){
                                                               //return Image.network(URL+tutoria[index]["archivos"][index2]["url"].toString());
                                                               return Image.network(URL+imagenesEncontradas[index2]["url"].toString());
                                                          }
                                                          else{
                                                            //return SizedBox(height: 0, width: 0,);
                                                            return Icon(Icons.file_open);
                                                          }*/
                                                      },

                                                      ),
                                                      //===============================================================

                                                    Padding(
                                                      padding: const EdgeInsets.only(bottom: 10,top: 15,left: 2,right: 4),
                                                      child: Row(
                                                      children: [
                                                        Expanded(child: Text(tutoria[index]["fecha_creacion"],style: TextStyle(fontSize: 10,color: Colors.black))),
                                                        Expanded(
                                                          child: Align(
                                                            alignment: Alignment.centerRight,
                                                            child: Text("Archivos: "+tutoria[index]["archivos"].length.toString(),style:  TextStyle(fontSize: 10,color: Colors.black)),
                                                          ),
                                                          )
                                                      ],
                                                    ),
                                                    )
                                                                                                                
                                                  ],
                                                ),              
                                
                                                
                                              ),
                                        */
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              children: <Widget>[
                                                ListTile(
                                                  leading: CircleAvatar(
                                                    radius: 20.0,
                                                    backgroundColor: Colors.blue,
                                                    backgroundImage: NetworkImage(URL+tutoria[index]["id_profesor"][0]["foto"]["url"]),
                                                  ),
                                                  title: Text(tutoria[index]["id_profesor"][0]["nombre"],style: TextStyle(fontWeight: FontWeight.bold),),
                                                  subtitle:Row(children: [ Text(tutoria[index]["fecha_creacion"]),Icon(Icons.timelapse)],),
                                                  trailing: Icon(Icons.more_horiz),
                                                  contentPadding: EdgeInsets.all(0.0),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  child: Text(tutoria[index]["descripcion"].toString()),
                                                ),
                                                SizedBox(height: 6,),
                                                if(tutoria[index]["archivos"].length>0 && existeMultimedia(tutoria[index]["archivos"]))
                                                Container(
                                                  width: double.infinity,                                                  
                                                  height: 300,
                                                  //child: Image.network("https://images.pexels.com/photos/158028/bellingrath-gardens-alabama-landscape-scenic-158028.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                                                  
                                                  
                                                  
                                                  child: Swiper(
                                                    itemBuilder: (BuildContext context,int index3){
                                                      List mylist=ImagenesUrlMostrar(tutoria[index]["archivos"]);
                                                      print("****LOCO*****"+mylist.toString());
                                                      //return new Image.network("http://192.168.1.57:8000/api/media/2e33a8bd-d7e4-46a0-9371-b1ac37390455IBSJ-_-ML.jpg",fit: BoxFit.fill,);
                                                      return new Image.network(SERVER_URL+mylist[index3].toString(),fit: BoxFit.fill,);
                                                    },
                                                    itemCount: ImagenesUrlMostrar(tutoria[index]["archivos"]).length,
                                                    pagination: new SwiperPagination(),
                                                    //control: new SwiperControl(),
                                                  )


                                                ),
                                                /*Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  child: Text("www.udenar.ml"),
                                                ),*/
                                                Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  child: Text("Title: "+tutoria[index]["titulo"].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                                                ),
                                                Container(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      /*Row(
                                                        
                                                        children: <Widget>[
                                                          Icon(Icons.thumb_up,size: 16.0,color: Colors.blue),
                                                          Icon(Icons.tag_faces,size: 16.0,color: Colors.blue),
                                                          Icon(Icons.thumb_down,size: 16.0,color: Colors.blue),
                                                          SizedBox(width: 5.0),
                                                          Text("11111")
                                                      ],
                                                      ),*/
                                                      Row(
                                                        children: <Widget>[
                                                          Text("Archivos: "+tutoria[index]["archivos"].length.toString()),
                                                          SizedBox(width: 10.0,),
                                                          //Text("0 shared"),
                                                          Text(" Comments: 0"),
                                                        ],
                                                      ),
                                                      Divider(),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                );

                              },
                            ),
                                             
                            
                            
                          ],
                        );
                }
                catch(e){
                  exepcionDialogo(context);
                  return const Text("error");
                }
              }
            
          },
        ),
      bottomNavigationBar: myBottomNavigationBar(email: this.user.email.toString(),opcionActual: 1,)
    );
  }



  Future cargar_informacion() async {

    try{
      argumentosRecividos = (ModalRoute.of(context)?.settings.arguments) as Map;
      await cargar_info_usuario();

      this.id_tutoria = argumentosRecividos["id_tutoria"].toString();
      this.id_usuario = this.usuarioInfo[0]["_id"]["\$oid"] ;
      this.rol_usuario = this.usuarioInfo[0]["rol"];
      
      print("ooooo--->" + id_tutoria);



      //Obteniendo las entradas de la tutoria
      var url = Uri.parse(URL+"/getContenidoTutoria/");

      final res = await http.post(url, body: jsonEncode({"id_tutoria": this.id_tutoria,"current_user_id":this.id_usuario}));
      var datarecived = jsonDecode(res.body);

      print("Entradas tutoria" + datarecived.toString());
      this.tutoria = jsonDecode(res.body);
      //return datarecived;
      //Obteniendo la informacion de la tutoria---------------------
      var url2 = Uri.parse(URL+"/getTutoria/");

      final res2 = await http.post(url2, body: jsonEncode({"id_tutoria": this.id_tutoria}));
      var datarecived2 = jsonDecode(res2.body);

      print("nueva forma" + datarecived2.toString());
      this.infotutoria = jsonDecode(res2.body);
      return datarecived2;
    }
    catch(e){
      exepcionDialogo(context);
      return null;
    }
  }

  Future cargar_info_usuario() async{
    var url = Uri.parse(URL+"/getInfoUsuario/");
    final res = await http.post(url, body: jsonEncode({"correo": this.user.email}));
    this.usuarioInfo = jsonDecode(res.body);
    print("ROL:"+this.usuarioInfo[0]["rol"]);

  }



int calcularFilasImagenes(int numimg){
  return 6;
  if (numimg==1){ return 1;}
  if (numimg==2){ return 2;}
  if (numimg==3){ return 3;}
  if (numimg==4){ return 2;}
  if (numimg>=5 && numimg<=9){ return 3;}
  else{ return 15;}
  //return 2;
}

bool existeMultimedia(var archivos){
  for (var arc in archivos){
    if(formatoImagenesAceptada.contains(arc["extension"].toString())){return true;}
    print("Archivo: "+arc["extension"].toString());
  }
  
  return false;
}

List ImagenesMostrar(var archivos){
  List imagenesEncontradas=[];
  if(existeMultimedia(archivos)){
    for (var arc in archivos){
      if(formatoImagenesAceptada.contains(arc["extension"].toString())){
        imagenesEncontradas.add(arc);
        }
    
  }

  }
  
  print("**IMAGENES PARA MOSTRAR*** "+imagenesEncontradas.toString());
  
  return imagenesEncontradas;
}

List ImagenesUrlMostrar(var archivos) {
  List imagenesEncontradas=[];
  if(existeMultimedia(archivos)){
    for (var arc in archivos){
      if(formatoImagenesAceptada.contains(arc["extension"].toString())){
         imagenesEncontradas.add(arc["url"]);
        }
    
  }

  }
  
  print("**###URLS IMAGENES PARA MOSTRAR*** "+imagenesEncontradas.toString());
  
  return imagenesEncontradas;
}
Widget mosaico(var archivos) {
  List imagenesUrlEncontradas= ImagenesUrlMostrar(archivos);
   List<String> _imageUrls = [];
  for(var url in imagenesUrlEncontradas){
      print("una url "+SERVER_URL+url);
       _imageUrls.add(SERVER_URL+url);
  }
           
  return  //Text("ok");
    NewsfeedMultipleImageView(
      imageUrls: _imageUrls,
       marginLeft: 10.0,
       marginRight: 10.0,
         marginBottom: 10.0,
          marginTop: 10.0,
      );
}


void dialogoCalificar(BuildContext context){
  showDialog(context: context, 
    builder: (context) {
      return  SimpleDialog(
        title:  Text("Finalizar Tutoría"),
        children: [
          Padding(padding: const EdgeInsets.all(8.0),
          child:  Text("Valora el desempeño de tu tutor: "),
          ),          
          Padding(padding: const EdgeInsets.only(top: 0,right: 8,left: 8,bottom: 10),
          child: calificarTutor(context),),
          Padding(padding: const EdgeInsets.all(8.0),
          child:  Text("Valora el desempeño de la tutoría: "),
          ),          
          Padding(padding: const EdgeInsets.only(top: 0,right: 8,left: 8,bottom: 10),
          child: calificarTutoria(context),),

          Padding(padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
            color: Colors.red,
            child: Text("Finalizar"),
            onPressed: (){
              print("Tutor: "+this.estrellasTutor.toString()+" Tutoria: "+this.estrellasTutoria.toString());
              btnFinalizarTutoria();
              }),
          )
          
        ],
      );
    });
}

Widget calificarTutor(context){
  return RatingBar.builder(
    itemCount: 5,
    initialRating: 1,
    itemSize: 25,
    itemBuilder: (context, _) {
      return Icon(Icons.star,color: Colors.amber,);
    }, 
    onRatingUpdate:(value) {
      print("EstrellaTutor: "+value.toString());
      this.estrellasTutor=value.toDouble();
    },);
}
Widget calificarTutoria(context){
  return RatingBar.builder(
    itemCount: 5,
    initialRating: 1,
    itemSize: 25,
    itemBuilder: (context, _) {
      return Icon(Icons.star,color: Colors.amber,);
    }, 
    onRatingUpdate:(value) {
      print("EstrellaTutoria: "+value.toString());
      
      this.estrellasTutoria=value.toDouble();
    
    },);
}




void btnFinalizarTutoria() async {
  id_tutoria= infotutoria[0]["_id"]["\$oid"];

  print("**************");
  print(this.infotutoria[0]["estado"].toString());
  //print(id_tutoria);
  //print("ID:"+this.id_usuario.toString());

  var url = Uri.parse(URL+"/finalizarTutoria/");
      final res = await http.post(url, body: jsonEncode({
        "id_tutoria": id_tutoria, 
        "id_usuario":this.id_usuario.toString(),
        "estrellasTutor":this.estrellasTutor.toDouble(),
        "estrellasTutoria":this.estrellasTutoria.toDouble(),
        }));
      
      if(res.statusCode==403){
        print("No tienes permisos para realizar esta acción");
      }
      else if(res.statusCode==500){
        print("Ha ocurrido un error interno en el servidor");
      }
      else{ 
        print("Accion borrar notificacion realizada exitosamente");
        //recargar();
      }
      Navigator.pushNamed(context, "/listaTutorias");

}


}