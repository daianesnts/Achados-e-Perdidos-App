import 'dart:typed_data';
import '../models/item_model.dart';

abstract interface class AcessoDados {
  Future<void> criar(ItemModel item, {Uint8List? imagemBytes});
  Future<void> devolver(int id, {required String retirante, required String data});
  Future<List<ItemModel>> obterTodos();
}
