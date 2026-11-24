import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NovoItemSheet extends StatefulWidget {
  final Future<void> Function({
    required String titulo,
    required String dataRegistro,
    required String local,
    Uint8List? imagemBytes,
  }) onSalvar;

  const NovoItemSheet({super.key, required this.onSalvar});

  @override
  State<NovoItemSheet> createState() => _NovoItemSheetState();
}

class _NovoItemSheetState extends State<NovoItemSheet> {
  final _tituloController = TextEditingController();
  final _dataController = TextEditingController();
  final _localController = TextEditingController();

  DateTime? _dataEscolhida;
  Uint8List? _imagemBytes;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    final hoje = DateTime.now();
    _dataEscolhida = hoje;
    final dia = hoje.day.toString().padLeft(2, '0');
    final mes = hoje.month.toString().padLeft(2, '0');
    final ano = hoje.year.toString();
    _dataController.text = '$dia/$mes/$ano';
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _dataController.dispose();
    _localController.dispose();
    super.dispose();
  }

  // Seleciona a imagem da galeria (compatível com Mobile e FlutLab/Web)
  Future<void> _selecionarImagem() async {
    try {
      final picker = ImagePicker();
      final XFile? foto = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (foto != null) {
        final bytes = await foto.readAsBytes();
        setState(() {
          _imagemBytes = bytes;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao selecionar imagem: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Abre o seletor de data padrão do Flutter
  Future<void> _selecionarData() async {
    final DateTime? data = await showDatePicker(
      context: context,
      initialDate: _dataEscolhida ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (data != null) {
      _dataEscolhida = data;
      final dia = data.day.toString().padLeft(2, '0');
      final mes = data.month.toString().padLeft(2, '0');
      final ano = data.year.toString();
      setState(() {
        _dataController.text = '$dia/$mes/$ano';
      });
    }
  }

  Future<void> _salvar() async {
    final titulo = _tituloController.text.trim();
    final local = _localController.text.trim();

    if (titulo.isEmpty || local.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Formata a data no formato ISO YYYY-MM-DD para a coluna date do PostgreSQL
    final data = _dataEscolhida ?? DateTime.now();
    final ano = data.year.toString();
    final mes = data.month.toString().padLeft(2, '0');
    final dia = data.day.toString().padLeft(2, '0');
    final dataParaBanco = '$ano-$mes-$dia';

    setState(() {
      _salvando = true;
    });

    try {
      await widget.onSalvar(
        titulo: titulo,
        dataRegistro: dataParaBanco,
        local: local,
        imagemBytes: _imagemBytes,
      );

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('Erro ao cadastrar item: $e');
      if (mounted) {
        setState(() {
          _salvando = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao cadastrar item: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Evita que o teclado cubra os campos de texto
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitulo(),
            const SizedBox(height: 18),
            _buildSeletorFoto(),
            const SizedBox(height: 16),
            _buildCampoTitulo(),
            const SizedBox(height: 14),
            _buildCampoData(),
            const SizedBox(height: 14),
            _buildCampoLocal(),
            const SizedBox(height: 20),
            _buildBotaoSalvar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitulo() {
    return const Text(
      'Registrar novo item perdido',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSeletorFoto() {
    return Center(
      child: InkWell(
        onTap: _salvando ? null : _selecionarImagem,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (_imagemBytes != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.memory(
                    _imagemBytes!,
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_outlined,
                        size: 44, color: Colors.grey.shade500),
                    const SizedBox(height: 4),
                    Text(
                      'Adicionar foto',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              Positioned(
                bottom: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E3A8A),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.cloud_upload,
                      size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCampoTitulo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Título', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
          controller: _tituloController,
          enabled: !_salvando,
          decoration: InputDecoration(
            hintText: 'Ex.: Carregador USB-C',
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCampoData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Data', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
          controller: _dataController,
          readOnly: true,
          enabled: !_salvando,
          onTap: _salvando ? null : _selecionarData,
          decoration: InputDecoration(
            hintText: 'Ex.: 26/12/2026',
            filled: true,
            fillColor: Colors.grey.shade100,
            suffixIcon: const Icon(Icons.calendar_today_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCampoLocal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Local', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
          controller: _localController,
          enabled: !_salvando,
          decoration: InputDecoration(
            hintText: 'Ex.: Sala 106 Bloco D',
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBotaoSalvar() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E3A8A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _salvando ? null : _salvar,
        child: _salvando
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Text(
                'Salvar',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
