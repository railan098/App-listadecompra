import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/item_compra.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obter usuário atual
  User? get currentUser => _auth.currentUser;

  // Stream de itens da lista de compra
  Stream<List<ItemCompra>> getItensCompra() {
    if (currentUser == null) return Stream.value([]);
    
    return _firestore
        .collection('usuarios')
        .doc(currentUser!.uid)
        .collection('lista_compra')
        .orderBy('dataCriacao', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return ItemCompra.fromMap(data);
          }).toList();
        });
  }

  // Adicionar item à lista
  Future<void> adicionarItem(ItemCompra item) async {
    if (currentUser == null) return;

    await _firestore
        .collection('usuarios')
        .doc(currentUser!.uid)
        .collection('lista_compra')
        .add(item.toMap());
  }

  // Atualizar item
  Future<void> atualizarItem(ItemCompra item) async {
    if (currentUser == null) return;

    await _firestore
        .collection('usuarios')
        .doc(currentUser!.uid)
        .collection('lista_compra')
        .doc(item.id)
        .update(item.toMap());
  }

  // Deletar item
  Future<void> deletarItem(String itemId) async {
    if (currentUser == null) return;

    await _firestore
        .collection('usuarios')
        .doc(currentUser!.uid)
        .collection('lista_compra')
        .doc(itemId)
        .delete();
  }

  // Marcar item como comprado/não comprado
  Future<void> alternarStatusCompra(String itemId, bool comprado) async {
    if (currentUser == null) return;

    await _firestore
        .collection('usuarios')
        .doc(currentUser!.uid)
        .collection('lista_compra')
        .doc(itemId)
        .update({'comprado': comprado});
  }

  // Limpar lista completa
  Future<void> limparLista() async {
    if (currentUser == null) return;

    final snapshot = await _firestore
        .collection('usuarios')
        .doc(currentUser!.uid)
        .collection('lista_compra')
        .get();

    final batch = _firestore.batch();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
