import 'package:flutter/material.dart';
import '../models/item_compra.dart';
import '../services/firebase_service.dart';
import '../services/auth_service.dart';

class ListaCompraScreen extends StatefulWidget {
  const ListaCompraScreen({super.key});

  @override
  State<ListaCompraScreen> createState() => _ListaCompraScreenState();
}

class _ListaCompraScreenState extends State<ListaCompraScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final AuthService _authService = AuthService();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantidadeController = TextEditingController();
  final TextEditingController _observacaoController = TextEditingController();

  @override
  void dispose() {
    _itemController.dispose();
    _quantidadeController.dispose();
    _observacaoController.dispose();
    super.dispose();
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

  void _adicionarItem() {
    final item = ItemCompra(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nome: _itemController.text.trim(),
      quantidade: int.tryParse(_quantidadeController.text) ?? 1,
      dataCriacao: DateTime.now(),
      observacao: _observacaoController.text.trim().isEmpty
          ? null
          : _observacaoController.text.trim(),
    );

    _firebaseService.adicionarItem(item);
  }

  void _alternarStatusCompra(ItemCompra item) {
    _firebaseService.alternarStatusCompra(item.id, !item.comprado);
  }

  void _deletarItem(String itemId) {
    _firebaseService.deletarItem(itemId);
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
            onPressed: () {
              _firebaseService.limparLista();
              Navigator.of(context).pop();
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

  Future<void> _logout() async {
    try {
      await _authService.logout();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro no logout: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compra'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: _mostrarDialogoLimparLista,
            icon: const Icon(Icons.clear_all),
            tooltip: 'Limpar lista',
          ),
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: StreamBuilder<List<ItemCompra>>(
        stream: _firebaseService.getItensCompra(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Erro: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final itens = snapshot.data!;

          if (itens.isEmpty) {
            return const Center(
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
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: itens.length,
            itemBuilder: (context, index) {
              final item = itens[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
