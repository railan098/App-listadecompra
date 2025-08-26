import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Configurar Google Sign-In (sem clientId para Android)
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // NO ANDROID: Não precisa de clientId (usa google-services.json)
    // NO WEB: Precisa de clientId no meta tag
    scopes: [
      'email',
      'profile',
    ],
  );

  // Obter usuário atual
  User? get currentUser => _auth.currentUser;

  // Stream de mudanças de autenticação
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Login com email e senha
  Future<UserCredential> loginComEmailSenha(String email, String senha) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
      print('✅ Login com email realizado com sucesso!');
      print('👤 Usuário: ${userCredential.user?.email}');
      return userCredential;
    } catch (e) {
      print('❌ Erro no login com email: $e');
      rethrow;
    }
  }

  // Criar conta com email e senha
  Future<UserCredential> criarConta(String email, String senha) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
      print('✅ Conta criada com sucesso!');
      print('👤 Usuário: ${userCredential.user?.email}');
      return userCredential;
    } catch (e) {
      print('❌ Erro ao criar conta: $e');
      rethrow;
    }
  }

  // Login com Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      print('🔄 Iniciando login com Google...');

      // Iniciar processo de login do Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print('❌ Usuário cancelou o login do Google');
        return null;
      }

      print('✅ Conta Google selecionada: ${googleUser.email}');

      // Obter credenciais de autenticação
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print('🔑 Credenciais Google obtidas');

      // Criar credencial do Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('🔥 Criando credencial Firebase...');

      // Fazer login no Firebase
      final userCredential = await _auth.signInWithCredential(credential);

      print('✅ Login com Google realizado com sucesso!');
      print('👤 Usuário: ${userCredential.user?.displayName}');
      print('📧 Email: ${userCredential.user?.email}');
      print('🆔 UID: ${userCredential.user?.uid}');

      return userCredential;
    } catch (e) {
      print('❌ Erro no login com Google: $e');
      print('🔍 Tipo de erro: ${e.runtimeType}');

      // Se for erro de People API, mostrar mensagem específica
      if (e.toString().contains('People API') ||
          e.toString().contains('403') ||
          e.toString().contains('PERMISSION_DENIED')) {
        print('⚠️ People API não habilitada. Habilite em:');
        print(
            'https://console.developers.google.com/apis/api/people.googleapis.com/overview?project=280843036910');
        throw Exception(
            'Google Sign-In requer People API habilitada. Acesse o console do Google Cloud para habilitar.');
      }

      rethrow;
    }
  }

  // Login anônimo direto (para testes)
  Future<UserCredential?> loginAnonimo() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      print('✅ Login anônimo realizado com sucesso!');
      return userCredential;
    } catch (e) {
      print('❌ Erro no login anônimo: $e');
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
      print('✅ Logout realizado com sucesso!');
    } catch (e) {
      print('❌ Erro ao fazer logout: $e');
      rethrow;
    }
  }

  // Verificar se usuário está logado
  bool get isLoggedIn => _auth.currentUser != null;

  // Obter informações do usuário
  Map<String, String?> get userInfo {
    final user = _auth.currentUser;
    if (user == null) return {};

    return {
      'uid': user.uid,
      'displayName': user.displayName ?? 'Usuário Anônimo',
      'email': user.email,
      'photoURL': user.photoURL,
      'isAnonymous': user.isAnonymous.toString(),
    };
  }
}
