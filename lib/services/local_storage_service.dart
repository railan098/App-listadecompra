import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item_compra.dart';

class LocalStorageService {
  static const String _key = 'lista_compra_items';

  // Salvar itens localmente
  Future<void> salvarItens(List<ItemCompra> itens) async {
    final prefs = await SharedPreferences.getInstance();
    final itensJson = itens.map((item) => item.toMap()).toList();
    await prefs.setString(_key, jsonEncode(itensJson));
  }

  // Carregar itens salvos
  Future<List<ItemCompra>> carregarItens() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final itensString = prefs.getString(_key);

      if (itensString == null || itensString.isEmpty) {
        return [];
      }

      final itensJson = jsonDecode(itensString) as List;
      return itensJson
          .map(
            (itemJson) => ItemCompra.fromMap(itemJson as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      print('Erro ao carregar itens: $e');
      return [];
    }
  }

  // Adicionar item
  Future<void> adicionarItem(ItemCompra item) async {
    final itens = await carregarItens();
    itens.add(item);
    await salvarItens(itens);
  }

  // Atualizar item
  Future<void> atualizarItem(ItemCompra item) async {
    final itens = await carregarItens();
    final index = itens.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      itens[index] = item;
      await salvarItens(itens);
    }
  }

  // Deletar item
  Future<void> deletarItem(String itemId) async {
    final itens = await carregarItens();
    itens.removeWhere((item) => item.id == itemId);
    await salvarItens(itens);
  }

  // Limpar lista
  Future<void> limparLista() async {
    await salvarItens([]);
  }
}
