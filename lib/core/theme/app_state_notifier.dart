import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Gerenciador de estado compartilhado do app.
/// Evita passar callbacks através de muitos níveis de widget.
class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();
  static final AppStateNotifier instance = AppStateNotifier._();

  SharedPreferences? _prefs;
  static const String _imagesOnlyKey = 'images_only_mode';

  bool _imagesOnly = false;

  bool get imagesOnly => _imagesOnly;

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _imagesOnly = _prefs!.getBool(_imagesOnlyKey) ?? false;
    } catch (e) {
      debugPrint('AppStateNotifier.init falhou: $e');
    }
  }

  Future<void> setImagesOnly(bool value) async {
    _imagesOnly = value;
    try {
      await _prefs?.setBool(_imagesOnlyKey, value);
    } catch (e) {
      debugPrint('AppStateNotifier.setImagesOnly falhou: $e');
    }
    notifyListeners();
  }
}
