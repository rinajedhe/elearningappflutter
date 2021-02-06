import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:e_learning_app/screens/resultpage.dart';

class getjson extends StatelessWidget {
  String topicName;
  getjson(this.topicName);
  String assettoload;

  setAsset() {
    if (topicName == "Planets Of The Solar System") {
      assettoload = "assets/solarsystem.json";
    } else if (topicName == "Life Cycle of a Butterfly") {
      assettoload = "assets/butterfly.json";
    }
  }

  @override
  Widget build(BuildContext context) {
    setAsset();
    return FutureBuilder(
      future: DefaultAssetBundle.of(context).loadString(assettoload, cache: false),
      builder: (context, snapshot) {
        List myData = json.decode(snapshot.data.toString());
        if (myData == null) {
          return Scaffold(
            body: Center(
              child: Text(
                "Loading...",
              ),
            ),
          );
        } else {
          return QuizPage(mydata: myData);
        }
      },
    );
  }
}

class QuizPage extends StatefulWidget {
  final List mydata;
  QuizPage({Key key, @required this.mydata}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState(mydata);
}

class _QuizPageState extends State<QuizPage> {
  final List mydata;
  _QuizPageState(this.mydata);

  Color colortoshow = Color.fromRGBO(114, 9, 183,1);
  Color right = Colors.green;
  Color wrong = Colors.red;
  int marks = 0;
  int i = 1;
  bool disableAnswer = false;
  bool canceltimer = false;

  int j = 1;
  int timer = 10;
  String showtimer = "10";
  var random_array;

  Map<String, Color> btncolor = {
    "a": Color.fromRGBO(114, 9, 183,1),
    "b": Color.fromRGBO(114, 9, 183,1),
    "c": Color.fromRGBO(114, 9, 183,1),
    "d": Color.fromRGBO(114, 9, 183,1),
  };


  @override
  void initState() {
    super.initState();
    starttimer();
  }
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void starttimer() async {
    const onesec = Duration(seconds: 1);
    Timer.periodic(onesec, (Timer t) {
      setState(() {
        if (timer < 1) {
          t.cancel();
          nextquestion();
        } else if (canceltimer == true) {
          t.cancel();
        } else {
          timer = timer - 1;
        }
        showtimer = timer.toString();
      });
    });
  }

  void nextquestion() {
    canceltimer = false;
    timer = 10;
    setState(() {
      if(i < 2){
        i++;
      }
      else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Resulpage(marks: marks),
        ));
      }
      btncolor["a"] = Color.fromRGBO(114, 9, 183,1);
      btncolor["b"] = Color.fromRGBO(114, 9, 183,1);
      btncolor["c"] = Color.fromRGBO(114, 9, 183,1);
      btncolor["d"] = Color.fromRGBO(114, 9, 183,1);
      disableAnswer = false;
    });
    starttimer();
  }

  void checkanswer(String k) {
    if (mydata[2][i.toString()] == mydata[1][i.toString()][k]) {
      debugPrint(mydata[2][i.toString()] + " is equal to " + mydata[1][i.toString()][k]);
      marks = marks + 5;
      colortoshow = right;
    } else {
      debugPrint(mydata[2]["1"] + " is equal to " + mydata[1]["1"][k]);
      colortoshow = wrong;
    }
    setState(() {
      btncolor[k] = colortoshow;
      canceltimer = true;
      disableAnswer = true;
    });
    Timer(Duration(seconds: 2), nextquestion);
  }
  Widget choicebutton(String k) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      child: MaterialButton(
        onPressed: () => checkanswer(k),
        child:Text(
                mydata[1][i.toString()][k],
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Alike",
                  fontSize: 16.0,
                ),
                maxLines: 1,
              ),
        color: btncolor[k],
        splashColor: Colors.indigo[700],
        highlightColor: Colors.indigo[700],
        minWidth: 200.0,
        height: 45.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return WillPopScope(
      onWillPop: (){
        return showDialog(context: context,
        builder: (context) => AlertDialog(
          title: Text("ClassEdge"),
          content: Text("You Can't Go Back"),
          actions: <Widget>[
            FlatButton(child: Text("OK"),
            onPressed: (){
              Navigator.of(context).pop();
            },),
          ],
        ));
      },
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.all(15.0),
                alignment: Alignment.bottomLeft,
                child: mydata[0][i.toString()] == null
                    ? Text('')
                    : Text(
                  mydata[0][i.toString()],
                  style: TextStyle(
                    fontSize: 26.0,fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: AbsorbPointer(
                absorbing: disableAnswer,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      choicebutton("a"),
                      choicebutton("b"),
                      choicebutton("c"),
                      choicebutton("d"),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.topCenter,
                child: Center(
                  child: Text(
                    showtimer,
                    style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
