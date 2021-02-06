import 'package:e_learning_app/screens/simple_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Resulpage extends StatefulWidget {
  int marks;
  Resulpage({Key key , @required this.marks}) : super(key : key);
  @override
  _ResulpageState createState() => _ResulpageState(marks);
}

class _ResulpageState extends State<Resulpage> {
  List<String> images = [
    "images/success.png",
    "images/good.png",
    "images/bad.png",
  ];
  String message;
  String image;
  @override
  void initState(){
    if(marks == 10){
      image = images[0];
      message = "You Did Very Well..\n" + "You Scored $marks";
    }else if(marks == 5){
      image = images[1];
      message = "You Can Do Better..\n" + "You Scored $marks";
    }
    super.initState();
  }

  int marks;
  _ResulpageState(this.marks);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Result",
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: Material(
              elevation: 10.0,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Material(
                      child: Container(
                        width: 300.0,
                        height: 300.0,
                        child: ClipRect(
                          child: Image.asset(
                            'assets/images/success.png',fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 15.0,
                        ),
                        child: Center(
                          child: Text(
                            message,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: "Quando",
                            ),
                          ),
                        )
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OutlineButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SimpleAnimatedList()));
                  },
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 25.0,
                  ),
                  borderSide: BorderSide(width: 3.0, color: Colors.indigo),
                  splashColor: Colors.indigoAccent,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}