class OpenStatus {
  static const OPEN = 1;
  static const CLOSE = -1;
}

class CustomStatus {
  static const DEFAULT = 1;
  static const CUSTOM = -1;
}

class EnumObj {
  final dynamic value;
  final String name;

  EnumObj(
    this.value,
    this.name,
  );
}
