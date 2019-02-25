import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.portraitUp]);
  runApp(
      new MaterialApp(
          home: new AwesomeButton()
      )
  );
}

class AwesomeButton extends StatefulWidget {
  @override
  AwesomeButtonState createState() => new AwesomeButtonState();

}

class AwesomeButtonState extends State<AwesomeButton> {

 // int counter = 0;
 // List<String> strings = ["Please", "Keep", "ON","Pressing", "It ", "Feels", "GOOD"];
  String displayedString = "";

  void onPressed() {
    setState(() {
      displayedString = "I";
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text("Fake Controller"), backgroundColor: Colors.deepOrange),
        body: new Container(

          child:  Center(
          child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          new Text(displayedString, style: new TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
          new Padding(padding: new EdgeInsets.all(10.0)),
          new RaisedButton(
          child: new Icon(Icons.arrow_drop_up),
          color: Colors.red,
          onPressed: onPressed
          ),
          new RaisedButton(
          child: new Icon(Icons.arrow_drop_down),
          color: Colors.red,
          onPressed: onPressed1
          ),
          new RaisedButton(
          child:new Icon(Icons.arrow_left),
          color: Colors.red,
          onPressed: onPressed2
          ),
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
                      )*/
          ]
          )
          )
        ),


    );
  }
}