import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../app_config.dart';

/// WebSocket service for real-time features
/// Handles connection, reconnection, and message broadcasting
@lazySingleton
class WebSocketService {
  final Logger _logger;

  WebSocketChannel? _channel;
  StreamController<dynamic>? _messageController;
  Timer? _reconnectTimer;
  Timer? _pingTimer;
  bool _isConnected = false;
  bool _shouldReconnect = true;
  int _reconnectAttempts = 0;
  final int _maxReconnectAttempts = 5;
  final Duration _reconnectDelay = const Duration(seconds: 3);

  WebSocketService(this._logger);

  bool get isConnected => _isConnected;
  Stream<dynamic> get messageStream => _messageController?.stream ?? const Stream.empty();

  /// Connect to WebSocket server
  Future<void> connect({String? customUrl, Map<String, dynamic>? headers}) async {
    try {
      final url = customUrl ?? MyAppConfig.wsUrl;
      _logger.i('Connecting to WebSocket: $url');

      _messageController = StreamController<dynamic>.broadcast();
      _channel = WebSocketChannel.connect(Uri.parse(url));

      _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: false,
      );

      _isConnected = true;
      _reconnectAttempts = 0;
      _logger.i('✅ WebSocket connected');

      // Start ping/pong to keep connection alive
      _startPingTimer();
    } catch (e) {
      _logger.e('WebSocket connection error', error: e);
      _isConnected = false;
      _scheduleReconnect();
    }
  }

  /// Disconnect from WebSocket server
  void disconnect() {
    _logger.i('Disconnecting WebSocket');
    _shouldReconnect = false;
    _cleanup();
  }

  /// Send message to WebSocket server
  void send(dynamic message) {
    if (!_isConnected || _channel == null) {
      _logger.w('Cannot send message: WebSocket not connected');
      return;
    }

    try {
      final data = message is String ? message : jsonEncode(message);
      _channel!.sink.add(data);
      _logger.d('Message sent: $data');
    } catch (e) {
      _logger.e('Error sending message', error: e);
    }
  }

  /// Send JSON message
  void sendJson(Map<String, dynamic> data) {
    send(jsonEncode(data));
  }

  /// Subscribe to a specific event/channel
  void subscribe(String event, {Map<String, dynamic>? params}) {
    sendJson({
      'type': 'subscribe',
      'event': event,
      'params': params,
    });
  }

  /// Unsubscribe from an event/channel
  void unsubscribe(String event) {
    sendJson({
      'type': 'unsubscribe',
      'event': event,
    });
  }

  // ========== Private Methods ==========

  void _onMessage(dynamic message) {
    try {
      _logger.d('WebSocket message received: $message');

      // Try to decode JSON
      dynamic data = message;
      if (message is String) {
        try {
          data = jsonDecode(message);
        } catch (_) {
          // Not JSON, use as is
        }
      }

      _messageController?.add(data);
    } catch (e) {
      _logger.e('Error processing message', error: e);
    }
  }

  void _onError(error) {
    _logger.e('WebSocket error', error: error);
    _isConnected = false;
    _scheduleReconnect();
  }

  void _onDone() {
    _logger.w('WebSocket connection closed');
    _isConnected = false;
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (!_shouldReconnect) return;
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      _logger.e('Max reconnection attempts reached');
      return;
    }

    _reconnectAttempts++;
    _logger.i('Scheduling reconnection attempt $_reconnectAttempts/$_maxReconnectAttempts');

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay, () {
      connect();
    });
  }

  void _startPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_isConnected) {
        sendJson({'type': 'ping'});
      } else {
        timer.cancel();
      }
    });
  }

  void _cleanup() {
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _messageController?.close();
    _isConnected = false;
    _channel = null;
    _messageController = null;
  }

  @disposeMethod
  void dispose() {
    disconnect();
  }
}
