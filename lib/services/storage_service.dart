import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();

  // Obter usuário atual
  User? get currentUser => _auth.currentUser;

  // Selecionar imagem da galeria
  Future<File?> selecionarImagem() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('❌ Erro ao selecionar imagem: $e');
      return null;
    }
  }

  // Fazer upload da imagem para o Firebase Storage
  Future<String?> fazerUploadImagem(File imageFile, String itemId) async {
    if (currentUser == null) return null;

    try {
      // Criar referência para o arquivo
      final storageRef = _storage
          .ref()
          .child('usuarios')
          .child(currentUser!.uid)
          .child('lista_compra')
          .child('$itemId.jpg');

      // Fazer upload
      final uploadTask = storageRef.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'userId': currentUser!.uid,
            'itemId': itemId,
            'uploadDate': DateTime.now().toIso8601String(),
          },
        ),
      );

      // Aguardar conclusão
      final snapshot = await uploadTask;

      // Obter URL de download
      final downloadUrl = await snapshot.ref.getDownloadURL();

      print('✅ Imagem enviada com sucesso!');
      print('📁 URL: $downloadUrl');

      return downloadUrl;
    } catch (e) {
      print('❌ Erro ao fazer upload da imagem: $e');
      return null;
    }
  }

  // Deletar imagem do Firebase Storage
  Future<bool> deletarImagem(String imageUrl) async {
    try {
      // Extrair caminho da URL
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();

      print('✅ Imagem deletada com sucesso!');
      return true;
    } catch (e) {
      print('❌ Erro ao deletar imagem: $e');
      return false;
    }
  }

  // Verificar se a URL é válida
  bool isUrlValida(String? url) {
    if (url == null || url.isEmpty) return false;
    return url.startsWith('http://') || url.startsWith('https://');
  }

  // Obter tamanho do arquivo em formato legível
  String formatarTamanhoArquivo(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
