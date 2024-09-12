import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/tratamento.dart';
import '../models/animal.dart';

class TratamentoForm extends StatefulWidget {
  @override
  _TratamentoFormState createState() => _TratamentoFormState();
}

class _TratamentoFormState extends State<TratamentoForm> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _dataInicialController = TextEditingController();
  final _dataFinalController = TextEditingController();
  int? _animalSelecionado;

  List<Animal> _animais = [];

  @override
  void initState() {
    super.initState();
    _carregarAnimais();
  }

  Future<void> _carregarAnimais() async {
    final db = await DatabaseHelper.instance.database;
    final animais = await db.query('animal');

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registrar Tratamento")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _descricaoController,
                decoration:
                    InputDecoration(labelText: 'Descrição do Tratamento'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor insira a descrição do tratamento';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dataInicialController,
                decoration:
                    InputDecoration(labelText: 'Data Inicial (dd/mm/yyyy)'),
              ),
              TextFormField(
                controller: _dataFinalController,
                decoration:
                    InputDecoration(labelText: 'Data Final (dd/mm/yyyy)'),
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
                validator: (value) {
                  if (value == null) {
                    return 'Por favor selecione o animal';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Tratamento novoTratamento = Tratamento(
                      dataInicial: _dataInicialController.text,
                      dataFinal: _dataFinalController.text,
                      animalId: _animalSelecionado!,
                    );

                    await DatabaseHelper.instance.database.then((db) {
                      db.insert('tratamento', novoTratamento.toMap());
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Tratamento registrado com sucesso!')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('Salvar Tratamento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
