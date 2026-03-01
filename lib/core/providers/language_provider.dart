import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';

const String _languageKey = 'language';

class LanguageNotifier extends StateNotifier<Locale> {
  LanguageNotifier() : super(const Locale('ar')) {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final savedLang = await StorageService.getData(_languageKey);
    if (savedLang != null && savedLang.isNotEmpty) {
      state = Locale(savedLang);
    }
  }

  Future<void> setLanguage(String languageCode) async {
    state = Locale(languageCode);
    await StorageService.saveData(_languageKey, languageCode);
  }
}

final languageProvider =
    StateNotifierProvider<LanguageNotifier, Locale>((ref) {
  return LanguageNotifier();
});
