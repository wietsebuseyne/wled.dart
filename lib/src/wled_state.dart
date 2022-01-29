class WLEDState {
  final bool on;
  final int brightness;

  const WLEDState({required this.on, required this.brightness});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WLEDState && runtimeType == other.runtimeType && on == other.on && brightness == other.brightness;

  @override
  int get hashCode => on.hashCode ^ brightness.hashCode;
}
