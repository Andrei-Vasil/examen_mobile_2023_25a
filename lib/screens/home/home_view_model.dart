import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

import '../../models/entity.dart';

class HomeViewModel {
  final _channel = WebSocketChannel.connect(
    // TODO change the uri
    Uri.parse('ws://192.168.1.4:2325'),
  );

  Stream<Item> listenForAddedPlanes() {
    return _channel.stream.flatMap((value) {
      if (value is! String) {
        return Stream.error("The received value has the wrong type!");
      }
      var json = Map<String, dynamic>.from(jsonDecode(value));
      return Stream.value(Item.fromJson(json));
    });
  }

  dispose() {
    _channel.sink.close();
  }
}
