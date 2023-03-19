import 'item.dart';

class ListaDeCompras {
  List<Item> _itens = [];

  void adicionarItem(Item item) {
    _itens.add(item);
  }

  void editarItem(int index, Item item) {
    _itens[index] = item;
  }

  void excluirItem(int index) {
    _itens.removeAt(index);
  }

  List<Item> get itens => _itens;
}
