import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton para garantir uma única instância do DatabaseHelper
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Método para obter a instância do banco de dados
  Future<Database> get database async {
    if (_database != null)
      return _database!; // Retorna a instância se já existir
    _database = await _initDB(
        'clinica_veterinaria.db'); // Caso contrário, inicializa o banco de dados
    return _database!;
  }

  // Inicializa o banco de dados com o caminho especificado
  Future<Database> _initDB(String filePath) async {
    final dbPath =
        await getDatabasesPath(); // Obtém o caminho do banco de dados no dispositivo
    final path =
        join(dbPath, filePath); // Junta o caminho base com o nome do arquivo

    // Abre o banco de dados e chama o método _createDB na criação
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Cria as tabelas no banco de dados
  Future _createDB(Database db, int version) async {
    // Criação da tabela Cliente
    await db.execute('''
      CREATE TABLE cliente (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        endereco TEXT NOT NULL,
        cep TEXT NOT NULL,
        telefone TEXT NOT NULL,
        email TEXT NOT NULL
      )
    ''');

    // Criação da tabela Animal
    await db.execute('''
      CREATE TABLE animal (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        idade INTEGER NOT NULL,
        sexo TEXT NOT NULL,
        clienteId INTEGER,
        FOREIGN KEY (clienteId) REFERENCES cliente (id)
      )
    ''');

    // Criação da tabela Especie
    await db.execute('''
      CREATE TABLE especie (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nomeEspecie TEXT NOT NULL
      )
    ''');

    // Criação da tabela Tratamento
    await db.execute('''
      CREATE TABLE tratamento (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dataInicialTratamento TEXT NOT NULL,
        dataFinalTratamento TEXT NOT NULL,
        animalId INTEGER,
        FOREIGN KEY (animalId) REFERENCES animal (id)
      )
    ''');

    // Criação da tabela Exame
    await db.execute('''
      CREATE TABLE exame (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descricaoExame TEXT NOT NULL,
        consultaId INTEGER,
        FOREIGN KEY (consultaId) REFERENCES consulta (id)
      )
    ''');

    // Criação da tabela Consulta
    await db.execute('''
      CREATE TABLE consulta (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dataConsulta TEXT NOT NULL,
        relatoConsulta TEXT NOT NULL,
        animalId INTEGER,
        veterinarioId INTEGER,
        FOREIGN KEY (animalId) REFERENCES animal (id),
        FOREIGN KEY (veterinarioId) REFERENCES veterinario (id)
      )
    ''');

    // Criação da tabela Veterinario
    await db.execute('''
      CREATE TABLE veterinario (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nomeVeterinario TEXT NOT NULL,
        enderecoVeterinario TEXT NOT NULL,
        cepVeterinario TEXT NOT NULL,
        telefoneVeterinario TEXT NOT NULL,
        emailVeterinario TEXT NOT NULL
      )
    ''');
  }

  // Métodos CRUD para a entidade Cliente

  // Método para inserir um cliente
  Future<int> inserirCliente(Map<String, dynamic> cliente) async {
    final db = await database; // Obtém a instância do banco de dados
    return await db.insert('cliente', cliente); // Insere o cliente na tabela
  }

  // Método para listar todos os clientes
  Future<List<Map<String, dynamic>>> listarClientes() async {
    final db = await database; // Obtém a instância do banco de dados
    return await db
        .query('cliente'); // Retorna todos os registros da tabela 'cliente'
  }

  // Método para atualizar um cliente existente
  Future<int> atualizarCliente(int id, Map<String, dynamic> cliente) async {
    final db = await database; // Obtém a instância do banco de dados
    return await db.update(
      'cliente',
      cliente,
      where: 'id = ?', // Condição para identificar o cliente pelo ID
      whereArgs: [id],
    );
  }

  // Método para deletar um cliente pelo ID
  Future<int> deletarCliente(int id) async {
    final db = await database; // Obtém a instância do banco de dados
    return await db.delete(
      'cliente',
      where: 'id = ?', // Condição para identificar o cliente pelo ID
      whereArgs: [id],
    );
  }
}
