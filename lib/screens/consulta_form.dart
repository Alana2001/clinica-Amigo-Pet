import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/consulta.dart';
import '../models/animal.dart';
import '../models/veterinario.dart';

class ConsultaForm extends StatefulWidget {
  @override
  _ConsultaFormState createState() => _ConsultaFormState();
}

class _ConsultaFormState extends State<ConsultaForm> {
  final _formKey = GlobalKey<FormState>();
  final _dataConsultaController = TextEditingController();
  final _relatoConsultaController = TextEditingController();
  int? _animalSelecionado;
  int? _veterinarioSelecionado;

  List<Animal> _animais = [];
  List<Veterinario> _veterinarios = [];

  @override
  void initState() {
    super.initState();
    _carregarAnimaisEVeterinarios();
  }

  Future<void> _carregarAnimaisEVeterinarios() async {
    final db = await DatabaseHelper.instance.database;
    final animais = await db.query('animal');
    final veterinarios = await db.query('veterinario');

    setState(() {
      _animais = animais.map((animal) {
        return Animal(
          id: animal['id'] as int,
          nome: animal['nome'] as String,
          idade: animal['idade'] as int,
          sexo: animal['sexo'] as String,
          clienteId: animal['clienteId'] as int,
        );
      }).toList();

      _veterinarios = veterinarios.map((veterinario) {
        return Veterinario(
          id: veterinario['id'] as int,
          nomeVeterinario: veterinario['nome'] as String,
          enderecoVeterinario: veterinario['endereco'] as String,
          cepVeterinario: veterinario['cep'] as String,
          telefoneVeterinario: veterinario['telefone'] as String,
          emailVeterinario: veterinario['email'] as String,
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registrar Consulta")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _dataConsultaController,
                decoration:
                    InputDecoration(labelText: 'Data da Consulta (dd/mm/yyyy)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor insira a data da consulta';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _relatoConsultaController,
                decoration: InputDecoration(labelText: 'Relato da Consulta'),
              ),
              DropdownButtonFormField<int>(
                value: _animalSelecionado,
                decoration: InputDecoration(labelText: 'Animal'),
                items: _animais.map((Animal animal) {
                  return DropdownMenuItem<int>(
                    value: animal.id,
                    child: Text(animal.nome),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _animalSelecionado = value;
                  });
                },
              ),
              DropdownButtonFormField<int>(
                value: _veterinarioSelecionado,
                decoration: InputDecoration(labelText: 'Veterinário'),
                items: _veterinarios.map((Veterinario veterinario) {
                  return DropdownMenuItem<int>(
                    value: veterinario.id,
                    child: Text(veterinario.nomeVeterinario),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _veterinarioSelecionado = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Consulta novaConsulta = Consulta(
                      dataConsulta: _dataConsultaController.text,
                      relatoConsulta: _relatoConsultaController.text,
                      animalId: _animalSelecionado!,
                      veterinarioId: _veterinarioSelecionado!,
                    );

                    await DatabaseHelper.instance.database.then((db) {
                      db.insert('consulta', novaConsulta.toMap());
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Consulta registrada com sucesso!')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('Salvar Consulta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
