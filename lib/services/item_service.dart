import 'dart:typed_data';
import '../core/AcessoDados.dart';
import '../models/item_model.dart';
import 'supabase_acesso_dados.dart';

class ItemService {
  final AcessoDados _acessoDados;

  ItemService({AcessoDados? acessoDados})
      : _acessoDados = acessoDados ?? SupabaseAcessoDados();

  List<ItemModel> _itens = [];

  List<ItemModel> get itensPerdidos {
    return _itens.where((item) => !item.foiDevolvido).toList();
  }

  List<ItemModel> get itensDevolvidos {
    return _itens.where((item) => item.foiDevolvido).toList();
  }

  Future<void> carregarItens() async {
    _itens = await _acessoDados.obterTodos();
  }

  Future<void> adicionarItem({
    required String titulo,
    required String dataRegistro,
    required String local,
    Uint8List? imagemBytes,
  }) async {
    final novoItem = ItemModel(
      titulo: titulo,
      dataRegistro: dataRegistro,
      local: local,
      foiDevolvido: false,
    );
    await _acessoDados.criar(novoItem, imagemBytes: imagemBytes);
    await carregarItens();
  }

  Future<void> registrarDevolucao({
    required int itemId,
    required String nomeRetirante,
    required String dataDevolucao,
  }) async {
    await _acessoDados.devolver(
      itemId,
      retirante: nomeRetirante,
      data: dataDevolucao,
    );
    await carregarItens();
  }
}
