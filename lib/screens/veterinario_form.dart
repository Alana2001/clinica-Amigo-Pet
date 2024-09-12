import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/veterinario.dart';

class VeterinarioForm extends StatefulWidget {
  @override
  _VeterinarioFormState createState() => _VeterinarioFormState();
}

class _VeterinarioFormState extends State<VeterinarioForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _cepController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastrar Veterinário")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome do Veterinário'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor insira o nome do veterinário';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _enderecoController,
                decoration: InputDecoration(labelText: 'Endereço'),
              ),
              TextFormField(
                controller: _cepController,
                decoration: InputDecoration(labelText: 'CEP'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: InputDecoration(labelText: 'Telefone'),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Veterinario novoVeterinario = Veterinario(
                      nomeVeterinario: _nomeController.text,
                      enderecoVeterinario: _enderecoController.text,
                      cepVeterinario: _cepController.text,
                      telefoneVeterinario: _telefoneController.text,
                      emailVeterinario: _emailController.text,
                    );

                    await DatabaseHelper.instance.database.then((db) {
                      db.insert('veterinario', novoVeterinario.toMap());
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Veterinário cadastrado com sucesso!')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('Salvar Veterinário'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
