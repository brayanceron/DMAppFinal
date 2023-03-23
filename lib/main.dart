import 'package:appfinal/Pages/Profesores/crearEntrada.dart';
import 'package:appfinal/Pages/Profesores/crearTutoria.dart';
import 'package:appfinal/Pages/Profesores/solicitudesProfesor.dart';
import 'package:appfinal/Pages/chat.dart';
import 'package:appfinal/Pages/login/signIn.dart';
import 'package:appfinal/Pages/myPerfil.dart';
import 'package:appfinal/myWebView.dart';
import 'Pages/Profesores/editarEntrada.dart';
import 'package:appfinal/Pages/catalogoTutorias.dart';
import 'package:appfinal/Pages/detalleTutoria.dart';
import 'package:appfinal/Pages/login/homeunologin.dart';
import 'package:appfinal/Pages/panelTutoria.dart';
import 'package:appfinal/Pages/getEntrada.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


import 'Pages/listaTutorias.dart';
import 'Pages/HomePage.dart';
import 'Pages/login/homedoslogin.dart';
import 'Pages/login/login.dart';
import 'Pages/login/homeunologin.dart';
import 'Pages/rutas.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Pages/solicitudesEstudiante.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appfinal',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
      ),
      
      initialRoute:'/',	//estrictamente con comillas simples
      routes:{
        //'/':(context)=> login(),
        '/':(context)=> Rutas(),
        '/rutas':(context)=> Rutas(),
        '/home':(context)=> HomePage(),
        '/listaTutorias':(context)=> listaTutorias(),
        '/catalogoTutorias':(context)=> catalogoTutorias(),
        '/detalleTutoria':(context) => detalleTutoria(),
        '/panelTutoria':(context) => panelTutoria(),
        '/crearTutoria':(context) => crearTutoria(),
        '/getEntrada':(context) => getEntrada(),
        '/crearEntrada':(context) => crearEntrada(),
        '/editarEntrada':(context) => editarEntrada(),

        '/solicitudesProfesor':(context) => solicitudesProfesor(),
        '/solicitudesEstudiante':(context) => solicitudesEstudiante(),
        '/chat':(context) => chat(),
        '/myPerfil':(context) => myPerfil(),


        '/login':(context) => login(),
        '/signin':(context) => signIn(),
        '/homeunologin':(context) => homeuno(),
        '/homedoslogin':(context) => homedoslogin(),
        '/webview':(context) => myWebView(),
      },

    );
  }
}
