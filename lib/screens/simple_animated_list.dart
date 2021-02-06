import 'package:e_learning_app/screens/my_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class SimpleAnimatedList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliceAnimatedList(),
    );
  }
}

class SliceAnimatedList extends StatefulWidget {
  @override
  _SliceAnimatedListState createState() => _SliceAnimatedListState();
}

class _SliceAnimatedListState extends State<SliceAnimatedList> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  List _items = ["Planets Of The Solar System","Life Cycle of a Butterfly"];
  int counter = 0;

  Widget slideIt(BuildContext context, int index, animation) {
    int item = _items[index];
    TextStyle textStyle = Theme.of(context).textTheme.headline4;
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset(0, 0),
      ).animate(animation),
      child: SizedBox(
        height: 128.0,
        child: Card(
          color: Colors.primaries[item % Colors.primaries.length],
          child: Center(
            child: Text('Item $item', style: textStyle),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.width,
            child: AnimationLimiter(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context,index){
                  return AnimationConfiguration.staggeredList(
                    position: index,
                   // duration: const Duration(milliseconds: 5),
                    child: SlideAnimation(
                      horizontalOffset: 10,
                      child: FadeInAnimation(
                        child: Container(height: 90,margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                          child: Ink(decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [Color.fromRGBO(114, 9, 183,1), Color.fromRGBO(181, 23, 158,1)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(20.0)
                          ),
                            child: ListTile(
                              subtitle: Text(_items[index],textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20,letterSpacing: 1,fontWeight: FontWeight.w600,color: Colors.white),),
                              onTap: (){
                                if(index == 0)
                                Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(_items[index].toString(),1)));
                                else if(index == 1)
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(_items[index].toString(),2)));
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },),
            ),
          ),
        ],
      ),
    );
  }
}
