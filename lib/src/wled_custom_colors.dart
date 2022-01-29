import 'dart:ui';

class WLEDCustomColors {
  final List<Color>? _colors;
  final List<Color?>? _individual;
  final List<WLEDCustomRange>? _ranges;

  /// Creates a list of custom colors where each LED is assigned its corresponding value from [colors].
  WLEDCustomColors(List<Color> colors)
      : _colors = List.unmodifiable(colors),
        _ranges = null,
        _individual = null;

  /// Create color configuration with individual addressable LEDs.
  /// Will create a custom segment where each LED will correspond to the color provided by [colors].
  /// Any [null] values will be ignored.
  WLEDCustomColors.individual(List<Color?> colors)
      : _colors = null,
        _ranges = null,
        _individual = List.unmodifiable(colors);

  /// Creates a color configuration defined by ranges of colors. Each range has a start, end and custom color.
  /// LEDS not addressed by any range will be ignored.
  WLEDCustomColors.ranges(List<WLEDCustomRange?> ranges)
      : _colors = null,
        _ranges = List.unmodifiable(ranges),
        _individual = null;

  List<dynamic> toJson() {
    if (_colors != null) {
      return _colors!.map((c) => [c.red, c.blue, c.green]).toList();
    } else if (_individual != null) {
      List<dynamic> result = [];
      for (int i = 0; i < _individual!.length; i++) {
        final c = _individual![i];
        if (c != null) {
          result.addAll([i, c.toJson()]);
        }
      }
      return result;
    } else if (_ranges != null) {
      List<dynamic> result = [];
      for (int i = 0; i < _ranges!.length; i++) {
        final r = _ranges![i];
        result.addAll([r.start, r.end, r.color.toJson()]);
      }
      return result;
    }
    throw StateError('One of the lists must be non-empty');
  }
}

class WLEDCustomRange {
  final Color color;
  final int start;
  final int end;

  WLEDCustomRange({required this.color, required this.start, required this.end}) : assert(start < end);
}

extension ColorToJson on Color {
  List<int> toJson() {
    return [red, blue, green];
  }
}
