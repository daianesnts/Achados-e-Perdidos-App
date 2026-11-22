import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../services/item_service.dart';
import 'components/item_card.dart';
import 'components/novo_item_sheet.dart';
import 'components/detalhe_item_sheet.dart';
import 'components/devolver_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ItemService _itemService = ItemService();

  int _abaSelecionada = 0;

  void _abrirModalNovoItem() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return NovoItemSheet(
          onSalvar: ({
            required String titulo,
            required String dataRegistro,
            required String local,
          }) {
            setState(() {
              _itemService.adicionarItem(
                titulo: titulo,
                dataRegistro: dataRegistro,
                local: local,
              );
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Item cadastrado com sucesso!'),
                backgroundColor: Colors.green,
              ),
            );
          },
        );
      },
    );
  }

  void _abrirModalDetalhes(ItemModel item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DetalheItemSheet(
          item: item,
          onDevolver: () {
            _abrirModalDevolucao(item);
          },
        );
      },
    );
  }

  void _abrirModalDevolucao(ItemModel item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DevolverSheet(
          item: item,
          onConfirmar: ({
            required String itemId,
            required String nomeRetirante,
            required String dataDevolucao,
          }) {
            setState(() {
              _itemService.registrarDevolucao(
                itemId: itemId,
                nomeRetirante: nomeRetirante,
                dataDevolucao: dataDevolucao,
              );
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Devolução registrada com sucesso!'),
                backgroundColor: Colors.blue,
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final listaAtual = _abaSelecionada == 0
        ? _itemService.itensPerdidos
        : _itemService.itensDevolvidos;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Achados e Perdidos',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),

          // Botões de alternância no topo 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Botão "Perdidos"
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _abaSelecionada == 0
                            ? const Color(0xFF90CAF9)
                            : Colors.white,
                        foregroundColor: _abaSelecionada == 0
                            ? const Color(0xFF0D47A1)
                            : Colors.grey.shade600,
                        elevation: 0,
                        side: BorderSide(
                          color: _abaSelecionada == 0
                              ? Colors.transparent
                              : Colors.grey.shade400,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _abaSelecionada = 0;
                        });
                      },
                      icon: _abaSelecionada == 0
                          ? const Icon(Icons.check, size: 18)
                          : const SizedBox.shrink(),
                      label: const Text(
                        'Perdidos',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Botão "Devolvidos"
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _abaSelecionada == 1
                            ? const Color(0xFF90CAF9)
                            : Colors.white,
                        foregroundColor: _abaSelecionada == 1
                            ? const Color(0xFF0D47A1)
                            : Colors.grey.shade600,
                        elevation: 0,
                        side: BorderSide(
                          color: _abaSelecionada == 1
                              ? Colors.transparent
                              : Colors.grey.shade400,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _abaSelecionada = 1;
                        });
                      },
                      icon: _abaSelecionada == 1
                          ? const Icon(Icons.check, size: 18)
                          : const SizedBox.shrink(),
                      label: const Text(
                        'Devolvidos',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: listaAtual.isEmpty
                ? Center(
                    child: Text(
                      _abaSelecionada == 0
                          ? 'Nenhum item perdido no momento.'
                          : 'Nenhum item foi devolvido ainda.',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: listaAtual.length,
                    itemBuilder: (context, index) {
                      final item = listaAtual[index];
                      return ItemCard(
                        item: item,
                        onTap: () => _abrirModalDetalhes(item),
                        onBotaoAcao: () {
                          if (!item.foiDevolvido) {
                            _abrirModalDevolucao(item);
                          } else {
                            _abrirModalDetalhes(item);
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),

      // Botão Flutuante de Novo Item (só aparece se estiver na aba de Perdidos)
      floatingActionButton: _abaSelecionada == 0
          ? FloatingActionButton.extended(
              backgroundColor: const Color(0xFF1E3A8A),
              foregroundColor: Colors.white,
              onPressed: _abrirModalNovoItem,
              icon: const Icon(Icons.add),
              label: const Text(
                'Novo item',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          : null,
    );
  }
}
