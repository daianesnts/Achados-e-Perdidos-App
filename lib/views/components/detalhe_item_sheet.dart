import 'package:flutter/material.dart';
import '../../models/item_model.dart';

class DetalheItemSheet extends StatelessWidget {
  final ItemModel item;
  final VoidCallback onDevolver;

  const DetalheItemSheet({
    super.key,
    required this.item,
    required this.onDevolver,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBannerImagem(),
          const SizedBox(height: 16),
          _buildHeaderComStatus(),
          const SizedBox(height: 12),
          _buildDadosRegistro(),
          if (item.foiDevolvido) ...[
            const SizedBox(height: 12),
            _buildInfoDevolucao(),
          ],
          const SizedBox(height: 24),
          if (!item.foiDevolvido) _buildBotaoDevolver(context),
        ],
      ),
    );
  }

  Widget _buildBannerImagem() {
    // Banner com Imagem (carrega do Supabase Storage se disponível)
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        height: 200,
        color: Colors.grey.shade200,
        child: item.imagemUrl != null && item.imagemUrl!.isNotEmpty
            ? Image.network(
                item.imagemUrl!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image_outlined,
                          size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 4),
                      Text(
                        'Não foi possível carregar a imagem',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  );
                },
              )
            : Icon(
                Icons.image_outlined,
                size: 80,
                color: Colors.grey.shade400,
              ),
      ),
    );
  }

  Widget _buildHeaderComStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            item.titulo,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: item.foiDevolvido
                ? const Color(0xFFE0E7FF)
                : Colors.orange.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            item.foiDevolvido ? 'Devolvido' : 'Perdido',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: item.foiDevolvido
                  ? const Color(0xFF1E3A8A)
                  : Colors.orange.shade900,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDadosRegistro() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• Data de registro: ${item.dataRegistroFormatada}',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
        ),
        const SizedBox(height: 4),
        Text(
          '• Local encontrado: ${item.local}',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
        ),
      ],
    );
  }

  Widget _buildInfoDevolucao() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 8),
        Text(
          'Informações de Devolução',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '• Retirado por: ${item.nomeRetirante ?? ""}',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
        ),
        const SizedBox(height: 4),
        Text(
          '• Data da entrega: ${item.dataDevolucaoFormatada ?? ""}',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
        ),
      ],
    );
  }

  Widget _buildBotaoDevolver(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E3A8A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          Navigator.pop(context); // Fecha o modal de detalhes
          onDevolver(); // Abre o modal de devolução
        },
        icon: const Icon(Icons.assignment_return, color: Colors.white),
        label: const Text(
          'Registrar Devolução',
          style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
