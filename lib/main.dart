import 'package:flutter/material.dart';
import 'Produto.dart';
import 'db_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de compras',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final DbHelper _dbHelper;

  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _marcaController = TextEditingController();
  final _quantidadeController = TextEditingController();

  static List<Produto> _produtos = [];

  Future<void> _atualizarProdutos() async {
    final produtos = await _dbHelper.obterTodosOsProdutos();

    setState(() {
      _produtos = produtos;
    });
  }

  @override
  void initState() {
    _dbHelper = DbHelper();
    _dbHelper.database;
    super.initState();

    _atualizarProdutos();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _marcaController.dispose();
    _quantidadeController.dispose();

    super.dispose();
  }

  Future<void> _adicionarProduto() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      final produto = Produto(
        nome: _nomeController.text,
        marca: _marcaController.text,
        quantidade: int.parse(_quantidadeController.text),
      );

      await _dbHelper.inserirProduto(produto);

      setState(() {
        _produtos.add(produto);
      });

      _nomeController.clear();
      _marcaController.clear();
      _quantidadeController.clear();
      Navigator.pop(context);
    }
  }

  Future<void> _novoProduto() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Novo produto'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: _nomeController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'O nome não pode estar vazio';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _marcaController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'A marca não pode estar vazia';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Marca',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _quantidadeController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'A quantidade não pode estar vazia';
                      }
                      final quantidade = int.tryParse(value);

                      if (quantidade == null || quantidade <= 0) {
                        return 'A quantidade deve ser maior que zero';
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Quantidade',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Salvar'),
              onPressed: _adicionarProduto,
            ),
          ],
        );
      },
    );
  }

  Future<void> _editarProduto(Produto produto) async {
    _nomeController.text = produto.nome;
    _marcaController.text = produto.marca;
    _quantidadeController.text = produto.quantidade.toString();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar produto'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: _nomeController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'O nome não pode estar vazio';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _marcaController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'A marca não pode estar vazia';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Marca',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _quantidadeController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'A quantidade não pode estar vazia';
                      }
                      final quantidade = int.tryParse(value);

                      if (quantidade == null || quantidade <= 0) {
                        return 'A quantidade deve ser maior que zero';
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Quantidade',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Salvar'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  Produto teste = Produto(
                      nome: _nomeController.text,
                      marca: _marcaController.text,
                      quantidade: int.parse(_quantidadeController.text));

                  await _dbHelper.atualizarProduto(produto);

                  setState(() {});

                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _excluirProduto(Produto produto) async {
    await _dbHelper.excluirProduto(produto.id as int);
    setState(() {
      _produtos.remove(produto);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de compras'),
      ),
      body: ListView.builder(
        itemCount: _produtos.length,
        itemBuilder: (context, index) {
          final produto = _produtos[index];
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  SizedBox(width: 16),
                ],
              ),
            ),
            onDismissed: (_) => _excluirProduto(produto),
            child: ListTile(
              title: Text(produto.nome),
              subtitle: Text(
                  'Marca: ${produto.marca} - Quantidade: ${produto.quantidade}'),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _editarProduto(produto),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _novoProduto(),
        tooltip: 'Adicionar produto',
        child: Icon(Icons.add),
      ),
    );
  }
}
