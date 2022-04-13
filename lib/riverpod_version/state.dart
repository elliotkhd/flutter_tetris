import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tetris/models.dart';

class RiverpodVersionState {
  final WidgetRef ref;
  late final List<List<StateProvider<BlockColor>>> map;
  late final List<List<StateProvider<BlockColor>>> waitingMap;

  late Shape shape;
  late Shape waitingShape;
  List<StateProvider<ShapeType>> shapeTypeStack = [];

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

  RiverpodVersionState(this.ref) {
    map = List.generate(
      20,
      (i) => List.generate(10, (j) {
        if (i >= startLine) {
          return Random().nextInt(10) < 7
              ? StateProvider<BlockColor>((ref) => BlockColor.black)
              : StateProvider<BlockColor>((ref) => BlockColor.white);
        } else {
          return StateProvider<BlockColor>((ref) => BlockColor.white);
        }
      }),
    );
    waitingMap = List.generate(
      2,
      (i) => List.generate(4, (j) {
        if (i >= startLine) {
          return Random().nextInt(10) < 7
              ? StateProvider<BlockColor>((ref) => BlockColor.black)
              : StateProvider<BlockColor>((ref) => BlockColor.white);
        } else {
          return StateProvider<BlockColor>((ref) => BlockColor.white);
        }
      }),
    );
    shapeTypeStack.addAll([
      StateProvider<ShapeType>(
          (ref) => ShapeType.values[Random().nextInt(10000) % 7]),
      StateProvider<ShapeType>(
          (ref) => ShapeType.values[Random().nextInt(10000) % 7])
    ]);
    initShapeOnTop();
  }

  void initAllBlocks() {
    for (int i = 0; i < 20; i++) {
      for (int j = 0; j < 10; j++) {
        ref.read(map[i][j].notifier).state = i >= startLine
            ? Random().nextInt(10) < 7
                ? BlockColor.black
                : BlockColor.white
            : BlockColor.white;
      }
    }
    initShapeOnTop();
  }

  void initShapeOnTop() {
    ShapeType type = ref.read(shapeTypeStack.first);
    int y = type == ShapeType.I ? 1 : 2;
    shape = Shape(type, 4, -y);
    initShapeOnWaiting();
  }

  void initShapeOnWaiting() {
    ShapeType waitingType = ref.read(shapeTypeStack.last);
    waitingShape = Shape(waitingType,
        (waitingType == ShapeType.I || waitingType == ShapeType.O) ? 1 : 0, 0);
    var blocks = waitingShape.blocks;
    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 4; j++) {
        ref.read(waitingMap[i][j].state).state = BlockColor.white;
      }
    }
    for (BlockStatus value in blocks) {
      if (value.y >= 0 && value.y < 2 && value.x >= 0 && value.x < 4) {
        ref.read(waitingMap[value.y][value.x].notifier).state =
            BlockColor.black;
      }
    }
    ref.read(shapeTypeStack.first.notifier).state =
        ref.read(shapeTypeStack.last);
    ref.read(shapeTypeStack.last.notifier).state =
        ShapeType.values[Random().nextInt(10000) % 7];
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
