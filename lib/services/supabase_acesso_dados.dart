import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/AcessoDados.dart';
import '../models/item_model.dart';

class SupabaseAcessoDados implements AcessoDados {
  final SupabaseClient _supabase;

  SupabaseAcessoDados({SupabaseClient? supabaseClient})
      : _supabase = supabaseClient ?? Supabase.instance.client;

  static const String _nomeBucket = 'fotos-itens';
  static const String _nomeTabela = 'itens';

  // Faz o upload dos bytes da imagem para o Supabase Storage e obtém a URL pública
  Future<String?> _uploadImagem(Uint8List bytes) async {
    final nomeArquivo = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Importante: upsert é false para respeitar a policy de apenas INSERT do bucket
    await _supabase.storage.from(_nomeBucket).uploadBinary(
          nomeArquivo,
          bytes,
          fileOptions: const FileOptions(
            contentType: 'image/jpeg',
            upsert: false,
          ),
        );

    final urlPublica = _supabase.storage.from(_nomeBucket).getPublicUrl(nomeArquivo);
    return urlPublica;
  }

  @override
  Future<void> criar(ItemModel item, {Uint8List? imagemBytes}) async {
    String? urlImagem = item.imagemUrl;

    if (imagemBytes != null && imagemBytes.isNotEmpty) {
      urlImagem = await _uploadImagem(imagemBytes);
    }

    final dados = item.toMap();
    // Remove o id caso nulo para deixar o banco gerar via identity
    dados.remove('id');
    if (urlImagem != null) {
      dados['imagem_url'] = urlImagem;
    }

    await _supabase.from(_nomeTabela).insert(dados);
  }

  @override
  Future<void> devolver(int id, {required String retirante, required String data}) async {
    await _supabase.from(_nomeTabela).update({
      'foi_devolvido': true,
      'nome_retirante': retirante,
      'data_devolucao': data,
    }).eq('id', id);
  }

  @override
  Future<List<ItemModel>> obterTodos() async {
    final response = await _supabase
        .from(_nomeTabela)
        .select()
        .order('id', ascending: false);

    final listaMapas = response as List<dynamic>;
    return listaMapas
        .map((mapa) => ItemModel.fromMap(mapa as Map<String, dynamic>))
        .toList();
  }
}
