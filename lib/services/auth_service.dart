import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _currentUserId;
  String? _currentUserName;

  bool get isAuthenticated => _isAuthenticated;
  String? get currentUserId => _currentUserId;
  String? get currentUserName => _currentUserName;

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    _currentUserId = prefs.getString('userId');
    _currentUserName = prefs.getString('userName');
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    // Simulação de login (substituir por API real)
    if (email.isNotEmpty && password.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', true);
      await prefs.setString('userId', '1');
      await prefs.setString('userName', 'Vendedor');
      
      _isAuthenticated = true;
      _currentUserId = '1';
      _currentUserName = 'Vendedor';
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    _isAuthenticated = false;
    _currentUserId = null;
    _currentUserName = null;
    notifyListeners();
  }
}
