import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;

  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;

  SocketService() {
    this._initConfig();
  }

  void _initConfig() {
    String urlSocket = 'http://192.168.100.5:3001';
    print("esta aqui");
    this._socket = IO.io(
        urlSocket,
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .enableAutoConnect()
            .setExtraHeaders({'foo': 'bar'}) // optional
            .build());

    // , {
    //   'transports': ['websocket'],
    //   'autoConnect': true
    // });
    //

    this._socket.onConnect((_) {
      // socket.emit('msg', 'test');
      print('connect');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    print("hola");
    // socket.on('event', (data) => print(data));
    this._socket.onDisconnect((_) {
      this._serverStatus = ServerStatus.Offline;
      print('disconnect');
      notifyListeners();
    });
    // socket.on('fromServer', (_) => print(_));

    this._socket.on('emitir-mensaje', (payload) {
      print('emitir-mensaje: $payload');
    });
  }
}
