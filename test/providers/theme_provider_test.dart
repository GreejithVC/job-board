import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_board/providers/theme_provider.dart';

void main() {
  test("initial them is light", () {
    final container = ProviderContainer();
    final mode = container.read(themeNotifierProvider);
    expect(mode, ThemeMode.light);
  });

  test("toggle theme mode to dark",(){
    final container = ProviderContainer();
    final notifier = container.read(themeNotifierProvider.notifier);
    notifier.state = ThemeMode.dark;
    final mode =container.read(themeNotifierProvider);
    expect(mode, ThemeMode.dark);



  });

  test("toggle theme mode to light",(){
    final container = ProviderContainer();
    final notifier = container.read(themeNotifierProvider.notifier);
    notifier.state = ThemeMode.dark;
    notifier.state = ThemeMode.light;
    final mode =container.read(themeNotifierProvider);
    expect(mode, ThemeMode.light);



  });
}
