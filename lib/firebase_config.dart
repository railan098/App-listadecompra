import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig {
  static Future<void> initializeFirebase() async {
    try {
      // Configuração básica do Firebase para desenvolvimento
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyBXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
          appId: '1:123456789012:web:abcdefghijklmnop',
          messagingSenderId: '123456789012',
          projectId: 'listadecompra-f8ffe',
          authDomain: 'listadecompra-f8ffe.firebaseapp.com',
          storageBucket: 'listadecompra-f8ffe.appspot.com',
        ),
      );
      print('✅ Firebase inicializado com sucesso!');
    } catch (e) {
      print('❌ Erro ao inicializar Firebase: $e');
      // Fallback para configuração básica
      await Firebase.initializeApp();
      print('⚠️ Firebase inicializado com configuração padrão');
    }
  }
}
