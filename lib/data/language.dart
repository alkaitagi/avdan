import 'translation.dart';

class Language {
  final Translation name;
  final String flag;
  final bool interface;
  final bool learning;

  String get flagUrl => 'assets/flags/$flag.png';

  String? get alt {
    final alt = name.global! + '_alt';
    return name.map[alt] == null ? null : alt;
  }

  const Language(
    this.name, {
    required this.flag,
    this.interface = false,
    this.learning = false,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      Translation.fromJson(json['name']),
      flag: json['flag'],
      interface: (json['interface'] ?? false) as bool,
      learning: (json['learning'] ?? false) as bool,
    );
  }
}
