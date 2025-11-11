import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Instância do Firebase Auth para usar em toda a classe
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Método para criar um usuário com e-mail e senha
  Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Usa o método do FirebaseAuth para criar o usuário
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      // Retorna o usuário criado se for bem-sucedido
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Se ocorrer um erro do Firebase (ex: e-mail já em uso), imprime o erro
      print('Erro no cadastro: ${e.message}');
      // Retorna nulo para indicar que houve um erro
      return null;
    } catch (e) {
      // Para qualquer outro tipo de erro
      print('Ocorreu um erro inesperado: $e');
      return null;
    }
  }

  // Método para fazer login com e-mail e senha
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Usa o método do FirebaseAuth para fazer o login
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      // Retorna o usuário se o login for bem-sucedido
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Se ocorrer um erro (ex: senha incorreta, usuário não encontrado), imprime o erro
      print('Erro no login: ${e.message}');
      // Retorna nulo para indicar que houve um erro
      return null;
    } catch (e) {
      // Para qualquer outro tipo de erro
      print('Ocorreu um erro inesperado: $e');
      return null;
    }
  }

  // Método para fazer logout
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
