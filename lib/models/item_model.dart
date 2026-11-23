class ItemModel {
  final int? id;
  final String titulo;
  final String dataRegistro; // Formato YYYY-MM-DD
  final String local;
  final String? imagemUrl;
  bool foiDevolvido;
  String? nomeRetirante;
  String? dataDevolucao; // Formato YYYY-MM-DD

  ItemModel({
    this.id,
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

  // Converte YYYY-MM-DD para DD/MM/YYYY na interface
  String get dataRegistroFormatada => _formatarDataParaExibicao(dataRegistro);
  String? get dataDevolucaoFormatada =>
      dataDevolucao != null ? _formatarDataParaExibicao(dataDevolucao!) : null;

  static String _formatarDataParaExibicao(String data) {
    if (data.contains('-')) {
      final partes = data.split('-');
      if (partes.length == 3) {
        return '${partes[2]}/${partes[1]}/${partes[0]}';
      }
    }
    return data;
  }

  // Mapeia do Supabase para o modelo Dart
  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'] as int?,
      titulo: map['titulo'] as String? ?? '',
      dataRegistro: map['data_registro'] as String? ?? '',
      local: map['local'] as String? ?? '',
      imagemUrl: map['imagem_url'] as String?,
      foiDevolvido: map['foi_devolvido'] as bool? ?? false,
      nomeRetirante: map['nome_retirante'] as String?,
      dataDevolucao: map['data_devolucao'] as String?,
    );
  }

  // Converte para Map para salvar no Supabase
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'titulo': titulo,
      'data_registro': dataRegistro,
      'local': local,
      'imagem_url': imagemUrl,
      'foi_devolvido': foiDevolvido,
      'nome_retirante': nomeRetirante,
      'data_devolucao': dataDevolucao,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
