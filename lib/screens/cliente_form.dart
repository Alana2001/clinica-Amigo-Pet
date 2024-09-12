import 'package:clinic_pet/database/database.dart';
import 'package:flutter/material.dart';
//import '../database/database_helper.dart';
import '../models/cliente.dart';

class ClienteForm extends StatefulWidget {
  @override
  _ClienteFormState createState() => _ClienteFormState();
}

class _ClienteFormState extends State<ClienteForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _cepController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();

  Future<void> handleCliente(Cliente cliente) async {
    final db = await DB.instance.database;
    db.insert('cliente', cliente.toMap());
    try {
      final db = await DB.instance.database;
      db.insert('cliente', cliente.toMap());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cliente cadastrado com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar cliente!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastrar Cliente")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor insira o nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _enderecoController,
                decoration: InputDecoration(labelText: 'Endereço'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor insira o endereço';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cepController,
                decoration: InputDecoration(labelText: 'CEP'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor insira o CEP';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: InputDecoration(labelText: 'Telefone'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor insira o telefone';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor insira o email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Cliente novoCliente = Cliente(
                      nome: _nomeController.text,
                      endereco: _enderecoController.text,
                      cep: _cepController.text,
                      telefone: _telefoneController.text,
                      email: _emailController.text,
                    );
                    handleCliente(novoCliente);
                  }
                },
                child: Text('Salvar Cliente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
