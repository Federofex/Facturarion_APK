import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gofact/db/sqlite.dart';
import 'inicio.dart';
import 'package:gofact/models/clases.dart';

class Ingreso extends StatefulWidget {
  static const String ruta = "/ingreso";
  @override
  State<Ingreso> createState() => _Ingreso();
}

class _Ingreso extends State<Ingreso> {
  List _usuarios = [];
  @override
  void initState() {
    getUsers();
    super.initState();
  }

  void getUsers() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("usuarios");

    QuerySnapshot users =
        await collectionReference.get(); //await porq es un future

    if (users.docs.length != 0) {
      //docs cantidad de documentos
      for (var doc in users.docs) {
        _usuarios.add(doc.data());
      }
    }
  }

  final user = TextEditingController();
  final password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: cuerpo(),
    );
  }

  Widget cuerpo() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/fondo.jpg'), fit: BoxFit.cover),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[contenido()],
        ),
      ),
    );
  }

  Widget contenido() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          titulo(),
          usuario(),
          contrasena(),
          boton(),
        ],
      ),
    );
  }

  Widget titulo() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
      child: Text(
        "INGRESAR",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget usuario() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: user,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.person),
          hintText: "Usuario",
        ),
      ),
    );
  }

  Widget contrasena() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextField(
        obscureText: true,
        obscuringCharacter: "*",
        controller: password,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.key),
          hintText: "Contraseña",
        ),
      ),
    );
  }

  Widget boton() {
    bool correcto = false;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 10),
        minimumSize: Size(300, 10),
        primary: Color.fromARGB(255, 26, 37, 55),
      ),
      onPressed: () {
        for (var index = 0; index < _usuarios.length; index++) {
          if (user.text == _usuarios[index]['user']) {
            if (password.text == _usuarios[index]['password']) {
              print("entro correctamente");
              setState(() {
                //Navigator.of(context).pushNamed("/inicio");
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => Inicio()),
                    (route) => false);
                correcto = true;
              });
            }
          }
        }
        if (!correcto) {
          print("Usuario o contraseña incorrecto");
          user.clear();
          password.clear();
        }
      },
      child: Text("Inicar Sesion"),
    );
  }
}
