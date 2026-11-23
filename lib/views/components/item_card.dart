import 'package:flutter/material.dart';
import '../../models/item_model.dart';

class ItemCard extends StatelessWidget {
  final ItemModel item;
  final VoidCallback onTap;
  final VoidCallback onBotaoAcao;

  const ItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onBotaoAcao,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap, // Clicar em qualquer parte do card abre os detalhes
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Foto do item (com suporte a imagem do Supabase Storage)
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: item.imagemUrl != null && item.imagemUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          item.imagemUrl!,
                          width: 75,
                          height: 75,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.broken_image_outlined,
                            size: 34,
                            color: Colors.grey.shade400,
                          ),
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.image_outlined,
                        size: 38,
                        color: Colors.grey.shade500,
                      ),
              ),
              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.titulo,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '• ${item.dataRegistroFormatada}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      '• ${item.local}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),

                    if (item.foiDevolvido) ...[
                      const SizedBox(height: 2),
                      Text(
                        '• ${item.dataDevolucaoFormatada ?? ""}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Text(
                        '• ${item.nomeRetirante ?? ""}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              if (!item.foiDevolvido)
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey.shade700,
                    side: BorderSide(color: Colors.grey.shade400),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    minimumSize: Size.zero,
                  ),
                  onPressed: onBotaoAcao,
                  child: const Text('Devolver', style: TextStyle(fontSize: 13)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
