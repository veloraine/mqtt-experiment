import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MqttServerClient? client;

  @override
  void initState() {
    super.initState();
    _connect();
  }

  void _connect() async {
    client = MqttServerClient.withPort(
        'broker.emqx.io', 'cobatest3029902390239023', 1883);

    // Set callback handlers
    client!.logging(on: true);
    client!.onConnected = _onConnected;
    client!.onDisconnected = _onDisconnected;
    client!.onSubscribed = _onSubscribed;
    client!.onSubscribeFail = _onSubscribeFail;

    // Connect to the broker
    Logger().w('Connection status = ${client!.connectionStatus?.state}');

    try {
      Logger().i('Trying to Connect');
      await client!.connect();
      Logger().i('Connected');
    } catch (e) {
      Logger().e('Exception: $e');
      client!.disconnect();
    }

    // listen to the topic
    client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final MqttPublishMessage message = c![0].payload as MqttPublishMessage;
      final String payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);
      Logger().w('Received message:$payload from topic: ${c[0].topic}>');
    });
  }

  void _onConnected() {
    Logger().i('Connected to the broker');
    // Subscribe to a topic
    client!.subscribe('bikunDevTopicMobFE', MqttQos.exactlyOnce);
  }

  void _onDisconnected() {
    Logger().w('Disconnected from the broker');
  }

  void _onSubscribed(String topic) {
    Logger().i('Subscribed to the topic: $topic');
  }

  void _onSubscribeFail(String topic) {
    Logger().i('Failed to subscribe to the topic: $topic');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MQTT Integration'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: const Center(
        child: Text('MQTT Integration Example'),
      ),
    );
  }
}
