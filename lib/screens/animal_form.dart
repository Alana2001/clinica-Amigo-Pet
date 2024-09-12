import 'package:clinic_pet/database/database.dart';
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/animal.dart';
import '../models/cliente.dart';

class AnimalForm extends StatefulWidget {
  @override
  _AnimalFormState createState() => _AnimalFormState();
}

class _AnimalFormState extends State<AnimalForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();
  String? _sexoSelecionado;
  int? _clienteSelecionado;

  List<Cliente> _clientes = [];

  @override
  void initState() {
    super.initState();
    _carregarClientes();
  }

  // Função para carregar os clientes disponíveis no banco de dados
  Future<void> _carregarClientes() async {
    final db = await DB.instance.database;
    final clientes = await db.query('cliente'); // Busca todos os clientes

    setState(() {
      _clientes = clientes.map((cliente) {
        return Cliente(
          id: cliente['id'] as int,
          nome: cliente['nome'] as String,
          endereco: cliente['endereco'] as String,
          cep: cliente['cep'] as String,
          telefone: cliente['telefone'] as String,
          email: cliente['email'] as String,
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastrar Animal")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome do Animal'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor insira o nome do animal';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _idadeController,
                decoration: InputDecoration(labelText: 'Idade do Animal'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor insira a idade do animal';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _sexoSelecionado,
                decoration: InputDecoration(labelText: 'Sexo do Animal'),
                items: ['Macho', 'Fêmea'].map((String sexo) {
                  return DropdownMenuItem<String>(
                    value: sexo,
                    child: Text(sexo),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _sexoSelecionado = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor selecione o sexo do animal';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<int>(
                value: _clienteSelecionado,
                decoration: InputDecoration(labelText: 'Cliente Proprietário'),
                items: _clientes.map((Cliente cliente) {
                  return DropdownMenuItem<int>(
                    value: cliente.id,
                    child: Text(cliente.nome),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _clienteSelecionado = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor selecione o cliente proprietário';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Animal novoAnimal = Animal(
                      nome: _nomeController.text,
                      idade: int.parse(_idadeController.text),
                      sexo: _sexoSelecionado!,
                      clienteId: _clienteSelecionado!,
                    );

                    await DatabaseHelper.instance.database.then((db) {
                      db.insert('animal', novoAnimal.toMap());
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Animal cadastrado com sucesso!')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('Salvar Animal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
