import 'dart:async';

import 'package:flutter_tetris/getx_version/state.dart';
import 'package:get/get.dart';

import '../models.dart';

class GetController extends GetxController {
  GetState state = GetState();
  bool _leftInProcess = false, _rightInProcess = false, _downInProcess = false;

  void startAutoDrop() async {
    state.looping = true;
    while (true) {
      await Future.delayed(state.moveHorizontally
          ? state.autoTimerDurationWhenManual
          : state.autoTimerDuration);
      if (state.paused || state.moveVertically || state.movingLines) continue;
      moveDown();
    }
  }

  void moveDown() async {
    hideShape();
    if (!canMoveDown) {
      cancelAllTimer();
      drawShape();
      await removeCompletedLine();
      state.initShapeOnTop();
      return;
    }
    state.shape.moveDown();
    drawShape();
  }

  bool get canMoveDown {
    for (BlockStatus block in state.shape.blocks) {
      if (block.y + 1 == getFirstBlockBelowShapeInColumnX(block.x)) {
        return false;
      }
    }
    return true;
  }

  void moveRight() {
    hideShape();
    for (BlockStatus block in state.shape.blocks) {
      if (block.x + 1 == getFirstActivatedBlockOnRight(block.x, block.y)) {
        drawShape();
        return;
      }
    }
    state.shape.moveRight();
    drawShape();
  }

  void moveLeft() {
    hideShape();
    for (BlockStatus block in state.shape.blocks) {
      if (block.x - 1 == getFirstActivatedBlockOnLeft(block.x, block.y)) {
        drawShape();
        return;
      }
    }
    state.shape.moveLeft();
    drawShape();
  }

  void rotate() {
    hideShape();
    var tmpShape = state.shape.copyWith();
    tmpShape.rotate();
    for (BlockStatus block in tmpShape.blocks) {
      if (block.y >= 20 ||
          block.x < 0 ||
          block.x >= 10 ||
          (block.y >= 0 &&
              state.map[block.y][block.x].value == BlockColor.black)) {
        drawShape();
        return;
      }
    }
    state.shape.rotate();
    drawShape();
  }

  void drawShape() {
    var blocks = state.shape.blocks;
    for (BlockStatus value in blocks) {
      if (value.y >= 0 && value.y < 20 && value.x >= 0 && value.x < 10) {
        state.map[value.y][value.x].value = BlockColor.black;
      }
    }
  }

  void hideShape() {
    for (BlockStatus value in state.shape.blocks) {
      if (value.y >= 0 && value.y < 20 && value.x >= 0 && value.x < 10) {
        state.map[value.y][value.x].value = BlockColor.white;
      }
    }
  }

  void moveToBottom() async {
    if (state.movingLines) return;
    if (state.paused) {
      state.paused = false;
      if (!state.looping) startAutoDrop();
      return;
    }
    hideShape();
    while (canMoveDown) {
      state.shape.moveDown();
    }
    cancelAllTimer();
    drawShape();
    await shineShape();
    await removeCompletedLine();
    state.initShapeOnTop();
  }

  void moveRightForTimes() async {
    if (state.movingLines) return;
    state.moveHorizontally = true;
    cancelAllTimer();
    moveRight();
    if (_rightInProcess) return;
    _rightInProcess = true;
    state.rightTimerStarted = true;
    await Future.delayed(state.delayBeforeStarted);
    _rightInProcess = true;
    if (!state.rightTimerStarted) {
      _rightInProcess = false;
      return;
    }
    while (state.rightTimerStarted) {
      moveRight();
      await Future.delayed(state.timerDuration);
      _rightInProcess = false;
    }
  }

  void moveLeftForTimes() async {
    if (state.movingLines) return;
    state.moveHorizontally = true;
    cancelAllTimer();
    moveLeft();
    if (_leftInProcess) return;
    _leftInProcess = true;
    state.leftTimerStarted = true;
    await Future.delayed(state.delayBeforeStarted);
    if (!state.leftTimerStarted) {
      _leftInProcess = false;
      return;
    }
    while (state.leftTimerStarted) {
      moveLeft();
      await Future.delayed(state.timerDuration);
      _leftInProcess = false;
    }
  }

  void moveDownForTimes() async {
    if (state.movingLines) return;
    state.moveVertically = true;
    cancelAllTimer();
    moveDown();
    if (_downInProcess) return;
    _downInProcess = true;
    state.downTimerStarted = true;
    await Future.delayed(state.delayBeforeStarted);
    if (!state.downTimerStarted) {
      _downInProcess = false;
      return;
    }
    while (state.downTimerStarted) {
      moveDown();
      await Future.delayed(state.timerDuration);
      _downInProcess = false;
    }
  }

  void cancelAllTimer() {
    state.downTimerStarted = false;
    state.leftTimerStarted = false;
    state.rightTimerStarted = false;
  }

  Future removeCompletedLine() async {
    state.movingLines = true;
    List<int>? completedLines = [];
    for (int i = 0; i < 20; i++) {
      if (isLineCompleted(state.map[i])) {
        completedLines.add(i);
      }
    }

    if (completedLines.isEmpty) {
      state.movingLines = false;
      return;
    }
    await shineLines(completedLines);
    for (int i = 19; i >= 0; i--) {
      int emptyLinesBelow =
          completedLines.where((element) => element > i).length;
      moveLineDownward(i, emptyLinesBelow);
    }
    state.paused = false;
    state.movingLines = false;
  }

  Future shineShape() async {
    state.movingLines = true;
    for (var value in (state.shape.blocks)) {
      state.map[value.y][value.x].value = BlockColor.red;
    }
    await Future.delayed(const Duration(milliseconds: 70));
    for (var value in (state.shape.blocks)) {
      state.map[value.y][value.x].value = BlockColor.black;
    }
    state.movingLines = false;
  }

  Future shineLines(List<int> lines) async {
    state.paused = true;
    for (var value in lines) {
      for (var value1 in (state.map[value])) {
        value1.value = BlockColor.red;
      }
    }
    for (int i = 0; i < 7; i++) {
      await Future.delayed(const Duration(milliseconds: 70));
      for (var value in lines) {
        for (var value1 in (state.map[value])) {
          value1.value = value1.value == BlockColor.red
              ? BlockColor.white
              : BlockColor.red;
        }
      }
    }
  }

  void moveLineDownward(int y, int num) {
    var tmpLineY = [...state.map[y]];
    for (int i = 0; i < 10; i++) {
      state.map[y + num][i].value = tmpLineY[i].value;
    }
  }

  void moveLine(int from, int to) {
    for (int i = 0; i < 10; i++) {
      state.map[to][i] = state.map[from][i];
    }
  }

  bool isLineCompleted(List<Rx<BlockColor>> line) {
    for (Rx<BlockColor> value in line) {
      if (value.value == BlockColor.white) {
        return false;
      }
    }
    return true;
  }

  int getFirstBlockBelowShapeInColumnX(int x) {
    for (int i = state.shape.bottomOnX(x) + 1; i < 20; i++) {
      if (state.map[i][x].value == BlockColor.black) {
        return i;
      }
    }
    return 20;
  }

  int getFirstActivatedBlockOnRight(int x, int y) {
    for (int i = x; i < 10; i++) {
      if (y >= 0 && state.map[y][i].value == BlockColor.black) {
        return i;
      }
    }
    return 10;
  }

  int getFirstActivatedBlockOnLeft(int x, int y) {
    for (int i = x; i >= 0; i--) {
      if (y >= 0 && state.map[y][i].value == BlockColor.black) {
        return i;
      }
    }
    return 10;
  }

  void turnAround() async {
    for (int i = 0; i < 20; i++) {
      for (int j = 0; j < 10; j++) {
        state.map[i][j].value = BlockColor.white;
      }
    }
    await Future.delayed(const Duration(milliseconds: 5));
    for (int i = 0; i < 20; i++) {
      for (int j = 0; j < 10; j++) {
        state.map[i][j].value = BlockColor.black;
      }
    }
  }
}
