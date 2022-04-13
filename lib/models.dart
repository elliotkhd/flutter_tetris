import 'dart:math';

enum ShapeType { Z, S, T, O, L, J, I }
enum BlockColor { black, white, red }

class Shape {
  ShapeType type;
  int x;
  int y;
  List<BlockStatus> blocks;
  int rotateIndex;

  Shape(this.type, this.x, this.y, {this.rotateIndex = 0})
      : blocks = getBlocksByCoordinates(type, x, y, rotateIndex);

  set setX(int value) {
    x = value;
    blocks = getBlocksByCoordinates(type, x, y, rotateIndex);
  }

  set setY(int value) {
    y = value;
    blocks = getBlocksByCoordinates(type, x, y, rotateIndex);
  }

  int get top {
    int result = 20;
    for (var value in blocks) {
      result = min(value.y, result);
    }
    return result;
  }

  int get bottom {
    int result = 0;
    for (var value in blocks) {
      result = max(value.y, result);
    }
    return result;
  }

  int get left {
    int result = 10;
    for (var value in blocks) {
      result = min(value.x, result);
    }
    return result;
  }

  int get right {
    int result = 0;
    for (var value in blocks) {
      result = max(value.x, result);
    }
    return result;
  }

  int bottomOnX(int x) {
    int result = 0;
    for (var value in blocks) {
      if (value.x == x) result = max(value.y, result);
    }
    return result;
  }

  void moveRight() {
    for (BlockStatus block in blocks) {
      if (block.x + 1 >= 10) return;
    }
    setX = x + 1;
  }

  void moveLeft() {
    for (BlockStatus block in blocks) {
      if (block.x - 1 < 0) return;
    }
    setX = x - 1;
  }

  void moveDown() {
    for (BlockStatus block in blocks) {
      if (block.y + 1 == 20) return;
    }
    setY = y + 1;
  }

  void rotate() {
    rotateIndex++;
    blocks = getBlocksByCoordinates(type, x, y, rotateIndex);
  }

  Shape copyWith({ShapeType? type, int? x, int? y, int? rotateIndex}) =>
      Shape(type ?? this.type, x ?? this.x, y ?? this.y,
          rotateIndex: rotateIndex ?? this.rotateIndex);

  static final offsetMap = <ShapeType, List<List<int>>>{
    ShapeType.I: [
      [-1, 0],
      [0, -1]
    ],
    ShapeType.T: [
      [0, 0],
      [0, 0],
      [0, 1],
      [1, 0]
    ],
    ShapeType.Z: [
      [0, 0],
      [0, 0]
    ],
    ShapeType.S: [
      [0, 0],
      [0, 0]
    ],
    ShapeType.O: [
      [0, 0]
    ],
    ShapeType.L: [
      [0, 0],
      [0, 0],
      [0, 0],
      [0, 0],
    ],
    ShapeType.J: [
      [0, 0],
      [0, 0],
      [0, 0],
      [0, 0],
    ],
  };

  static Map<ShapeType, List<List<List<int>>>> rotateMap = {
    ShapeType.I: [
      [
        [1, 1, 1, 1]
      ],
      [
        [1],
        [1],
        [1],
        [1],
      ]
    ],
    ShapeType.T: [
      [
        [0, 1, 0],
        [1, 1, 1],
      ],
      [
        [0, 1],
        [1, 1],
        [0, 1],
      ],
      [
        [1, 1, 1],
        [0, 1, 0],
      ],
      [
        [1, 0],
        [1, 1],
        [1, 0],
      ],
    ],
    ShapeType.Z: [
      [
        [1, 1, 0],
        [0, 1, 1],
      ],
      [
        [0, 1],
        [1, 1],
        [1, 0],
      ]
    ],
    ShapeType.S: [
      [
        [0, 1, 1],
        [1, 1, 0],
      ],
      [
        [1, 0],
        [1, 1],
        [0, 1],
      ]
    ],
    ShapeType.O: [
      [
        [1, 1],
        [1, 1],
      ]
    ],
    ShapeType.L: [
      [
        [0, 0, 1],
        [1, 1, 1],
      ],
      [
        [1, 1],
        [0, 1],
        [0, 1],
      ],
      [
        [1, 1, 1],
        [1, 0, 0],
      ],
      [
        [1, 0],
        [1, 0],
        [1, 1],
      ],
    ],
    ShapeType.J: [
      [
        [1, 0, 0],
        [1, 1, 1],
      ],
      [
        [0, 1],
        [0, 1],
        [1, 1],
      ],
      [
        [1, 1, 1],
        [0, 0, 1],
      ],
      [
        [1, 1],
        [1, 0],
        [1, 0],
      ],
    ]
  };

  static List<BlockStatus> getBlocksByCoordinates(
      ShapeType type, int x, int y, int rotateIndex) {
    List<BlockStatus> tmpList = [];

    var shapeList = rotateMap[type];
    var fixedRotateIndex = rotateIndex % shapeList!.length;
    List<List<int>> tmp = shapeList[fixedRotateIndex];
    for (int i = 0; i < tmp.length; i++) {
      for (int j = 0; j < tmp[i].length; j++) {
        if (tmp[i][j] == 1) {
          tmpList.add(BlockStatus(x + j + offsetMap[type]![fixedRotateIndex][0],
              y + i + offsetMap[type]![fixedRotateIndex][1]));
        }
      }
    }
    return tmpList;
  }
}

class BlockStatus {
  bool isActivated;

  // bool isLanding;
  int x;
  int y;

  BlockStatus(
    this.x,
    this.y, {
    this.isActivated = true,
    // this.isLanding = true,
  });
}
