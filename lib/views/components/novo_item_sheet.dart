import 'package:flutter/material.dart';

class NovoItemSheet extends StatefulWidget {
  final Function({
    required String titulo,
    required String dataRegistro,
    required String local,
  }) onSalvar;

  const NovoItemSheet({super.key, required this.onSalvar});

  @override
  State<NovoItemSheet> createState() => _NovoItemSheetState();
}

class _NovoItemSheetState extends State<NovoItemSheet> {
  final _tituloController = TextEditingController();
  final _dataController = TextEditingController();
  final _localController = TextEditingController();

  @override
  void dispose() {
    _tituloController.dispose();
    _dataController.dispose();
    _localController.dispose();
    super.dispose();
  }

  // Abre o seletor de data padrão do Flutter
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

  void _salvar() {
    final titulo = _tituloController.text.trim();
    final data = _dataController.text.trim();
    final local = _localController.text.trim();

    if (titulo.isEmpty || data.isEmpty || local.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    widget.onSalvar(
      titulo: titulo,
      dataRegistro: data,
      local: local,
    );

    Navigator.pop(context); 
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
            const Text(
              'Registrar novo item perdido',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),

            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.image_outlined, size: 48, color: Colors.grey.shade500),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1E3A8A),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.cloud_upload, size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text('Título', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: _tituloController,
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
            const SizedBox(height: 14),

            const Text('Data', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: _dataController,
              readOnly: true,
              onTap: _selecionarData,
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
            const SizedBox(height: 14),

            const Text('Local', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: _localController,
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
                onPressed: _salvar,
                child: const Text(
                  'Salvar',
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
