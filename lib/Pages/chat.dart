import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';


class chat extends StatefulWidget {
  const chat({super.key});

  @override
  State<chat> createState() => _chatState();
}

class _chatState extends State<chat> {
  Map argumentosRecividos = new Map();
  final user = FirebaseAuth.instance.currentUser!; 
  var usuarioInfo;
  TextEditingController mensajeEnviar=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat")),
      body: ListView(
        children: [
          MaterialButton(
            color: Colors.blueAccent,
            child: Text("conectar"),
            onPressed: btn_conectar),
          TextField(controller: mensajeEnviar,),

        ],
        
      ),
    );
  }


  void btn_conectar(){
    print("ok");
    //IO.Socket socket = IO.io('http://192.168.1.57:3000');
    /*IO.Socket socket = IO.io('http://192.168.1.57:3000',<String,dynamic>{
      'transports':['websocket']
    });*/
    IO.Socket socket = IO.io('http://192.168.1.57:3000',OptionBuilder()
    .setTransports(['websocket'])
    .enableAutoConnect() // for Flutter or Dart VM
    .build());

    socket.onConnect((_) {
      print('Conexion exitosa al socket');
      //socket.emit('msg', 'test');
    });
    socket.emit('nuevo_mensaje',{"msj":"Conexion desde flutter"});
    //socket.on('event', (data) => print(data));
    socket.onDisconnect((_) => print('disconnect'));
    //socket.on('fromServer', (_) => print(_));
    print("ok2");
  }
  

}


