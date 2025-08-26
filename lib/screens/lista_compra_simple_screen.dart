import 'package:flutter/material.dart';
import '../models/item_compra.dart';
import '../services/local_storage_service.dart';
import 'perfil_usuario_screen.dart';

class ListaCompraSimpleScreen extends StatefulWidget {
  const ListaCompraSimpleScreen({super.key});

  @override
  State<ListaCompraSimpleScreen> createState() =>
      _ListaCompraSimpleScreenState();
}

class _ListaCompraSimpleScreenState extends State<ListaCompraSimpleScreen> {
  final LocalStorageService _storageService = LocalStorageService();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantidadeController = TextEditingController();
  final TextEditingController _observacaoController = TextEditingController();

  List<ItemCompra> _itens = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarItens();
  }

  @override
  void dispose() {
    _itemController.dispose();
    _quantidadeController.dispose();
    _observacaoController.dispose();
    super.dispose();
  }

  Future<void> _carregarItens() async {
    setState(() => _isLoading = true);
    try {
      final itens = await _storageService.carregarItens();
      setState(() {
        _itens = itens;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar itens: $e')),
        );
      }
    }
  }

  void _mostrarDialogoAdicionarItem() {
    _itemController.clear();
    _quantidadeController.text = '1';
    _observacaoController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _itemController,
              decoration: const InputDecoration(
                labelText: 'Nome do item',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _quantidadeController,
              decoration: const InputDecoration(
                labelText: 'Quantidade',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _observacaoController,
              decoration: const InputDecoration(
                labelText: 'Observação (opcional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_itemController.text.isNotEmpty) {
                _adicionarItem();
                Navigator.of(context).pop();
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  Future<void> _adicionarItem() async {
    final item = ItemCompra(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nome: _itemController.text.trim(),
      quantidade: int.tryParse(_quantidadeController.text) ?? 1,
      dataCriacao: DateTime.now(),
      observacao: _observacaoController.text.trim().isEmpty
          ? null
          : _observacaoController.text.trim(),
    );

    await _storageService.adicionarItem(item);
    await _carregarItens();
  }

  Future<void> _alternarStatusCompra(ItemCompra item) async {
    final itemAtualizado = item.copyWith(comprado: !item.comprado);
    await _storageService.atualizarItem(itemAtualizado);
    await _carregarItens();
  }

  Future<void> _deletarItem(String itemId) async {
    await _storageService.deletarItem(itemId);
    await _carregarItens();
  }

  void _mostrarDialogoLimparLista() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar Lista'),
        content: const Text('Tem certeza que deseja limpar toda a lista?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _storageService.limparLista();
              Navigator.of(context).pop();
              await _carregarItens();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Limpar'),
          ),
        ],
      ),
    );
  }

  void _abrirPerfilUsuario() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PerfilUsuarioScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compra'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: _abrirPerfilUsuario,
            icon: const Icon(Icons.person),
            tooltip: 'Perfil do usuário',
          ),
          IconButton(
            onPressed: _mostrarDialogoLimparLista,
            icon: const Icon(Icons.clear_all),
            tooltip: 'Limpar lista',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _itens.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Sua lista está vazia',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Toque no + para adicionar itens',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _itens.length,
                  itemBuilder: (context, index) {
                    final item = _itens[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      child: ListTile(
                        leading: Checkbox(
                          value: item.comprado,
                          onChanged: (_) => _alternarStatusCompra(item),
                        ),
                        title: Text(
                          item.nome,
                          style: TextStyle(
                            decoration: item.comprado
                                ? TextDecoration.lineThrough
                                : null,
                            color: item.comprado ? Colors.grey : null,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Quantidade: ${item.quantidade}'),
                            if (item.observacao != null)
                              Text(
                                'Obs: ${item.observacao}',
                                style: const TextStyle(fontStyle: FontStyle.italic),
                              ),
                          ],
                        ),
                        trailing: IconButton(
                          onPressed: () => _deletarItem(item.id),
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: 'Deletar item',
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialogoAdicionarItem,
        tooltip: 'Adicionar item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
