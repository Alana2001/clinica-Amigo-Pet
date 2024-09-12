import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/exame.dart';
import '../models/consulta.dart';

class ExameForm extends StatefulWidget {
  @override
  _ExameFormState createState() => _ExameFormState();
}

class _ExameFormState extends State<ExameForm> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  int? _consultaSelecionada;

  List<Consulta> _consultas = [];

  @override
  void initState() {
    super.initState();
    _carregarConsultas();
  }

  // Função para carregar as consultas disponíveis no banco de dados
  Future<void> _carregarConsultas() async {
    final db = await DatabaseHelper.instance.database;
    final consultas = await db.query('consulta'); // Busca todas as consultas

    setState(() {
      _consultas = consultas.map((consulta) {
        return Consulta(
          id: consulta['id'] as int,
          dataConsulta: consulta['dataConsulta'] as String,
          relatoConsulta: consulta['relatoConsulta'] as String,
          animalId: consulta['animalId'] as int,
          veterinarioId: consulta['veterinarioId'] as int,
        );
      }).toList();
    });
  }

  // Função para registrar um novo exame
  Future<void> _registrarExame() async {
    if (_formKey.currentState!.validate()) {
      Exame novoExame = Exame(
        descricaoExame: _descricaoController.text,
        consultaId: _consultaSelecionada!,
      );

      final db = await DatabaseHelper.instance.database;
      await db.insert('exame', novoExame.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exame registrado com sucesso!')),
      );
      Navigator.pop(context);
    }
  }

  // Função para consultar um exame específico
  Future<void> _consultarExame(int id) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('exame', where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      final exame = Exame.fromMap(result.first);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exame encontrado: ${exame.descricaoExame}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exame não encontrado')),
      );
    }
  }

  // Função para listar todos os exames
  Future<void> _listarExames() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('exame');

    if (result.isNotEmpty) {
      final exames = result.map((e) => Exame.fromMap(e)).toList();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Exames Registrados'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: exames.map((exame) {
                return ListTile(
                  title: Text(exame.descricaoExame),
                );
              }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Fechar'),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nenhum exame registrado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastrar Exame")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(labelText: 'Descrição do Exame'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor insira a descrição do exame';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<int>(
                value: _consultaSelecionada,
                decoration: InputDecoration(labelText: 'Consulta'),
                items: _consultas.map((Consulta consulta) {
                  return DropdownMenuItem<int>(
                    value: consulta.id,
                    child: Text('Consulta: ${consulta.dataConsulta}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _consultaSelecionada = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor selecione uma consulta';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registrarExame,
                child: Text('Salvar Exame'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Consultar exame com ID específico (exemplo: ID 1)
                  await _consultarExame(1);
                },
                child: Text('Consultar Exame'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _listarExames,
                child: Text('Listar Exames'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
