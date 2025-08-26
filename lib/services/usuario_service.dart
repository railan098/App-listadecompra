import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/usuario.dart';

class UsuarioService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obter usuário atual
  User? get currentUser => _auth.currentUser;

  // Stream dos dados do usuário
  Stream<Usuario?> get usuarioStream {
    if (currentUser == null) return Stream.value(null);
    
    return _firestore
        .collection('usuarios')
        .doc(currentUser!.uid)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return Usuario.fromMap(doc.data()!);
      }
      return null;
    });
  }

  // Obter dados do usuário uma vez
  Future<Usuario?> getUsuario() async {
    if (currentUser == null) return null;

    try {
      final doc =
          await _firestore.collection('usuarios').doc(currentUser!.uid).get();

      if (doc.exists) {
        final data = doc.data()!;
        data['id'] = doc.id;
        return Usuario.fromMap(data);
      }
      return null;
    } catch (e) {
      print('Erro ao obter usuário: $e');
      return null;
    }
  }

  // Salvar dados do usuário
  Future<void> salvarUsuario(Usuario usuario) async {
    if (currentUser == null) return;

    try {
      await _firestore
          .collection('usuarios')
          .doc(currentUser!.uid)
          .set(usuario.toMap());
      print('✅ Usuário salvo com sucesso!');
    } catch (e) {
      print('❌ Erro ao salvar usuário: $e');
      throw Exception('Erro ao salvar usuário: $e');
    }
  }

  // Atualizar dados do usuário
  Future<void> atualizarUsuario(Usuario usuario) async {
    if (currentUser == null) return;

    try {
      final usuarioAtualizado = usuario.copyWith(
        ultimaAtualizacao: DateTime.now(),
      );

      await _firestore
          .collection('usuarios')
          .doc(currentUser!.uid)
          .update(usuarioAtualizado.toMap());
      print('✅ Usuário atualizado com sucesso!');
    } catch (e) {
      print('❌ Erro ao atualizar usuário: $e');
      throw Exception('Erro ao atualizar usuário: $e');
    }
  }

  // Criar ou atualizar usuário
  Future<void> criarOuAtualizarUsuario({
    required String uid,
    required String nome,
    required String email,
  }) async {
    if (currentUser == null) return;

    final usuarioRef = _firestore.collection('usuarios').doc(uid);
    final doc = await usuarioRef.get();

    if (!doc.exists) {
      // Criar novo usuário
      final novoUsuario = Usuario(
        id: uid,
        nome: nome,
        email: email,
        dataCriacao: DateTime.now(),
        ultimaAtualizacao: DateTime.now(),
      );
      await usuarioRef.set(novoUsuario.toMap());
    } else {
      // Atualizar usuário existente
      await usuarioRef.update({
        'nome': nome,
        'ultimaAtualizacao': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  // Deletar usuário
  Future<void> deletarUsuario(String uid) async {
    if (currentUser == null) return;
    
    await _firestore.collection('usuarios').doc(uid).delete();
  }

  // Verificar se usuário existe
  Future<bool> usuarioExiste() async {
    if (currentUser == null) return false;

    try {
      final doc =
          await _firestore.collection('usuarios').doc(currentUser!.uid).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }
}
