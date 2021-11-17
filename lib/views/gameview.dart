import 'package:flutter/material.dart';
import 'package:hotrongvinh_gk_animals/models/gamemodel.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class GameView extends StatefulWidget {
  const GameView({Key? key}) : super(key: key);

  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  TextStyle txtstyle = new TextStyle(
      color: Colors.pink, fontSize: 25, fontWeight: FontWeight.bold);

  GameModel gamemodel = new GameModel();

  void btnStart() {
    if (gamemodel.level == "") {
      setState(() {
        for (int i = 0; i < 3; i++) {
          gamemodel.level = "Choose mode";
          Timer(Duration(milliseconds: 200), () {
            setState(() {
              gamemodel.level = "";
              Timer(Duration(milliseconds: 200), () {
                setState(() {
                  gamemodel.level = "Choose mode";
                  Timer(Duration(milliseconds: 200), () {
                    setState(() {
                      gamemodel.level = "";
                      Timer(Duration(milliseconds: 200), () {
                        setState(() {
                          gamemodel.level = "Choose mode";
                          Timer(Duration(milliseconds: 200), () {
                            setState(() {
                              gamemodel.level = "";
                            });
                          });
                        });
                      });
                    });
                  });
                });
              });
            });
          });
        }
      });

      return;
    }

    CreateNewGame();
  }

  void CreateNewGame() {
    gamemodel.gamestate = 1;
    GetRandomAnimal();
    Reset();
  }

  void Img_Click(int ID) {
    setState(() {
      if (gamemodel.img_lianiflag[ID] > 0 ||
          gamemodel.gamestate < 2 ||
          gamemodel.gamestate == 3) return;

      gamemodel.img_lianiflag[ID] = 1;

      if (gamemodel.flipped_img_id < 0) {
        gamemodel.flipped_img_id = ID;
      } else if (gamemodel.flipped_img_id >= 0) {
        gamemodel.gamestate = 3;
        Timer(Duration(milliseconds: 700), () {
          setState(() {
            Check_Ans(ID);
            gamemodel.gamestate = 2;
          });
        });
      }
    });
  }

  void Check_Ans(int ID) {
    setState(() {
      if (gamemodel.img_liani[ID] ==
          gamemodel.img_liani[gamemodel.flipped_img_id]) {
        gamemodel.img_lianiflag[ID] = 2;
        gamemodel.img_lianiflag[gamemodel.flipped_img_id] = 2;
        gamemodel.score += 10;
        gamemodel.wrong_conti = 0;
        gamemodel.finish_percent++;
        gamemodel.audioCache.play('../audios/${gamemodel.img_liani[ID]}.mp3');
      } else {
        gamemodel.img_lianiflag[ID] = 0;
        gamemodel.img_lianiflag[gamemodel.flipped_img_id] = 0;
        gamemodel.wrong_conti++;
        if (gamemodel.wrong_conti >= 2) {
          gamemodel.score -= 5;
          gamemodel.audioCache.play('../audios/laugh.mp3');
        }
      }
      gamemodel.flipped_img_id = -1;

      if (gamemodel.finish_percent == gamemodel.img_mode[ConvertLevelToId()]) {
        gamemodel.finish_percent = 0;
        gamemodel.gamestate = 0;
      } // check if you finish the game
    });
  }

  String getAssetsFromID(int ID) {
    String save = "images/018-back.png";
    switch (gamemodel.gamestate) {
      case 0:
        {
          save = "images/018-back.png";
          break;
        }
      case 1:
        {
          save = "images/${gamemodel.img_liani[ID]}.png";
          break;
        }
      case 2:
      case 3:
        {
          switch (gamemodel.img_lianiflag[ID]) {
            case 0:
              {
                save = "images/018-back.png";
                break;
              }
            case 1:
              {
                save = "images/${gamemodel.img_liani[ID]}.png";
                break;
              }
            case 2:
              {
                save = "images/017-checked.png";
                break;
              }
          }
        }
    }
    return save;
  }

  void GetRandomAnimal() {
    List<String> li = gamemodel.imgs;
    li.shuffle();
    li = li.sublist(0, gamemodel.img_mode[ConvertLevelToId()]);
    li = li + li;

    li.shuffle();
    setState(() {
      gamemodel.img_liani = new List<String>.from(li);
    });
  }

  void HideAll() {
    setState(() {
      gamemodel.img_lianiflag =
          new List<int>.filled(gamemodel.img_mode[ConvertLevelToId()] * 2, 0);

      for (int i = 0; i < gamemodel.img_mode[ConvertLevelToId()] * 2; i++) {
        gamemodel.img_lianiflag[i] = 0;
      }
    });
  }

  void ShowAll() {
    setState(() {
      for (int i = 0; i < gamemodel.img_lianiflag.length; i++) {
        gamemodel.img_lianiflag[i] = 1;
      }
    });
  }

  int ConvertLevelToId() {
    if (gamemodel.level == "Easy")
      return 0;
    else if (gamemodel.level == "Medium")
      return 1;
    else if (gamemodel.level == "Hard") return 2;

    return 0;
  }

  void ChangeLevel(String level) {
    gamemodel.level = level;
  }

  void Reset() {
    gamemodel.wrong_conti = 0;
    gamemodel.score = 0;
    gamemodel.flipped_img_id == -1;
    HideAll();
    ShowAll();

    Timer(Duration(seconds: (ConvertLevelToId() + 1)), () {
      setState(() {
        gamemodel.gamestate = 2;
        HideAll();
      });
    });
  }

  Widget PlayView() {
    return Column(
      children: [
        for (int i = 0; i < gamemodel.size[ConvertLevelToId()][0]; i++)
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (int j = 0;
                      j < gamemodel.size[ConvertLevelToId()][1];
                      j++)
                    ImgButton(
                        (i) * (gamemodel.size[ConvertLevelToId()][1]) + j),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget ImgButton(int ID) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 100 / 100,
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: 2,
            horizontal: 2,
          ),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                Img_Click(ID);
              });
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
            ),
            child: Image(image: AssetImage('../' + getAssetsFromID(ID))),
          ),
        ),
      ),
    );
  }

  Widget ChangeModeBtn() {
    List<String> modeLi = ['Easy', 'Medium', 'Hard'];
    List<MaterialColor> modeColorLi = [Colors.green, Colors.orange, Colors.red];

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      for (int i = 0; i < 3; i++)
        Expanded(
          child: ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: Padding(
              padding: EdgeInsets.all(4),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (modeLi[i] == gamemodel.level) return;
                    ChangeLevel(modeLi[i]);
                    gamemodel.wrong_conti = 0;
                    gamemodel.score = 0;
                    gamemodel.flipped_img_id == -1;
                    gamemodel.gamestate = 0;
                  });
                },
                child: Text(modeLi[i],
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                style: ElevatedButton.styleFrom(primary: modeColorLi[i]),
              ),
            ),
          ),
        ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game con vat',
      home: Scaffold(
        backgroundColor: Colors.blue[200],
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Level: ${gamemodel.level}',
                          style: txtstyle,
                        ),
                        Text(
                          'Score: ${gamemodel.score}',
                          style: txtstyle,
                        ),
                      ]),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: ChangeModeBtn(),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: Padding(
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: PlayView(),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ConstrainedBox(
                            constraints: BoxConstraints.expand(),
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: ElevatedButton(
                                onPressed: btnStart,
                                child: Text('Start',
                                    style: TextStyle(
                                        color: Colors.pink,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25)),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blue[100]),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ConstrainedBox(
                            constraints: BoxConstraints.expand(),
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    Reset();
                                  });
                                },
                                child: Text('Restart',
                                    style: TextStyle(
                                        color: Colors.pink,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25)),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blue[100]),
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
