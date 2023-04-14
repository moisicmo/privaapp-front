import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService extends ChangeNotifier {
  final storage = const FlutterSecureStorage();

  Future loginCustomer(String token) async {
    await storage.write(key: 'accessToken', value: token);
    return;
  }

  Future registerPassword(String password) async {
    await storage.write(key: 'password', value: password);
    return;
  }

  Future logout() async {
    await storage.delete(key: 'accessToken');
    await storage.delete(key: 'refreshToken');
    return;
  }

  static Future<String> readAccessToken() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'accessToken') ?? '';
    return token;
  }

  Future<String> readCredentialNit() async {
    return await storage.read(key: 'nit') ?? '';
  }

  Future<String> readCredentialUser() async {
    return await storage.read(key: 'user') ?? '';
  }

  Future<String> readCredentialPassword() async {
    return await storage.read(key: 'password') ?? '';
  }
}
