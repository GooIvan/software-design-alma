import 'package:shared_preferences/shared_preferences.dart';

Future<void> printLocalStorage() async {
  final prefs = await SharedPreferences.getInstance();
  final keys = prefs.getKeys();

  if (keys.isEmpty) {
    print("No hay datos en local storage");
    return;
  }

  print("===== Local Storage =====");
  for (var key in keys) {
    final value = prefs.get(key);
    print("$key: $value");
  }
  print("=========================");
}
