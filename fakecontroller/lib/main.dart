import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:flutter/material.dart';

void main() => runApp(MyHomePage());

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController _pageController;

  String displayedString = "";

  static const String pubTopic = 'fakecontroller/';

  //builder.addString('Hello from mqtt_client');

  void onPressed() {
    setState(() {
      displayedString = "I";
      final mqtt.MqttClientPayloadBuilder builder = mqtt.MqttClientPayloadBuilder();
      builder.addString('Hello from mqtt_client');
      client.publishMessage(pubTopic, mqtt.MqttQos.exactlyOnce, builder.payload);

      //  counter = counter < 6 ? counter + 1 : 0;
    });
  }

  void onPressed1() {
    setState(() {
      displayedString = "Don't";
      //  counter = counter < 6 ? counter + 1 : 0;
    });
  }

  void onPressed2() {
    setState(() {
      displayedString = "Feel";
      //   counter = counter < 6 ? counter + 1 : 0;
    });
  }

  void onPressed3() {
    setState(() {
      displayedString = "So";
      //  counter = counter < 6 ? counter + 1 : 0;
    });
  }

  void onPressed4() {
    setState(() {
      displayedString = "Good";
      // counter = counter < 6 ? counter + 1 : 0;
    });
  }

  void onPressed5() {
    setState(() {
      displayedString = "Mr.Stark";
      // counter = counter < 6 ? counter + 1 : 0;
    });
  }

  void onPressed6() {
    setState(() {
      displayedString = "The cycle of life continues";
      // counter = counter < 6 ? counter + 1 : 0;
    });
  }

  void onPressed7() {
    setState(() {
      displayedString = "I will live, u will die";
      // counter = counter < 6 ? counter + 1 : 0;
    });
  }

  final brokerAddressController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    brokerAddressController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  //String broker = 'eu.thethings.network';
  String broker = "";
  String username = "";
  String password = "";

  mqtt.MqttClient client;
  mqtt.MqttConnectionState connectionState;
  Set<String> topics = Set<String>();
  StreamSubscription subscription;

  String messageFromMqtt = '{}';
  //Map jsonMap = JSON.decode(messageFromMqtt);
  //Map<String, dynamic> user = jsonDecode(messageFromMqtt);
  //dynamic convert(String input) => _parseJson(input, _reviver);

  Map<String, dynamic> jsonMQTT;

  int _page = 0;

  void addValuesToMqttClient() {
    broker = brokerAddressController.text;
    username = usernameController.text;
    password = passwordController.text;
  }

  void _connect() async {
    /// First create a client, the client is constructed with a broker name, client identifier
    /// and port if needed. The client identifier (short ClientId) is an identifier of each MQTT
    /// client connecting to a MQTT broker. As the word identifier already suggests, it should be unique per broker.
    /// The broker uses it for identifying the client and the current state of the client. If you don’t need a state
    /// to be hold by the broker, in MQTT 3.1.1 you can set an empty ClientId, which results in a connection without any state.
    /// A condition is that clean session connect flag is true, otherwise the connection will be rejected.
    /// The client identifier can be a maximum length of 23 characters. If a port is not specified the standard port
    /// of 1883 is used.
    /// If you want to use websockets rather than TCP see below.

    client = mqtt.MqttClient(broker, '');

    //Try for password but not found it but in mqtt_client.dart can you work a round a give there your pass and username.
    //mqtt.connectionMessage.authenticateAs(username, password);
    //mqtt.connect([String username, String password]);

    /// A websocket URL must start with ws:// or wss:// or Dart will throw an exception, consult your websocket MQTT broker
    /// for details.
    /// To use websockets add the following lines -:
    // client.useWebSocket = true;

    /// This flag causes the mqtt client to use an alternate method to perform the WebSocket handshake. This is needed for certain
    /// matt clients (Particularly Amazon Web Services IOT) that will not tolerate additional message headers in their get request
    // client.useAlternateWebSocketImplementation = true;
    // client.port = 443; // ( or whatever your WS port is)
    /// Note do not set the secure flag if you are using wss, the secure flags is for TCP sockets only.

    /// Set logging on if needed, defaults to off
    client.logging(on: true);

    /// If you intend to use a keep alive value in your connect message that is not the default(60s)
    /// you must set it here
    client.keepAlivePeriod = 30;

    /// Add the unsolicited disconnection callback
    client.onDisconnected = _onDisconnected;

    /// Create a connection message to use or use the default one. The default one sets the
    /// client identifier, any supplied username/password, the default keepalive interval(60s)
    /// and clean session, an example of a specific one below.
    final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
        .withClientIdentifier('Mqtt_MyClientUniqueId2')
        .authenticateAs(username, password) // important to connect to broker!!

        // Must agree with the keep alive set above or not set
        .startClean() // Non persistent session for testing
        .keepAliveFor(30)
        // If you set this you must set a will message
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .withWillQos(mqtt.MqttQos.atLeastOnce);
    print('MQTT client connecting....');
    client.connectionMessage = connMess;

    /// Connect the client, any errors here are communicated by raising of the appropriate exception. Note
    /// in some circumstances the broker will just disconnect us, see the spec about this, we however will
    /// never send malformed messages.
    try {
      await client.connect();
    } catch (e) {
      print(e);
      _disconnect();
    }

    /// Check if we are connected
    if (client.connectionState == mqtt.MqttConnectionState.connected) {
      print('MQTT client connected');
      setState(() {
        connectionState = client.connectionState;
      });
    } else {
      print('ERROR: MQTT client connection failed - '
          'disconnecting, state is ${client.connectionState}');
      _disconnect();
    }

    /// The client has a change notifier object(see the Observable class) which we then listen to to get
    /// notifications of published updates to each subscribed topic.
    subscription = client.updates.listen(_onMessage);

    _subscribeToTopic("fakecontrollerout/");
  }

  void _disconnect() {
    client.disconnect();
    _onDisconnected();
  }

  void _onDisconnected() {
    setState(() {
      topics.clear();
      connectionState = client.connectionState;
      client = null;
      subscription.cancel();
      subscription = null;
    });
    print('MQTT client disconnected');
  }

  void _onMessage(List<mqtt.MqttReceivedMessage> event) {
    print(event.length);
    final mqtt.MqttPublishMessage recMess =
        event[0].payload as mqtt.MqttPublishMessage;
    final String message =
        mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    setState(() {
      this.messageFromMqtt = message;

      //jsonMQTT = jsonDecode(messageFromMqtt);
      setState(() {
        /*
        fakecontrollerGettingInformation = jsonMQTT["example"]['example2'][0]["example3"];

        */
      });
    });

    /// The above may seem a little convoluted for users only interested in the
    /// payload, some users however may be interested in the received publish message,
    /// lets not constrain ourselves yet until the package has been in the wild
    /// for a while.
    /// The payload is a byte buffer, this will be specific to the topic
    print('MQTT message: topic is <${event[0].topic}>, '
        'payload is <-- ${message} -->');
    setState(() {});
  }

  void _subscribeToTopic(String topic) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      client.subscribe(topic, mqtt.MqttQos.exactlyOnce);
      setState(() {});
    }
  }

  void _unsubscribeFromTopic(String topic) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      setState(() {
        client.unsubscribe(topic);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    IconData connectionStateIcon;
    switch (client?.connectionState) {
      case mqtt.MqttConnectionState.connected:
        connectionStateIcon = Icons.cloud_done;
        break;
      case mqtt.MqttConnectionState.disconnected:
        connectionStateIcon = Icons.cloud_off;
        break;
      case mqtt.MqttConnectionState.connecting:
        connectionStateIcon = Icons.cloud_upload;
        break;
      case mqtt.MqttConnectionState.disconnecting:
        connectionStateIcon = Icons.cloud_download;
        break;
      case mqtt.MqttConnectionState.faulted:
        connectionStateIcon = Icons.error;
        break;
      default:
        connectionStateIcon = Icons.cloud_off;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Fakecontroller"),
              SizedBox(
                width: 8.0,
              ),
              Icon(connectionStateIcon),
              SizedBox(height: 8.0),
              SizedBox(width: 8.0),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.build), title: Text('Add broker')),
            BottomNavigationBarItem(
                icon: Icon(Icons.gamepad), title: Text('Fakecontroller')),
          ],
          currentIndex: _page,
          fixedColor: Colors.blue,
          onTap: navigationTapped,
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: <Widget>[
            _buildAddBrokerPage(),
            _buildFakecontrollerPage(),
          ],
        ),
      ),
    );
  }

  Column _buildAddBrokerPage() {
    final _formKey = GlobalKey<FormState>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        new ListTile(
          leading: const Icon(Icons.location_city),
          title: new TextField(
            controller: brokerAddressController,
            decoration: new InputDecoration(
              hintText: "server address broker",
            ),
          ),
        ),
        new ListTile(
          leading: const Icon(Icons.more_horiz),
          title: new TextField(
            controller: usernameController,
            decoration: new InputDecoration(
              hintText: "username",
            ),
            //keyboardType: TextInputType.number,
          ),
        ),
        new ListTile(
          leading: const Icon(Icons.more_vert),
          title: new TextField(
            controller: passwordController,
            decoration: new InputDecoration(
              hintText: "password",
            ),
            //keyboardType: TextInputType.number,
          ),
        ),
        RaisedButton(
          child: Text(
              client?.connectionState == mqtt.MqttConnectionState.connected
                  ? 'Disconnect'
                  : 'Connect'),
          textColor: Colors.white,
          color: Colors.redAccent,
          onPressed: () {
            addValuesToMqttClient();
            if (client?.connectionState == mqtt.MqttConnectionState.connected) {
              _disconnect();
            } else {
              _connect();
            }
          },
        ),
      ],
    );
  }

  Column _buildFakecontrollerPage() {
    return Column(
      //code anil
      //child: new Container(

      //child:  Center(

      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text(displayedString,
            style: new TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
        new Padding(padding: new EdgeInsets.all(10.0)),
        new RaisedButton(
            child: new Icon(Icons.arrow_drop_up),
            color: Colors.red,
            onPressed: onPressed),
        new RaisedButton(
            child: new Icon(Icons.arrow_drop_down),
            color: Colors.red,
            onPressed: onPressed1),
        new RaisedButton(
            child: new Icon(Icons.arrow_left),
            color: Colors.red,
            onPressed: onPressed2),
        /*   new RaisedButton(
                          child: new Icon(Icons.arrow_right),
                          color: Colors.red,
                          onPressed: onPressed3
                      ),new RaisedButton(
                          child:new Icon(Icons.power),
                          color: Colors.red,
                          onPressed: onPressed4
                      ),
                      new RaisedButton(
                          child: new Icon(Icons.info),
                          color: Colors.red,
                          onPressed: onPressed5
                      ),
                      new RaisedButton(
                          child: new Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: onPressed6
                      ),
                      new RaisedButton(
                          child: new Icon(Icons.change_history),
                          color: Colors.red,
                          onPressed: onPressed7
                      ),*/
      ],
      //),
      //),
    );
  }

  void navigationTapped(int page) {
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 400), curve: Curves.ease);
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }
}