import 'package:app_lenses_commerce/config/theme/themeApp.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Listado de colores inmutable
final colorListProvider = Provider((ref) => colorList);

// boolean para tema dark
final isDarkModeProvider = StateProvider((ref) => false);

// selector de color
final selectedColorProvider = StateProvider((ref) => 0);

// Un objeto de tipo AppTheme (custom)
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, AppTheme>(
  (ref) => ThemeNotifier(),
);

// Controller o Notifier
class ThemeNotifier extends StateNotifier<AppTheme> {
  // STATE = Estado = new AppTheme();
  ThemeNotifier() : super(AppTheme());

  void toggleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }

  void changeColorIndex(int colorIndex) {
    state = state.copyWith(selectedColor: colorIndex);
  }
}
