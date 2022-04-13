import 'dart:math';

import 'package:get/get.dart';

import 'models.dart';

class GetState {
  late final List<List<Rx<BlockColor>>> map;
  late final List<List<Rx<BlockColor>>> waitingMap;
  late Shape shape;
  late Shape waitingShape;

  var shapeTypeStack = <Rx<ShapeType>>[];

  bool rightTimerStarted = false;
  bool leftTimerStarted = false;
  bool downTimerStarted = false;

  int startLine = 19;

  bool paused = true;
  bool moveHorizontally = false;
  bool moveVertically = false;
  bool looping = false;
  bool movingLines = false;
  bool nearBounce = false;

  final timerDuration = const Duration(milliseconds: 80);
  final delayBeforeStarted = const Duration(milliseconds: 200);
  final autoTimerDuration = const Duration(milliseconds: 300);
  final autoTimerDurationWhenManual = const Duration(milliseconds: 500);

  GetState() {
    map = List.generate(
      20,
      (i) => List.generate(10, (j) {
        if (i >= startLine) {
          return Random().nextInt(10) < 7
              ? BlockColor.black.obs
              : BlockColor.white.obs;
        } else {
          return BlockColor.white.obs;
        }
      }),
    );
    waitingMap = List.generate(
      2,
      (i) => List.generate(4, (j) {
        if (i >= startLine) {
          return Random().nextInt(10) < 7
              ? BlockColor.black.obs
              : BlockColor.white.obs;
        } else {
          return BlockColor.white.obs;
        }
      }),
    );
    shapeTypeStack.addAll([
      ShapeType.values[Random().nextInt(10000) % 7].obs,
      ShapeType.values[Random().nextInt(10000) % 7].obs
    ]);
    initShapeOnTop();
  }

  void initAllBlocks() {
    for (int i = 0; i < 20; i++) {
      for (int j = 0; j < 10; j++) {
        map[i][j].value = i >= startLine
            ? Random().nextInt(10) < 7
                ? BlockColor.black
                : BlockColor.white
            : BlockColor.white;
      }
    }
    initShapeOnTop();
  }

  void initShapeOnTop() {
    ShapeType type = shapeTypeStack.first.value;
    int y = type == ShapeType.I ? 1 : 2;
    shape = Shape(type, 4, -y);
    initShapeOnWaiting();
  }

  void initShapeOnWaiting() {
    ShapeType waitingType = shapeTypeStack.last.value;
    waitingShape = Shape(waitingType,
        (waitingType == ShapeType.I || waitingType == ShapeType.O) ? 1 : 0, 0);
    var blocks = waitingShape.blocks;
    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 4; j++) {
        waitingMap[i][j].value = BlockColor.white;
      }
    }
    for (BlockStatus value in blocks) {
      if (value.y >= 0 && value.y < 2 && value.x >= 0 && value.x < 4) {
        waitingMap[value.y][value.x].value = BlockColor.black;
      }
    }
    shapeTypeStack.first.value = shapeTypeStack.last.value;
    shapeTypeStack.last.value = ShapeType.values[Random().nextInt(10000) % 7];
  }

  final List<List<int>> sampleShapes = [
    [
      0,
      0,
      1,
      ...[1, 0, 1, 1, 1, 0, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0]
    ],
    [
      0,
      1,
      1,
      ...[0, 0, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0]
    ],
    [
      0,
      0,
      0,
      ...[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    ]
  ];
}
