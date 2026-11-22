import 'package:flutter/material.dart';
import '../../models/item_model.dart';

class DevolverSheet extends StatefulWidget {
  final ItemModel item;
  final Function({
    required String itemId,
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

  @override
  void initState() {
    super.initState();
    final hoje = DateTime.now();
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
    final DateTime? dataEscolhida = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (dataEscolhida != null) {
      final dia = dataEscolhida.day.toString().padLeft(2, '0');
      final mes = dataEscolhida.month.toString().padLeft(2, '0');
      final ano = dataEscolhida.year.toString();
      setState(() {
        _dataController.text = '$dia/$mes/$ano';
      });
    }
  }

  void _confirmarDevolucao() {
    final nome = _nomeController.text.trim();
    final data = _dataController.text.trim();

    if (nome.isEmpty || data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe o nome de quem está retirando!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    widget.onConfirmar(
      itemId: widget.item.id,
      nomeRetirante: nome,
      dataDevolucao: data,
    );

    Navigator.pop(context);
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Devolver item perdido',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.image, size: 30, color: Colors.grey.shade600),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.titulo,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(
                          '• ${widget.item.dataRegistro}',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                        Text(
                          '• ${widget.item.local}',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            const Text('Nome de quem está retirando', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                hintText: 'Ex.: Ana Julia Mesquita',
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 14),

            const Text('Data', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: _dataController,
              readOnly: true,
              onTap: _selecionarData,
              decoration: InputDecoration(
                hintText: 'Ex.: 03/11/2026',
                filled: true,
                fillColor: Colors.grey.shade100,
                suffixIcon: const Icon(Icons.calendar_today_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _confirmarDevolucao,
                child: const Text(
                  'Devolver',
                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
