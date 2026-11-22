class ItemModel {
  final String id;
  final String titulo;
  final String dataRegistro;
  final String local;
  final String? imagemUrl; 
  bool foiDevolvido;
  String? nomeRetirante;
  String? dataDevolucao;

  ItemModel({
    required this.id,
    required this.titulo,
    required this.dataRegistro,
    required this.local,
    this.imagemUrl,
    this.foiDevolvido = false,
    this.nomeRetirante,
    this.dataDevolucao,
  });

  void devolver({
    required String retirante,
    required String data,
  }) {
    foiDevolvido = true;
    nomeRetirante = retirante;
    dataDevolucao = data;
  }
}
