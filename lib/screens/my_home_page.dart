import 'package:e_learning_app/screens/quizap.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MyHomePage extends StatefulWidget {
  String topic;
  int topicIndexNo;
  MyHomePage(this.topic,this.topicIndexNo);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
 static final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  TextEditingController _notesController = TextEditingController();
  YoutubePlayerController _controller;
  TextEditingController _idController;
  TextEditingController _seekToController;
  SharedPreferences notesAtCuept;
  String notes;

  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;

  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  int currentCuePt = 1;
  List<int> _cuePtList = [1,2,3];

  final List<String> _ids = [
    'RJ2bQWH6GCM',
    'O1S8WzwLPlM',
  ];

  savepref(String notes,String point,String values)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("note", notes);
      preferences.setString("pointvalue", point);
      preferences.setString("key", values);
      preferences.commit();
    });
  }
  
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.topicIndexNo == 1 ?  _ids.first : _ids[1],
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        print(_controller.value.position);
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
        if(_controller.value.position.inMinutes == currentCuePt){
          _controller.pause();
          openAddPopup(context);
        }else{}
      });
    }
  }


  void openAddPopup(BuildContext context){
    print("Video Paused");
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(scrollable: true,
          content: Column(mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[Icon(Icons.assignment,color: Colors.brown,),
                  Text("CREATE NOTE",style: TextStyle(color: Colors.indigoAccent,fontWeight: FontWeight.bold),),
                ],
              ),
              SizedBox(height: 5,),
              Container(height: 160,decoration: BoxDecoration(
                border: Border.all(width: 0.4,color: Colors.grey),
                borderRadius: BorderRadius.circular(8),),
                child: Padding(
                  padding: const EdgeInsets.only(left:5.0,right: 5.0),
                  child: TextFormField(
                    controller: _notesController,
                    keyboardType: TextInputType.text,
                    cursorColor: Colors.grey,
                    onSaved: (e) => notes = e,
                    decoration: InputDecoration(
                    hintText: "Insert text here",
                    hintStyle: TextStyle(fontStyle: FontStyle.italic)),
                  ),
                ),
              ),
              SizedBox(height: 5,),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(color: Colors.blueGrey,
                    onPressed: (){
                  print(notes);
                  print(_notesController.text.toString());
                  Navigator.of(context,rootNavigator: true).pop();
                  setState(() {
                    currentCuePt = currentCuePt + 1;
                    _controller.play();
                    savepref(_notesController.text.toString(), currentCuePt.toString(), "Cuepoint");
                    print(notesAtCuept.getString("note"));
                    print(notesAtCuept.getString("key"));
                    print(notesAtCuept.getString("pointvalue"));
                  });
                      /// save the note
                    }, child: Text("Save Note",style: TextStyle(color: Colors.white),)),

                FlatButton(color: Colors.blueGrey,
                    onPressed: (){
                      print("Closed");
                      Navigator.of(context,rootNavigator: true).pop();
                      setState(() {
                        currentCuePt = currentCuePt + 1;
                        _controller.play();
                      });
                    }, child: Text("Close",style: TextStyle(color: Colors.white),)),

              ],
            ),

            ],
          ),
        );
      }
    );

  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(color: Colors.white,
          child: YoutubePlayerBuilder(
            onExitFullScreen: () {
              // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
              SystemChrome.setPreferredOrientations(DeviceOrientation.values);
            },
            player: YoutubePlayer(
              progressColors: ProgressBarColors(playedColor: Colors.red,bufferedColor: Colors.grey,handleColor: Colors.white),
              controller: _controller,
              showVideoProgressIndicator: true,width: 2,
              progressIndicatorColor: Colors.blueAccent,
              topActions: <Widget>[
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    _controller.metadata.title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
              onReady: () {
                _isPlayerReady = true;
              },
              onEnded: (data) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => getjson(widget.topic.toString())));
              },
            ),
            builder: (context, player) => Scaffold(
              key: _scaffoldKey,
              body: ListView(
                children: [
                  player,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _space,
                        _text('Title', _videoMetaData.title),
                        _space,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.skip_previous),
                              onPressed: _isPlayerReady
                                  ? () => _controller.load(_ids[
                              (_ids.indexOf(_controller.metadata.videoId) -
                                  1) %
                                  _ids.length])
                                  : null,
                            ),
                            IconButton(
                              icon: Icon(
                                _controller.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                              ),
                              onPressed: _isPlayerReady
                                  ? () {
                                _controller.value.isPlaying
                                    ? _controller.pause()
                                    : _controller.play();
                                setState(() {});
                              }
                                  : null,
                            ),
                            IconButton(
                              icon: Icon(_muted ? Icons.volume_off : Icons.volume_up),
                              onPressed: _isPlayerReady
                                  ? () {
                                _muted
                                    ? _controller.unMute()
                                    : _controller.mute();
                                setState(() {
                                  _muted = !_muted;
                                });
                              }
                                  : null,
                            ),
                            FullScreenButton(
                              controller: _controller,
                              color: Colors.blueAccent,
                            ),
                            IconButton(
                              icon: const Icon(Icons.skip_next),
                              onPressed: _isPlayerReady
                                  ? () => _controller.load(_ids[
                              (_ids.indexOf(_controller.metadata.videoId) +
                                  1) %
                                  _ids.length])
                                  : null,
                            ),
                          ],
                        ),
                        _space,
                        Row(
                          children: <Widget>[
                            const Text(
                              "Volume",
                              style: TextStyle(fontWeight: FontWeight.w300),
                            ),
                            Expanded(
                              child: Slider(
                                inactiveColor: Colors.transparent,
                                value: _volume,
                                min: 0.0,
                                max: 100.0,
                                divisions: 10,
                                label: '${(_volume).round()}',
                                onChanged: _isPlayerReady
                                    ? (value) {
                                  setState(() {
                                    _volume = value;
                                  });
                                  _controller.setVolume(_volume.round());
                                }
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        _space,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _text(String title, String value) {
    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value ?? '',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget get _space => const SizedBox(height: 10);

}
