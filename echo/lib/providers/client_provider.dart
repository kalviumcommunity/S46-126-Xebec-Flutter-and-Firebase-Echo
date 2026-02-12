import 'dart:async';

import 'package:flutter/material.dart';

import '../models/client_model.dart';
import '../services/firestore_service.dart';

class ClientProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<ClientModel> _clients = [];
  StreamSubscription<List<ClientModel>>? _subscription;
  bool _isLoading = false;
  String? _errorMessage;

  List<ClientModel> get clients => _clients;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void listenToClients(String userId) {
    _isLoading = true;
    notifyListeners();

    _subscription?.cancel();
    _subscription = _firestoreService.getClientsStream(userId).listen(
      (items) {
        _clients = items;
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = error.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<bool> addClient({
    required String userId,
    required String name,
    required String email,
    required String phone,
    required String company,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firestoreService.addClient(
        userId: userId,
        name: name,
        email: email,
        phone: phone,
        company: company,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteClient({
    required String userId,
    required String clientId,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firestoreService.deleteClient(userId, clientId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
