import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  late MqttServerClient client;
  Map<String, Function(String message)> _topicCallbacks = {};

  // Variables para manejar los contadores de ping/pong
  var pongCount = 0;
  var pingCount = 0;

  MqttService() {
    client = MqttServerClient('34.67.137.54', 'flutter_client');
    client.port = 1883;
    client.logging(on: false);
    client.setProtocolV311();
    client.keepAlivePeriod = 20;
    client.connectTimeoutPeriod = 2000;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;
    client.pingCallback = ping;
  }

  Future<void> connect() async {
    final connMess = MqttConnectMessage()
        .withClientIdentifier('Mqtt_MyClientUniqueId')
        .startClean();
    client.connectionMessage = connMess;

    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      print('Error de conexión: $e');
      client.disconnect();
    } on SocketException catch (e) {
      print('Error de socket: $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('Cliente conectado con éxito');

      // 👉 Este listener debe configurarse una sola vez aquí
      client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
        final recMess = c![0].payload as MqttPublishMessage;
        final payloadString = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        final topicReceived = c[0].topic;

        if (_topicCallbacks.containsKey(topicReceived)) {
          _topicCallbacks[topicReceived]!(payloadString);
        } else {
          print('No callback registered for topic: $topicReceived');
        }
      });
    } else {
      print('Error de conexión. Estado: ${client.connectionStatus}');
      client.disconnect();
      exit(-1);
    }
  }


  // Publicación de un mensaje a un topic
  void publishMessage(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);

    print('Publicando mensaje: $message en topic: $topic');
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  // Callback cuando se conecta exitosamente
  void onConnected() {
    print('Conexión exitosa al cliente');
  }

  // Callback cuando se desconecta
  void onDisconnected() {
    print('Desconectado del servidor');
    if (pongCount == 3) {
      print('Pong count correcto: 3');
    } else {
      print('Pong count incorrecto, esperado 3, actual $pongCount');
    }
    if (pingCount == 3) {
      print('Ping count correcto: 3');
    } else {
      print('Ping count incorrecto, esperado 3, actual $pingCount');
    }
  }

  // Callback cuando se recibe un mensaje
  void onSubscribed(String topic) {
    print('Suscripción exitosa al topic $topic');
  }

  // Callback cuando se recibe una respuesta de ping (pong)
  void pong() {
    print('Pong recibido');
    pongCount++;
    print('Latencia de este ciclo ping/pong: ${client.lastCycleLatency}ms');
  }

  // Callback cuando se envía un ping
  void ping() {
    print('Ping enviado');
    pingCount++;
  }

  // Desconectar el cliente
  void disconnect() {
    print('Desconectando...');
    client.disconnect();
  }


  void subscribe(String topic, void Function(String) onMessage) {
    print('Subscribing to topic: $topic');
    _topicCallbacks[topic] = onMessage;
    client.subscribe(topic, MqttQos.atMostOnce);
  }

}

void main() async {
  // Crear una instancia del servicio
  final mqttService = MqttService();

  // Conectar al cliente MQTT
  await mqttService.connect();

  // Publicar un mensaje
  mqttService.publishMessage('Dart/Mqtt_client/testtopic', '¡Hola desde mqtt_client en Flutter!');

  // Mantener la aplicación funcionando por un tiempo para ver la interacción
  await Future.delayed(Duration(seconds: 60));

  // Desconectar el cliente
  mqttService.disconnect();
}
