import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/rendering.dart';
import 'package:qrcode_reader/QRCodeReader.dart';

void main() => runApp(MyHomePage());

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {
  PageController _pageController;
  int groupValue;
  double opacityValue = 0;
  String displayedString = "";
  String displayedString2 = "";
  String displayedStringOld = "";
  static const String pubTopic = 'ttn';
  static const String pubHardwareTopic = 'hardware';
  String qr_code = "";

  Timer timer;

  @override
  void dispose() {
    timer?.cancel();
    brokerAddressController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  //qr scanner

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        setState(() => this.qr_code = qr_code);
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          qr_code = "Camera permission was denied";
        });
      } else {
        setState(() {
          qr_code = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        qr_code = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        qr_code = "Unknown Error $ex";
      });
    }
  }
  String action = "idle";
  final String actionIdle = "idle";
  String movement = "idle";
  final String movementIdle = "idle";
  String username = "gio_anil";

  bool leftButtonState = false;
  bool rightButtonState = false;
  bool upButtonState = false;
  bool downButtonState = false;
  bool selectButtonState = false;
  bool startButtonState = false;
  bool YButtonState = false;
  bool AButtonState = false;
  bool XButtonState = false;
  bool BButtonState = false;
  bool startApp = true;

  void createJsonSendMqttButton() {
    if (client?.connectionState == mqtt.MqttConnectionState.connected) {
      displayedString = '{"movement":"' +
          movement +
          '","action":"' +
          action +
          '","dev_id":"' +
          username +
          '"}';
      if (displayedString != displayedStringOld) {
        displayedStringOld = displayedString;

        final mqtt.MqttClientPayloadBuilder builder =
            mqtt.MqttClientPayloadBuilder();
        builder.addString(displayedString);
        client.publishMessage(
            pubTopic, mqtt.MqttQos.exactlyOnce, builder.payload);
      }
      if (startApp) {
        startApp = false;
        createJsonSendMqttStart();
      }
    }
  }

  String dropdownAddOnValue1 = "Add on";
  String dropdownAddOnValue2 = "Add on";
  String dropdownAddOnValue3 = "Add on";
  String rocketEngineAdd = "01a2f560d6df03bb";
  String amphibiousAdd = "0140c29c8357f2ce"; //-> 0140c29c8357f2ce
  String harrierAdd = "0155cf8199f0245b"; //-> 0155cf8199f0245b
  String adamantiumAdd = "016bc4464286f3fb"; //-> 016bc4464286f3fb
  String gravyShieldAdd = "0148eef363dff533"; //-> 0148eef363dff533
  String nanobotsAdd = "0164a54798d7d27a"; //-> 0164a54798d7d27a
  String structuralStrengtheningAdd = "0136edcaaf285d1d"; //-> 0136edcaaf285d1d
  String FlammenwerpferAdd = "011d5ba90ce241e6"; //-> 011d5ba90ce241e6
  String laserAdd = "01a2eb344edc7c5a"; //-> 01a2eb344edc7c5a
  String minesAdd = "01d9643e2bf10134"; //-> 01d9643e2bf10134
  String plasmaGunAdd = "0100548e2b3038f5"; //-> 0100548e2b3038f5
  String empBombAdd = "01ff7ab8c2155e57"; //-> 01ff7ab8c2155e57
  String ramAdd = "0122e76e424f7c79"; //-> 0122e76e424f7c79
  String gatlingGunAdd = "01f94b5e5d4277b5"; //-> 01f94b5e5d4277b5

  String idHardware = "0080d0803b102f01";
  String add_1 = "0";
  String add_2 = "0";
  String add_3 = "0";

  void addHascodeAddons(String dropdownAddOnValue, int addOnSelection) {
    String addOnSelectionToJsonTemp = "";
    switch (dropdownAddOnValue) {
      case "rocketEngine":
        {
          addOnSelectionToJsonTemp = rocketEngineAdd;
        }
        break;
      case "amphibious":
        {
          addOnSelectionToJsonTemp = amphibiousAdd;
        }
        break;
      case "harrier":
        {
          addOnSelectionToJsonTemp = harrierAdd;
        }
        break;
      case "adamantium":
        {
          addOnSelectionToJsonTemp = adamantiumAdd;        }
        break;
      case "gravyShield":
        {
          addOnSelectionToJsonTemp = gravyShieldAdd;
        }
        break;
      case "nanobots":
        {
          addOnSelectionToJsonTemp = nanobotsAdd;
        }
        break;
      case "structuralStrengthening":
        {
          addOnSelectionToJsonTemp = structuralStrengtheningAdd;
        }
        break;
      case "Flammenwerpfer":
        {
          addOnSelectionToJsonTemp = FlammenwerpferAdd;
        }
        break;
      case "laser":
        {
          addOnSelectionToJsonTemp = laserAdd;
        }
        break;
      case "mines":
        {
          addOnSelectionToJsonTemp = minesAdd;
        }
        break;
      case "plasmaGun":
        {
          addOnSelectionToJsonTemp = plasmaGunAdd;
        }
        break;
      case "empBomb":
        {
          addOnSelectionToJsonTemp =empBombAdd ;
        }
        break;
      case "ram":
        {
          addOnSelectionToJsonTemp = ramAdd;
        }
        break;
      case "gatling gun":
        {
          addOnSelectionToJsonTemp = gatlingGunAdd;
        }
        break;
      default:
        {
          addOnSelectionToJsonTemp = "invalid";
        }
        break;
    }
    switch(addOnSelection) {
      case 1: {add_1 = addOnSelectionToJsonTemp;}
      break;

      case 2: {add_2 = addOnSelectionToJsonTemp;}
      break;

      case 3: {add_3 = addOnSelectionToJsonTemp;}
      break;

      default: {add_1 = "invalidchose";}
      break;
    }
  }

  void createJsonSendMqttStart() {
    if (client?.connectionState == mqtt.MqttConnectionState.connected) {
      displayedString2 = '{"id":"' +
          idHardware +
          '","add_1":"' +
          add_1 +
          '","add_2":"' +
          add_2 +
          '","add_3":"' +
          add_3 +
          '","dev_id":"' +
          username +
          '"}';

      final mqtt.MqttClientPayloadBuilder builder =
          mqtt.MqttClientPayloadBuilder();
      builder.addString(displayedString2);
      client.publishMessage(
          pubHardwareTopic, mqtt.MqttQos.exactlyOnce, builder.payload);
    }
  }

  void onPressedLeft(_) {
    setState(() {
      movement = "left";
    });
  }

  void onPressedUp(_) {
    setState(() {
      movement = "forward";
    });
  }

  void onPressedDown(_) {
    setState(() {
      movement = "backward";
    });
  }

  void onPressedRight(_) {
    setState(() {
      movement = "right";
    });
  }

  void actionSelect(_) {
    setState(() {
      action = "Select";
    });
  }

  void actionStart(_) {
    setState(() {
      action = "start";
    });
  }

  void actionY(_) {
    setState(() {
      action = "Y";
    });
  }

  void actionX(_) {
    setState(() {
      action = "X";
    });
  }

  void actionB(_) {
    setState(() {
      action = "B";
    });
  }

  void ActionA(_) {
    setState(() {
      action = "A";
    });
  }

  final brokerAddressController = TextEditingController(text: '0080d0803b102f01');
  final usernameController = TextEditingController(text: 'Tester');

  String broker = "labict.be";
  String usernameBroker = "";
  String passwordBroker = "";

  mqtt.MqttClient client;
  mqtt.MqttConnectionState connectionState;
  Set<String> topics = Set<String>();
  StreamSubscription subscription;

  String messageFromMqtt = '{}';

  Map<String, dynamic> jsonMQTT;

  int _page = 0;

  void addValuesToMqttClient() {
    broker = "labict.be";
    idHardware = brokerAddressController.text;
    username = usernameController.text;
  }

  void _connect() async {

    client = mqtt.MqttClient(broker, '');
    client.logging(on: true);
    client.keepAlivePeriod = 30;

    client.onDisconnected = _onDisconnected;

    /// Create a connection message to use or use the default one. The default one sets the
    /// client identifier, any supplied username/password, the default keepalive interval(60s)
    /// and clean session, an example of a specific one below.
    final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
        .withClientIdentifier('Mqtt_MyClientUniqueId2')
        .authenticateAs(
            usernameBroker, passwordBroker) // important to connect to broker!!

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

      setState(() {
      });
    });

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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
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
        Container(
          padding: EdgeInsets.only(top: 30),
          child: ListTile(
            leading: const Icon(Icons.location_city),
            title: FloatingActionButton.extended(
              icon: Icon(Icons.camera_alt),
              label: Text("ID"),
              onPressed: _scanQR,
            ),

            //  controller: brokerAddressController,
            //  decoration: InputDecoration(
             //   hintText: "id",
            //  ),
            ),
          ),

        ListTile(
          leading: const Icon(Icons.more_horiz),
          title: TextField(
            controller: usernameController,
            decoration: InputDecoration(
              hintText: "username",
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
              startApp = true;
              _disconnect();
            } else {
              _connect();
            }
          },
        ),
      ],
    );
  }

  Container _buildFakecontrollerPage() {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage('assets/image/bug-logo-z.png'),
                fit: BoxFit.fitWidth,
                  alignment: Alignment.bottomCenter

              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Row(
                children: <Widget>[
                  //1e colom
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      addOnController1(1, 20, 0, 5, 150),
                      buttonControllerMove(
                          Icons.arrow_left, onPressedLeft,85, 0, 0, 130),
                    ],
                  ),
                  //2e colom
                  Column(
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      buttonControllerMove(
                          Icons.arrow_drop_up, onPressedUp, 0, 0, 130, 60),
                      buttonControllerMove(
                          Icons.arrow_drop_down, onPressedDown, 0, 0, 0, 70),
                    ],
                  ),
                  //3e colom
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      buttonControllerMove(
                          Icons.arrow_right, onPressedRight, 0, 0, 70, 0),
                    ],
                  ),
                  //4e colom
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      buttonControllerAction(
                          Icons.adjust, actionSelect, 40, 0, 180, 100),
                    ],
                  ),

                  //5e kolom
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      buttonControllerAction(
                          Icons.adjust, actionStart, 20, 0, 130, 55),
                    ],
                  ),
                  //6e colom
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      addOnController2(2, 0, 0, 0, 0),
                      buttonControllerAction(
                          Icons.arrow_left, actionY, 50, 0, 150, 125),
                    ],
                  ),
                  //7ecolom
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      buttonControllerAction(
                          Icons.arrow_drop_up, actionX, 10, 0, 70, 0),
                      buttonControllerAction(
                          Icons.arrow_drop_down, actionB, 10, 0, 60, 0),
                    ],
                  ),
//8e colom
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      addOnController3(3, 0, 0, 0, 0),
                      buttonControllerAction(
                          Icons.arrow_right, ActionA, 0, 20, 150, 125),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonControllerMove(IconData button, method, double left,
      double right, double top, double bottom) {
    return Container(
      padding:
          EdgeInsets.only(left: left, right: right, top: top, bottom: bottom),
      child: Opacity(
        opacity: opacityValue,
        child: GestureDetector(
          onTapDown: method,
          onTapUp: (_) {
            movement = "idle";
          },
          // Our Custom Button!
          child: Container(
            child: ButtonTheme(
              minWidth: 50.0,
              height: 50.0,
              child: RaisedButton(child: Icon(button), color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonControllerAction(IconData button, method, double left,
      double right, double top, double bottom) {
    return Container(
      padding:
          EdgeInsets.only(left: left, right: right, top: top, bottom: bottom),
      child: Opacity(
        opacity: opacityValue,
        child: GestureDetector(
          onTapDown: method,
          onTapUp: (_) {
            action = "idle";
          },
          // Our Custom Button!
          child: Container(
            child: ButtonTheme(
              minWidth: 50.0,
              height: 50.0,
              child: RaisedButton(child: Icon(button), color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }

  Widget addOnController1(
      int addOnSelectionToJson, double left, double right, double top, double bottom) {
    return Container(
      width: 100,
      padding:
      EdgeInsets.only(left: left, right: right, top: top, bottom: bottom),
      child: DropdownButton<String>(
        isExpanded: true,
        value: dropdownAddOnValue1,
        onChanged: (String newValue) {
          setState(() {
            dropdownAddOnValue1 = newValue;
            addHascodeAddons(dropdownAddOnValue1, addOnSelectionToJson);
            createJsonSendMqttStart();
          });
        },
        items: <String>[
          //dropdownAddOnValue,
          "Add on",
          "rocketEngine",
          "amphibious",
          "harrier",
          "adamantium",
          "gravyShield",
          "nanobots",
          "structuralStrengthening",
          "Flammenwerpfer",
          "laser",
          "mines",
          "plasmaGun",
          "empBomb",
          "ram",
          "gatling gun"
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value,
                style: new TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                )),
          );
        }).toList(),
      ),
    );
  }

  Widget addOnController2(
      int addOnSelectionToJson, double left, double right, double top, double bottom) {
    return Container(
      width: 80,
      padding:
      EdgeInsets.only(left: left, right: right, top: top, bottom: bottom),
      child: DropdownButton<String>(
        isExpanded: true,
        value: dropdownAddOnValue2,
        onChanged: (String newValue) {
          setState(() {
            dropdownAddOnValue2 = newValue;
            addHascodeAddons(dropdownAddOnValue2, addOnSelectionToJson);
            createJsonSendMqttStart();
          });
        },
        items: <String>[
          //dropdownAddOnValue,
          "Add on",
          "rocketEngine",
          "amphibious",
          "harrier",
          "adamantium",
          "gravyShield",
          "nanobots",
          "structuralStrengthening",
          "Flammenwerpfer",
          "laser",
          "mines",
          "plasmaGun",
          "empBomb",
          "ram",
          "gatling gun"
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value,
                style: new TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                )),
          );
        }).toList(),
      ),
    );
  }

  Widget addOnController3(
      int addOnSelectionToJson, double left, double right, double top, double bottom) {
    return Container(
      width: 80,
      padding:
      EdgeInsets.only(left: left, right: right, top: top, bottom: bottom),
      child: DropdownButton<String>(
        isExpanded: true,
        value: dropdownAddOnValue3,
        onChanged: (String newValue) {
          setState(() {
            dropdownAddOnValue3 = newValue;
            addHascodeAddons(dropdownAddOnValue3, addOnSelectionToJson);
            createJsonSendMqttStart();
          });
        },
        items: <String>[
          //dropdownAddOnValue,
          "Add on",
          "rocketEngine",
          "amphibious",
          "harrier",
          "adamantium",
          "gravyShield",
          "nanobots",
          "structuralStrengthening",
          "Flammenwerpfer",
          "laser",
          "mines",
          "plasmaGun",
          "empBomb",
          "ram",
          "gatling gun"
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value,
                style: new TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                )),
          );
        }).toList(),
      ),
    );
  }




    /*Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('QR Code Scanner & Generator'),
      ),
      body: Center(
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    splashColor: Colors.blueGrey,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Scan()),
                      );
                    },
                    child: const Text('SCAN QR CODE')
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    splashColor: Colors.blueGrey,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GenerateScreen()),
                      );
                    },
                    child: const Text('GENERATE QR CODE')
                ),
              ),
            ],
          )
      ),
    );
  }
}*/

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
    timer = Timer.periodic(
        Duration(seconds: 3), (Timer t) => createJsonSendMqttButton());
  }
}