import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_domain/core_domain.dart';
import 'package:core_phone/core_phone.dart';
import 'package:match_engine/match_engine.dart';
import 'package:sink_phonebook/sink_phonebook.dart';
import 'package:platform_security/platform_security.dart';
import 'import_flow_controller.dart';

final phoneBookAdapterProvider = Provider<PhoneBookAdapter>((ref) {
  return PhoneBookAdapter();
});

final matchEngineProvider = Provider<MatchEngine>((ref) {
  return const MatchEngineImpl(
    normalizer: PhoneNormalizerImpl(),
    namePolicy: DefaultNamePolicy(),
  );
});

final sessionCleanerProvider = Provider<SessionCleanerImpl>((ref) {
  return SessionCleanerImpl(
    vault: InMemoryVault(),
    tdlibDbDir: Directory('${Directory.systemTemp.path}/tdlib_db'),
    tdlibFilesDir: Directory('${Directory.systemTemp.path}/tdlib_files'),
  );
});

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => const Locale('en');

  void toggleLocale() {
    state = state.languageCode == 'fa' ? const Locale('en') : const Locale('fa');
  }

  void setLocale(Locale newLocale) {
    state = newLocale;
  }
}

final localeProvider =
    NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }
}

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

final importFlowControllerProvider =
    NotifierProvider<ImportFlowController, FlowState>(ImportFlowController.new);
