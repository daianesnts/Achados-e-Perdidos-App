import 'package:flutter/material.dart';
import '../../models/item_model.dart';

class DevolverSheet extends StatefulWidget {
  final ItemModel item;
  final Future<void> Function({
    required int itemId,
    required String nomeRetirante,
    required String dataDevolucao,
  }) onConfirmar;

  const DevolverSheet({
    super.key,
    required this.item,
    required this.onConfirmar,
  });

  @override
  State<DevolverSheet> createState() => _DevolverSheetState();
}

class _DevolverSheetState extends State<DevolverSheet> {
  final _nomeController = TextEditingController();
  final _dataController = TextEditingController();

  DateTime? _dataEscolhida;
  bool _confirmando = false;

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
    _nomeController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    // A data mínima permitida é a data em que o item foi perdido
    final dataMinima = DateTime.parse(widget.item.dataRegistro);

    final DateTime? data = await showDatePicker(
      context: context,
      initialDate: _dataEscolhida!.isBefore(dataMinima) ? dataMinima : _dataEscolhida!,
      firstDate: dataMinima,
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

  Future<void> _confirmarDevolucao() async {
    final nome = _nomeController.text.trim();

    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe o nome de quem está retirando!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (widget.item.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item inválido (sem ID)!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final data = _dataEscolhida ?? DateTime.now();
    final ano = data.year.toString();
    final mes = data.month.toString().padLeft(2, '0');
    final dia = data.day.toString().padLeft(2, '0');
    final dataParaBanco = '$ano-$mes-$dia';

    setState(() {
      _confirmando = true;
    });

    try {
      await widget.onConfirmar(
        itemId: widget.item.id!,
        nomeRetirante: nome,
        dataDevolucao: dataParaBanco,
      );

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('Erro ao registrar devolução: $e');
      if (mounted) {
        setState(() {
          _confirmando = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao registrar devolução: $e'),
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
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildCampoRetirante(),
          const SizedBox(height: 14),
          _buildCampoDataDevolucao(),
          const SizedBox(height: 20),
          _buildBotaoConfirmar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(Icons.assignment_return_outlined,
            color: Color(0xFF1E3A8A)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Devolver: ${widget.item.titulo}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCampoRetirante() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Nome de quem está retirando',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
          controller: _nomeController,
          enabled: !_confirmando,
          decoration: InputDecoration(
            hintText: 'Ex.: Carlos Eduardo Santos',
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

  Widget _buildCampoDataDevolucao() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Data da Devolução',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
          controller: _dataController,
          readOnly: true,
          enabled: !_confirmando,
          onTap: _confirmando ? null : _selecionarData,
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

  Widget _buildBotaoConfirmar() {
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
        onPressed: _confirmando ? null : _confirmarDevolucao,
        child: _confirmando
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Text(
                'Confirmar Devolução',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
