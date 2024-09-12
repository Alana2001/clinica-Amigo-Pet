import 'package:flutter/material.dart';
import 'screens/cliente_form.dart';
import 'screens/animal_form.dart';
import 'screens/consulta_form.dart';
import 'screens/exame_form.dart';
import 'screens/tratamento_form.dart';
import 'screens/veterinario_form.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clínica Veterinária'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClienteForm()),
                );
              },
              child: Text('Gerenciar Clientes'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AnimalForm()),
                );
              },
              child: Text('Gerenciar Animais'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConsultaForm()),
                );
              },
              child: Text('Gerenciar Consultas'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExameForm()),
                );
              },
              child: Text('Gerenciar Exames'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TratamentoForm()),
                );
              },
              child: Text('Gerenciar Tratamentos'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VeterinarioForm()),
                );
              },
              child: Text('Gerenciar Veterinários'),
            ),
          ],
        ),
      ),
    );
  }
}
