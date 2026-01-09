import 'dart:developer' as developer;
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  io.Socket? _socket;
  bool _isConnected = false;
  
  static const String socketUrl = 'http://localhost:8080';

  bool get isConnected => _isConnected;

  void connect(String token) {
    _socket = io.io(
      socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .enableAutoConnect()
          .enableReconnection()
          .setReconnectionDelay(1000)
          .build(),
    );

    _socket!.onConnect((_) {
      developer.log('Socket connected', name: 'SocketService');
      _isConnected = true;
    });

    _socket!.onDisconnect((_) {
      developer.log('Socket disconnected', name: 'SocketService');
      _isConnected = false;
    });

    _socket!.onError((error) {
      developer.log('Socket error', error: error, name: 'SocketService');
    });
    
    _socket!.onConnectError((error) {
      developer.log('Socket connect error', error: error, name: 'SocketService');
    });
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _isConnected = false;
  }

  // Listen to ride updates
  void onRideUpdate(Function(dynamic) callback) {
    _socket?.on('ride_update', callback);
  }

  // Listen to driver location updates
  void onDriverLocation(Function(dynamic) callback) {
    _socket?.on('driver_location', callback);
  }

  // Listen to new messages
  void onNewMessage(Function(dynamic) callback) {
    _socket?.on('new_message', callback);
  }
  
  // Listen to ride requests (for drivers)
  void onNewRideRequest(Function(dynamic) callback) {
    _socket?.on('new_ride_request', callback);
  }
  
  // Listen to ride accepted (for riders)
  void onRideAccepted(Function(dynamic) callback) {
    _socket?.on('ride_accepted', callback);
  }
  
  // Listen to ride cancelled
  void onRideCancelled(Function(dynamic) callback) {
    _socket?.on('ride_cancelled', callback);
  }

  // Emit events
  void emitRideRequest(Map<String, dynamic> data) {
    _socket?.emit('ride_request', data);
  }

  void emitLocationUpdate(Map<String, dynamic> data) {
    _socket?.emit('location_update', data);
  }

  void emitMessage(Map<String, dynamic> data) {
    _socket?.emit('send_message', data);
  }
  
  void emitDriverOnline(bool isOnline) {
    _socket?.emit('driver_status', {'online': isOnline});
  }
  
  void emitRideAccept(String rideId) {
    _socket?.emit('accept_ride', {'rideId': rideId});
  }
  
  void removeListener(String event) {
    _socket?.off(event);
  }
  
  void removeAllListeners() {
    _socket?.clearListeners();
  }
  
  // Remove specific listener
  void off(String event) {
    _socket?.off(event);
  }
}
