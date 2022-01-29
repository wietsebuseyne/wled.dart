import 'dart:convert';
import 'dart:io';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wled/src/wled_custom_colors.dart';
import 'package:wled/wled.dart';

class WLED {
  /// The underlying web socket.
  ///
  /// This is essentially a copy of `dart:io`'s WebSocket implementation, with
  /// the IO-specific pieces factored out.
  final WebSocketChannel _channel;
  final WebSocket _webSocket;

  WLED._(this._channel, this._webSocket);

  /// Create a new WebSocket connection to the provided [ipAddress].
  /// Throws [WebSocketException] if something goes wrong while connecting
  static Future<WLED> connect(
    String ipAddress, {
    Iterable<String>? protocols,
    Map<String, dynamic>? headers,
    Duration? pingInterval,
  }) async {
    final uri = Uri.parse('ws://$ipAddress/ws');

    final webSocket = await WebSocket.connect(uri.toString(), headers: headers, protocols: protocols);
    webSocket.pingInterval = pingInterval;

    final channel = IOWebSocketChannel(webSocket);
    return WLED._(channel, webSocket);
  }

  /// Closes the WebSocket connection to WLED
  Future<void> close() => _webSocket.close();

  Stream<WLEDState> get stream {
    return _channel.stream.map((json) {
      final decoded = jsonDecode(json as String);

      return WLEDState(on: decoded['state']['on'] as bool, brightness: decoded['state']['bri'] as int);
    });
  }

  Sink get _sink => _channel.sink;

  /// The subprotocol selected by the server.
  ///
  /// For a client socket, this is initially `null`. After the WebSocket
  /// connection is established the value is set to the subprotocol selected by
  /// the server. If no subprotocol is negotiated the value will remain `null`.
  String? get protocol => _channel.protocol;

  /// The [close code][] set when the WebSocket connection is closed.
  ///
  /// [close code]: https://tools.ietf.org/html/rfc6455#section-7.1.5
  ///
  /// Before the connection has been closed, this will be `null`.
  int? get closeCode => _channel.closeCode;

  /// The [close reason][] set when the WebSocket connection is closed.
  ///
  /// [close reason]: https://tools.ietf.org/html/rfc6455#section-7.1.6
  ///
  /// Before the connection has been closed, this will be `null`.
  String? get closeReason => _channel.closeReason;

  void setBrightness(int brightness) {
    if (brightness < 0) brightness = 0;
    if (brightness > 256) brightness = 256;
    _sink.add('{"bri": $brightness}');
  }

  void setStatus(bool on) {
    _sink.add('{"on": $on}');
  }

  void setCustomColors(WLEDCustomColors customColors) {
    _sink.add('{"seg": {"i": ${jsonEncode(customColors.toJson())}}}');
  }
}
