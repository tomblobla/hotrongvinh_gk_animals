import 'package:audioplayers/audioplayers.dart';

class GameModel {
  var wrong_conti = 0;
  var finish_percent = 0;
  String level = "";
  var score = 0;
  AudioCache audioCache = AudioCache();
  final List<String> imgs = [
    '001-dog',
    '002-bird',
    '003-cat',
    '004-bee',
    '005-fish',
    '006-chicken',
    '007-animal',
    '008-animal-1',
    '009-camel',
    '010-animal-2',
    '011-cow',
    '012-halloween',
    '013-duck',
    '014-snake',
    '015-turkey',
    '016-frog'
  ];

  var img_mode = [
    4, //easy
    6, //medium
    12 //hard
  ];

  var size = [
    [4, 2], //
    [4, 3], //
    [6, 4],
  ];

  var gamestate = 0;
  //0   not start
  //1   starting
  //2   playing
  //3   check ans

  var flipped_img_id = -1;

  List<String> img_liani = new List<String>.empty();

  List<int> img_lianiflag = new List<int>.empty();
  //0 hide
  //1 show
  //2 finish

}
