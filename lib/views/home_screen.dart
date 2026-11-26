import 'dart:typed_data';
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
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _carregarItens();
  }

  // Carrega os itens do Supabase
  Future<void> _carregarItens() async {
    setState(() => _carregando = true);
    try {
      await _itemService.carregarItens();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar dados do Supabase: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _carregando = false);
      }
    }
  }

  void _abrirModalNovoItem() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (novoContext) {
        return NovoItemSheet(
          onSalvar: ({
            required String titulo,
            required String dataRegistro,
            required String local,
            Uint8List? imagemBytes,
          }) async {
            await _itemService.adicionarItem(
              titulo: titulo,
              dataRegistro: dataRegistro,
              local: local,
              imagemBytes: imagemBytes,
            );

            setState(() {});

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Item cadastrado com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
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
      builder: (novoContext) {
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
      builder: (novoContext) {
        return DevolverSheet(
          item: item,
          onConfirmar: ({
            required int itemId,
            required String nomeRetirante,
            required String dataDevolucao,
          }) async {
            await _itemService.registrarDevolucao(
              itemId: itemId,
              nomeRetirante: nomeRetirante,
              dataDevolucao: dataDevolucao,
            );

            setState(() {});

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Devolução registrada com sucesso!'),
                  backgroundColor: Colors.blue,
                ),
              );
            }
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
      appBar: _buildAppBar(),
      body: Column(
        children: [
          const SizedBox(height: 8),
          _buildSeletorDeAbas(),
          const SizedBox(height: 12),
          Expanded(
            child: _carregando && listaAtual.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _carregarItens,
                    child: _buildLista(listaAtual),
                  ),
          ),
        ],
      ),
      floatingActionButton: _buildBotaoNovoItem(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
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
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Color(0xFF1E3A8A)),
          tooltip: 'Atualizar',
          onPressed: _carregando ? null : _carregarItens,
        ),
      ],
    );
  }

  Widget _buildSeletorDeAbas() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _buildBotaoAba(indice: 0, texto: 'Perdidos')),
          const SizedBox(width: 12),
          Expanded(child: _buildBotaoAba(indice: 1, texto: 'Devolvidos')),
        ],
      ),
    );
  }

  Widget _buildBotaoAba({required int indice, required String texto}) {
    final selecionado = _abaSelecionada == indice;

    return SizedBox(
      height: 44,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: selecionado ? const Color(0xFF90CAF9) : Colors.white,
          foregroundColor:
              selecionado ? const Color(0xFF0D47A1) : Colors.grey.shade600,
          elevation: 0,
          side: BorderSide(
            color: selecionado ? Colors.transparent : Colors.grey.shade400,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => setState(() => _abaSelecionada = indice),
        icon: selecionado
            ? const Icon(Icons.check, size: 18)
            : const SizedBox.shrink(),
        label: Text(
          texto,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildLista(List<ItemModel> itens) {
    if (itens.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.25),
          Center(
            child: Text(
              _abaSelecionada == 0
                  ? 'Nenhum item perdido no momento.'
                  : 'Nenhum item foi devolvido ainda.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: itens.length,
      itemBuilder: (context, index) {
        final item = itens[index];
        return ItemCard(
          item: item,
          onTap: () => _abrirModalDetalhes(item),
          onBotaoAcao: () => item.foiDevolvido
              ? _abrirModalDetalhes(item)
              : _abrirModalDevolucao(item),
        );
      },
    );
  }

  Widget? _buildBotaoNovoItem() {
    if (_abaSelecionada != 0) return null;

    return FloatingActionButton.extended(
      backgroundColor: const Color(0xFF1E3A8A),
      foregroundColor: Colors.white,
      onPressed: _abrirModalNovoItem,
      icon: const Icon(Icons.add),
      label: const Text(
        'Novo item',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
