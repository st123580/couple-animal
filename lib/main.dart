import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String level;
  late int score;
  var getstart = 0;
  late int row;
  late int column;
  int previousindex = -1;
  int wrong = 0;

  List<String> animal = [
    'assets/001-dog.png',
    'assets/002-bird.png',
    'assets/003-cat.png',
    'assets/004-bee.png',
    'assets/005-fish.png',
    'assets/006-chicken.png',
    'assets/007-animal.png',
    'assets/008-animal-1.png',
    'assets/009-camel.png',
    'assets/010-animal-2.png',
    'assets/011-cow.png',
    'assets/012-halloween.png',
    'assets/013-duck.png',
    'assets/014-snake.png',
    'assets/015-turkey.png',
    'assets/016-frog.png',
  ];

  List<String> card = [];
  List<int> hiddencard = [];

  @override
  void initState() {
    level = '';
    score = 0;
    column = 2;
    row = 4;
    super.initState();
  }

  void start() {
    //khi chưa chọn level
    if (level == '' || level == 'Choose level!') {
      setState(() {
        level = 'Choose level!';
      });
      return;
    }
    //đã chọn level
    else {
      getstart = 1;
      animal.shuffle();
      if (level == 'Easy') {
        card = animal.sublist(0, 4); //4 con vật
      } else if (level == 'Medium') {
        card = animal.sublist(0, 6); // 6 con vật
      } else if (level == 'Hard') {
        card = animal.sublist(0, 12); //12 con vật
      }
      setState(() {
        card += card; //nhân đôi số hình
        card.shuffle();
      });
      reset();
    }
  }

  //lật tất cả hình
  void showanimal() {
    setState(() {
      for (int i = 0; i < hiddencard.length; i++) {
        hiddencard[i] = 1;
      }
    });
  }

  //che tất cả hình
  void hideanimal() {
    setState(() {
      if (level == 'Easy') {
        hiddencard = List<int>.filled(8, 0);
        for (int i = 0; i < 8; i++) {
          hiddencard[i] = 0;
        }
      } else if (level == 'Medium') {
        hiddencard = List<int>.filled(12, 0);
        for (int i = 0; i < 12; i++) {
          hiddencard[i] = 0;
        }
      } else if (level == 'Hard') {
        hiddencard = List<int>.filled(24, 0);
        for (int i = 0; i < 24; i++) {
          hiddencard[i] = 0;
        }
      }
    });
  }

  void reset() {
    score = 0;
    wrong = 0;
    previousindex = -1;
    hideanimal();
    showanimal();

    Timer(const Duration(seconds: 3), () {
      setState(() {
        hideanimal();
        getstart = 2; //chạy game
      });
    });
  }

  String getanimal(int index) {
    String temp = 'assets/018-back.png';
    switch (getstart) {
      case 0:
        {
          temp = 'assets/018-back.png';
          break;
        }
      case 1:
        {
          temp = card[index];
          break;
        }
      case 2:
      case 3:
        {
          switch (hiddencard[index]) {
            case 0:
              {
                temp = 'assets/018-back.png';
                break;
              }
            case 1:
              {
                temp = card[index];
                break;
              }
            case 2:
              {
                temp = 'assets/017-checked.png';
                break;
              }
          }
        }
    }
    return temp;
  }

  void choose(int index) {
    setState(() {
      if (getstart < 2 || getstart == 3 || hiddencard[index] > 0) {
        return; //không thể thao tác với hình khi trò chơi chưa bắt đầu, hoặc khi có 2 hình đang lật, hoặc hình không còn bị che
      }
      //lật hình được chọn
      hiddencard[index] = 1;
      if (previousindex < 0) {
        previousindex = index;
      } else if (previousindex >= 0) {
        getstart = 3;
        Timer(const Duration(milliseconds: 500), () {
          setState(() {
            //2 hình giống nhau được thay bằng dấu tích, cộng 10 điểm, đặt lại số lần sai liên tiếp
            if (card[index] == card[previousindex]) {
              hiddencard[index] = 2;
              hiddencard[previousindex] = 2;
              score += 10;
              wrong = 0;
            }
            //2 hình khác nhau được úp trở lại, số lần sai liên tiếp +1
            else {
              hiddencard[index] = 0;
              hiddencard[previousindex] = 0;
              wrong++;
              //sai liên tiếp 2 lần -5 điểm
              if (wrong >= 2) {
                score -= 5;
              }
            }
            getstart = 2;
            previousindex = -1;
          });
        });
      }
    });
  }

  Widget playgame(int index) {
    return Expanded(
      child: ElevatedButton(
        child: Image.asset(getanimal(index)),
        onPressed: () => setState(() {
          choose(index);
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Animals Game',
      home: Scaffold(
        backgroundColor: Colors.cyan,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            //hiển thị level và score
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Level: ' + level,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 33,
                            color: Colors.pink)),
                    Text('Score: ' + score.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 33,
                            color: Colors.pink))
                  ],
                )),
            //3 nút chọn level
            Expanded(
              flex: 1,
              child: ConstrainedBox(
                constraints: const BoxConstraints.expand(),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        child: const Text('Easy',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 33)),
                        onPressed: () => setState(() {
                          level = 'Easy';
                          getstart = 0;
                          previousindex == -1;
                          column = 2;
                          row = 4;
                          score = 0;
                        }),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.lightGreen),
                      ),
                      ElevatedButton(
                        child: const Text('Medium',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 33)),
                        onPressed: () => setState(() {
                          level = 'Medium';
                          getstart = 0;
                          previousindex == -1;
                          column = 3;
                          row = 4;
                          score = 0;
                        }),
                        style: ElevatedButton.styleFrom(primary: Colors.orange),
                      ),
                      ElevatedButton(
                        child: const Text('Hard',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 33)),
                        onPressed: () => setState(() {
                          level = 'Hard';
                          getstart = 0;
                          previousindex == -1;
                          column = 4;
                          row = 6;
                          score = 0;
                        }),
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                      )
                    ],
                  ),
                ),
              ),
            ),
            //trò chơi
            Expanded(
              flex: 6,
              child: ConstrainedBox(
                constraints: const BoxConstraints.expand(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    children: [
                      for (int i = 0; i < row; i++)
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              for (int j = 0; j < column; j++)
                                playgame(i * column + j),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            //nút start và restart
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => start(),
                      child: const Text('Start',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 33,
                              color: Colors.pink)),
                      style:
                          ElevatedButton.styleFrom(primary: Colors.cyan[100]),
                    ),
                    ElevatedButton(
                      onPressed: () => reset(),
                      child: const Text('Restart',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 33,
                              color: Colors.pink)),
                      style:
                          ElevatedButton.styleFrom(primary: Colors.cyan[100]),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
