import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(
    Myapp(),
  );
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SnakeGame(),
    );
  }
}

class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  final int squaresperRow = 20;
  final int squareperColumn = 40;
  final fontstyle = TextStyle(color: Colors.white, fontSize: 20);
  final randomGen = Random();

  var snake = [
    [0, 1],
    [0, 0]
  ];
  var food = [0, 2];
  var direction = 'up';
  var isPlaying = false;

  void StartGame() {
    const duration = Duration(milliseconds: 300);
    snake = [
      [(squaresperRow / 2).floor(), (squareperColumn / 2).floor()]
    ];
    snake.add([snake.first[0], snake.first[1] - 1]);
    CreateFood();
    isPlaying = true;
    Timer.periodic(duration, (Timer timer) {
      MoveSnake();
      if (CheckGameOver()) {
        timer.cancel();
        EndGame();
      }
    });
  }

  void MoveSnake() {
    setState(() {
      switch (direction) {
        case 'up':
          snake.insert(0, [snake.first[0], snake.first[1] - 1]);
          break;
        case 'down':
          snake.insert(0, [snake.first[0], snake.first[1] + 1]);
          break;
        case 'left':
          snake.insert(0, [snake.first[0] - 1, snake.first[1]]);
          break;
        case 'right':
          snake.insert(0, [snake.first[0] + 1, snake.first[1]]);
          break;
      }
      if (snake.first[0] != food[0] || snake.first[1] != food[1]) {
        snake.removeLast();
      } else {
        CreateFood();
      }
    });
  }

  void CreateFood() {
    food = [
      randomGen.nextInt(squaresperRow),
      randomGen.nextInt(squareperColumn)
    ];
  }

  bool CheckGameOver() {
    if (!isPlaying ||
        snake.first[1] < 0 ||
        snake.first[1] >= squareperColumn ||
        snake.first[0] < 0 ||
        snake.first[0] > squaresperRow) {
      return true;
    }
    for (var i = 1; i < snake.length; i++) {
      if (snake[i][0] == snake.first[0] && snake[i][1] == snake.first[1]) {
        return true;
      }
    }
    return false;
  }

  void EndGame() {
    isPlaying = false;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Game Over'),
            content: Text(
              'Score:${snake.length - 2}',
              style: TextStyle(fontSize: 20),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('close'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (direction != 'up' && details.delta.dy > 0) {
                  direction = 'down';
                } else if (direction != 'down' && details.delta.dy < 0) {
                  direction = 'up';
                }
              },
              onHorizontalDragUpdate: (details) {
                if (direction != 'left' && details.delta.dx > 0) {
                  direction = 'right';
                } else if (direction != 'right' && details.delta.dx < 0) {
                  direction = 'left';
                }
              },
              child: AspectRatio(
                aspectRatio: squaresperRow / (squareperColumn + 5),
                child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: squaresperRow),
                    itemCount: squareperColumn * squaresperRow,
                    itemBuilder: (BuildContext context, int index) {
                      var color;
                      var x = index % squaresperRow;
                      var y = (index / squaresperRow).floor();

                      bool isSnakeBody = false;
                      for (var pos in snake) {
                        if (pos[0] == x && pos[1] == y) {
                          isSnakeBody = true;
                          break;
                        }
                      }
                      if (snake.first[0] == x && snake.first[1] == y) {
                        color = Colors.green;
                      } else if (isSnakeBody) {
                        color = Colors.green[200];
                      } else if (food[0] == x && food[1] == y) {
                        color = Color.fromARGB(255, 31, 240, 80);
                      } else {
                        color = Colors.grey[800];
                      }
                      return Container(
                        margin: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    if (isPlaying) {
                      isPlaying = false;
                    } else {
                      StartGame();
                    }
                  },
                  child: Text(
                    isPlaying ? 'End' : 'Start',
                    style: fontstyle,
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Color.fromARGB(255, 227, 21, 21);
                      }
                      return Color.fromARGB(255, 14, 118, 230);
                    }),
                  ),
                ),
                Text(
                  'Score:${snake.length - 2}',
                  style: fontstyle,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
