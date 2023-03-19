class Produto {
  int? id;
  String nome;
  String marca;
  int quantidade;

  Produto({
    this.id,
    required this.nome,
    required this.marca,
    required this.quantidade,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'marca': marca,
      'quantidade': quantidade,
    };
  }

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map['id'],
      nome: map['nome'],
      marca: map['marca'],
      quantidade: map['quantidade'],
    );
  }
}
