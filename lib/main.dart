import 'package:appfinal/Pages/Profesores/crearEntrada.dart';
import 'package:appfinal/Pages/Profesores/crearTutoria.dart';
import 'package:appfinal/Pages/detalleTutoria.dart';
import 'package:appfinal/Pages/panelTutoria.dart';
import 'package:appfinal/Pages/getEntrada.dart';
import 'package:flutter/material.dart';

import 'Pages/Profesores/editarEntrada.dart';
import 'Pages/listaTutorias.dart';
import 'Pages/HomePage.dart';
import 'Pages/rutas.dart';


void main() {
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
        '/':(context)=> Rutas(),
        '/home':(context)=> HomePage(),
        '/listaTutorias':(context)=> listaTutorias(),
        '/detalleTutoria':(context) => detalleTutoria(),
        '/panelTutoria':(context) => panelTutoria(),
        '/crearTutoria':(context) => crearTutoria(),
        '/getEntrada':(context) => getEntrada(),
        '/crearEntrada':(context) => crearEntrada(),
        '/editarEntrada':(context) => editarEntrada(),
      },

    );
  }
}
