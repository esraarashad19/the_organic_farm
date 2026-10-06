import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api_constants.dart';
import '../models/models.dart';

final sessionProvider = NotifierProvider<SessionController, SessionState>(
  SessionController.new,
);

class SessionState {
  const SessionState({
    this.token,
    this.user,
    this.locale = const Locale('en'),
    this.ready = false,
    this.hasChosenLanguage = false,
  });

  final String? token;
  final User? user;
  final Locale locale;
  final bool ready;
  final bool hasChosenLanguage;

  bool get isLoggedIn => (token ?? '').isNotEmpty;
  bool get isArabic => locale.languageCode == 'ar';

  SessionState copyWith({
    String? token,
    User? user,
    Locale? locale,
    bool? ready,
    bool? hasChosenLanguage,
    bool clearUser = false,
    bool clearToken = false,
  }) {
    return SessionState(
      token: clearToken ? null : (token ?? this.token),
      user: clearUser ? null : (user ?? this.user),
      locale: locale ?? this.locale,
      ready: ready ?? this.ready,
      hasChosenLanguage: hasChosenLanguage ?? this.hasChosenLanguage,
    );
  }
}

class SessionController extends Notifier<SessionState> {
  SharedPreferences? _prefs;

  @override
  SessionState build() => const SessionState();

  Future<void> restore() async {
    _prefs ??= await SharedPreferences.getInstance();
    final token = _prefs!.getString(StorageKeys.token);
    User? user;
    final raw = _prefs!.getString(StorageKeys.fullUser);
    if (raw != null && raw.isNotEmpty) {
      try {
        user = User.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      } catch (_) {}
    }

    Locale locale = const Locale('en');
    final storedLang = _prefs!.getString(StorageKeys.language);
    final hasChosenLanguage = storedLang == 'ar' || storedLang == 'en';
    if (storedLang == 'ar') {
      locale = const Locale('ar');
    }

    state = SessionState(
      token: token,
      user: user,
      locale: locale,
      ready: true,
      hasChosenLanguage: hasChosenLanguage,
    );
  }

  Future<void> cacheUser(User user) async {
    _prefs ??= await SharedPreferences.getInstance();
    if (user.token != null && user.token!.isNotEmpty) {
      await _prefs!.setString(StorageKeys.token, user.token!);
    }
    await _prefs!.setString(StorageKeys.fullUser, jsonEncode(user.toJson()));
    state = state.copyWith(token: user.token ?? state.token, user: user);
  }

  Future<void> setLanguage(Locale locale) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setString(StorageKeys.language, locale.languageCode);
    await _prefs!.setBool(StorageKeys.firstTimeLanguage, true);
    state = state.copyWith(locale: locale, hasChosenLanguage: true);
  }

  Future<void> logout() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.remove(StorageKeys.token);
    await _prefs!.remove(StorageKeys.fullUser);
    state = state.copyWith(clearToken: true, clearUser: true);
  }
}
