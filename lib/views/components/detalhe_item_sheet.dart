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
          // Banner com Imagem ilustrativa grande
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              height: 180,
              color: Colors.grey.shade200,
              child: Icon(
                Icons.image,
                size: 80,
                color: Colors.grey.shade400,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Título e Tag de Status
          Row(
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
          ),
          const SizedBox(height: 12),

          Text(
            '• Data de registro: ${item.dataRegistro}',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
          ),
          const SizedBox(height: 4),
          Text(
            '• Local encontrado: ${item.local}',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
          ),

          if (item.foiDevolvido) ...[
            const SizedBox(height: 4),
            Text(
              '• Data de devolução: ${item.dataDevolucao ?? ""}',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
            ),
            const SizedBox(height: 4),
            Text(
              '• Retirado por: ${item.nomeRetirante ?? ""}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A8A),
              ),
            ),
          ],

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: item.foiDevolvido
                    ? Colors.grey.shade300
                    : const Color(0xFF1E3A8A),
                foregroundColor: item.foiDevolvido
                    ? Colors.black87
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context); 
                if (!item.foiDevolvido) {
                  onDevolver(); 
                }
              },
              child: Text(
                item.foiDevolvido ? 'Fechar' : 'Devolver',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
