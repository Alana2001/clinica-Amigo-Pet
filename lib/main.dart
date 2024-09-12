import 'package:clinic_pet/database/database.dart';
import 'package:flutter/material.dart';
import 'home_page.dart'; // Importe o arquivo onde está a HomePage
import 'screens/animal_form.dart'; // Importe os arquivos de formulário
import 'screens/cliente_form.dart';
import 'screens/consulta_form.dart';
import 'screens/exame_form.dart';
import 'screens/tratamento_form.dart';
import 'screens/veterinario_form.dart';

void main() async {
  await DB.instance.initDatabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clínica Amigo Pet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(), // Tela inicial
      routes: {
        '/animalForm': (context) => AnimalForm(),
        '/clienteForm': (context) => ClienteForm(),
        '/consultaForm': (context) => ConsultaForm(),
        '/exameForm': (context) => ExameForm(),
        '/tratamentoForm': (context) => TratamentoForm(),
        '/veterinarioForm': (context) => VeterinarioForm(),
      },
    );
  }
}
