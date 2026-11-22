import '../models/item_model.dart';

class ItemService {
  final List<ItemModel> _itens = [];

  List<ItemModel> get itensPerdidos {
    return _itens.where((item) => !item.foiDevolvido).toList();
  }

  List<ItemModel> get itensDevolvidos {
    return _itens.where((item) => item.foiDevolvido).toList();
  }
  void adicionarItem({
    required String titulo,
    required String dataRegistro,
    required String local,
    String? imagemUrl,
  }) {
    final novoItem = ItemModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      titulo: titulo,
      dataRegistro: dataRegistro,
      local: local,
      imagemUrl: imagemUrl,
      foiDevolvido: false,
    );
    _itens.insert(0, novoItem); 
  }

  void registrarDevolucao({
    required String itemId,
    required String nomeRetirante,
    required String dataDevolucao,
  }) {
    final index = _itens.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      _itens[index].devolver(
        retirante: nomeRetirante,
        data: dataDevolucao,
      );
    }
  }
}
