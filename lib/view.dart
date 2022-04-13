import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';
import 'models.dart';

const blockWidth = 13.0;
const lineWidth = blockWidth * 0.5;

class GetVersionPage extends StatelessWidget {
  const GetVersionPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  final controller = Get.put(GetController());

  _Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      color: const Color(0xffeac216),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _GameAreaFrame(
            controller: controller,
            child: const _GameArea(),
          ),
          _ControlArea(controller: controller),
        ],
      ),
    );
  }
}

class _GameAreaFrame extends StatelessWidget {
  const _GameAreaFrame({
    Key? key,
    required this.controller,
    required this.child,
  }) : super(key: key);

  final GetController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: controller.state.sampleShapes
                    .map((e) => Column(
                          children: e
                              .map((e1) => SizedBox(
                                    height: blockWidth,
                                    width: blockWidth,
                                    child: e1 == 1 ? _blackBlock : null,
                                  ))
                              .toList(),
                        ))
                    .toList(),
              ),
              Flexible(
                  child: SizedBox(
                height: 27 * blockWidth,
                child: Stack(
                  children: [
                    const Align(
                      alignment: Alignment(-1, 0),
                      child: SizedBox(
                        height: double.infinity,
                        width: lineWidth,
                        child: ColoredBox(color: Colors.black),
                      ),
                    ),
                    const Align(
                      alignment: Alignment(1, 0),
                      child: SizedBox(
                        height: double.infinity,
                        width: lineWidth,
                        child: ColoredBox(color: Colors.black),
                      ),
                    ),
                    const Align(
                      alignment: Alignment(0, 1),
                      child: SizedBox(
                        height: lineWidth,
                        width: double.infinity,
                        child: ColoredBox(color: Colors.black),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0, -1),
                      child: SizedBox(
                        // height: lineWidth,
                        width: double.infinity,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const SizedBox(
                                height: lineWidth,
                                width: 5 * lineWidth,
                                child: ColoredBox(color: Colors.black)),
                            Row(
                              children: List.generate(
                                  4,
                                  (index) => Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            SizedBox(
                                              height: lineWidth,
                                              width: lineWidth,
                                            ),
                                            SizedBox(
                                                height: lineWidth,
                                                width: lineWidth,
                                                child: ColoredBox(
                                                    color: Colors.black)),
                                          ])),
                            ),
                            const Expanded(child: SizedBox()),
                            Row(
                              children: List.generate(
                                  4,
                                  (index) => Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            SizedBox(
                                                height: lineWidth,
                                                width: lineWidth,
                                                child: ColoredBox(
                                                    color: Colors.black)),
                                            SizedBox(
                                              height: lineWidth,
                                              width: lineWidth,
                                            ),
                                          ])),
                            ),
                            const SizedBox(
                                height: lineWidth,
                                width: 5 * lineWidth,
                                child: ColoredBox(color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0, 0),
                      child: child,
                    ),
                  ],
                ),
              )),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: controller.state.sampleShapes.reversed
                    .map((e) => Column(
                          children: e
                              .map((e1) => SizedBox(
                                    height: blockWidth,
                                    width: blockWidth,
                                    child: e1 == 1 ? _blackBlock : null,
                                  ))
                              .toList(),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
        const Align(
          alignment: Alignment(0, -1),
          child: ColoredBox(
            color: Color(0xffeac216),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                '俄罗斯方块',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GameArea extends StatelessWidget {
  const _GameArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: const BoxDecoration(
        color: Color(0xff8d9f73),
        border: Border(
            bottom: BorderSide(width: 5, color: Color(0xfff9e05a)),
            left: BorderSide(width: 5, color: Color(0xff856d0f)),
            right: BorderSide(width: 5, color: Color(0xfff9e05a)),
            top: BorderSide(width: 5, color: Color(0xff856d0f))),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RussiaArea(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [_ScoreBoard()],
          ),
        ],
      ),
    );
  }
}

class _ControlArea extends StatelessWidget {
  const _ControlArea({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final GetController controller;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _ControlButton(
                      color: const Color(0xff2bbd1a),
                      onTap: () =>
                          controller.state.paused = !controller.state.paused,
                      onTapDown: (detail) {},
                      onTapUp: (detail) {},
                      type: 3,
                      text: '暂停',
                    ),
                    _ControlButton(
                      color: const Color(0xff2bbd1a),
                      onTap: controller.turnAround,
                      onTapDown: (detail) {},
                      onTapUp: (detail) {},
                      type: 3,
                      text: '音效',
                    ),
                    _ControlButton(
                      color: const Color(0xffd10015),
                      onTap: controller.state.initAllBlocks,
                      onTapDown: (detail) {},
                      onTapUp: (detail) {},
                      type: 3,
                      text: '重玩',
                    ),
                  ],
                ),
                _ControlButton(
                  color: const Color(0xff4749ee),
                  onTap: controller.moveToBottom,
                  onTapDown: (detail) {},
                  onTapUp: (detail) {},
                  type: 1,
                  text: '掉落',
                ),
              ],
            ),
          ),
          Expanded(
              child: SizedBox(
            height: 200,
            child: Stack(
              children: [
                Align(
                  child: _ControlButton(
                    color: const Color(0xff4749ee),
                    onTapDown: (detail) => controller.rotate(),
                    onTapUp: (detail) {},
                    onTap: () {},
                    // text: '旋转',
                  ),
                  alignment: const Alignment(0, -1),
                ),
                Align(
                  child: _ControlButton(
                    color: const Color(0xff4749ee),
                    onTapDown: (detail) => controller.moveDownForTimes(),
                    onTapUp: (detail) {
                      controller.state.downTimerStarted = false;
                      controller.state.moveVertically = false;
                    },
                    text: '下移',
                  ),
                  alignment: const Alignment(0, 1),
                ),
                Align(
                  child: _ControlButton(
                    color: const Color(0xff4749ee),
                    onTapDown: (detail) => controller.moveRightForTimes(),
                    onTapUp: (detail) {
                      controller.state.rightTimerStarted = false;
                      controller.state.moveHorizontally = false;
                    },
                    text: '右移',
                  ),
                  alignment: const Alignment(1, 0),
                ),
                Align(
                  child: _ControlButton(
                    color: const Color(0xff4749ee),
                    onTapDown: (detail) => controller.moveLeftForTimes(),
                    onTapUp: (detail) {
                      controller.state.leftTimerStarted = false;
                      controller.state.moveHorizontally = false;
                    },
                    text: '左移',
                  ),
                  alignment: const Alignment(-1, 0),
                ),
                Align(
                  child: Transform.scale(
                    scaleX: 2,
                    child: const Icon(Icons.arrow_left),
                  ),
                  alignment: const Alignment(-0.15, -0.1),
                ),
                Align(
                  child: Transform.scale(
                    scaleX: 2,
                    child: const Icon(Icons.arrow_right),
                  ),
                  alignment: const Alignment(0.15, -0.1),
                ),
                Align(
                  child: Transform.scale(
                    scaleY: 2,
                    child: const Icon(Icons.arrow_drop_up),
                  ),
                  alignment: const Alignment(0, -0.23),
                ),
                Align(
                  child: Transform.scale(
                    scaleY: 2,
                    child: const Icon(Icons.arrow_drop_down),
                  ),
                  alignment: const Alignment(0, 0.03),
                ),
                const Align(
                  child: Text('旋转'),
                  alignment: Alignment(0.6, -0.9),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _ControlButton extends StatefulWidget {
  const _ControlButton({
    Key? key,
    required this.color,
    required this.onTapDown,
    required this.onTapUp,
    this.onTap,
    this.type = 2,
    this.text,
  })  : size = type == 1
            ? 100
            : type == 2
                ? 65
                : 33,
        super(key: key);

  final VoidCallback? onTap;
  final GestureTapDownCallback onTapDown;
  final GestureTapUpCallback onTapUp;
  final double size;
  final Color color;
  final String? text;

  /// 1-big 2-normal 3-small
  final int type;

  @override
  State<_ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<_ControlButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTapDown: (detail) {
            widget.onTapDown(detail);
            setState(() => _pressed = true);
          },
          onTap: widget.onTap,
          onTapCancel: () => setState(() => _pressed = false),
          onTapUp: (detail) {
            widget.onTapUp(detail);
            setState(() => _pressed = false);
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  colors: _pressed
                      ? [Colors.black, Colors.white]
                      : [Colors.white, Colors.black],
                  begin: const Alignment(0, -1),
                  end: const Alignment(0, 1)),
            ),
            child: Container(
              height: widget.size,
              width: widget.size,
              decoration: BoxDecoration(
                border: Border.all(width: 0.5),
                shape: BoxShape.circle,
                color: widget.color,
                gradient: RadialGradient(colors: [
                  widget.color,
                  widget.color.withOpacity(0.3),
                ], stops: [
                  widget.type == 1
                      ? 0.85
                      : widget.type == 2
                          ? 0.8
                          : 0.68,
                  1
                ]),
              ),
            ),
          ),
        ),
        Text(widget.text ?? ''),
      ],
    );
  }
}

class _ScoreBoard extends StatefulWidget {
  _ScoreBoard({Key? key}) : super(key: key);

  final controller = Get.find<GetController>();

  @override
  State<_ScoreBoard> createState() => _ScoreBoardState();
}

class _ScoreBoardState extends State<_ScoreBoard> {
  final bool _isShowingBestScore = true;

  @override
  void initState() {
    // Timer.periodic(
    //     const Duration(seconds: 2),
    //     (timer) => setState(() {
    //           _isShowingBestScore = !_isShowingBestScore;
    //         }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: Column(
        children: [
          Text(_isShowingBestScore ? '最高分' : '上轮得分'),
          SizedBox(
            width: blockWidth * 10,
            child: Column(
              children: widget.controller.state.waitingMap
                  .asMap()
                  .values
                  .map(
                    (e) => Row(
                      children: [
                        ...e.map((e2) => _Block(blockColor: e2)).toList()
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _RussiaArea extends StatelessWidget {
  final state = Get.find<GetController>().state;

  _RussiaArea({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1.5),
      decoration:
          BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
      child: SizedBox(
        width: blockWidth * 10,
        height: blockWidth * 20,
        child: Column(
          children: state.map
              .asMap()
              .values
              .map(
                (e) => Row(
                  children: [...e.map((e2) => _Block(blockColor: e2)).toList()],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _Block extends StatelessWidget {
  _Block({
    required this.blockColor,
    Key? key,
  }) : super(key: key);

  final Rx<BlockColor> blockColor;
  final whiteColor = Colors.black.withOpacity(0.2);
  final redColor = Colors.black.withRed(100);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: blockWidth,
      height: blockWidth,
      child: Obx(() {
        return blockColor.value == BlockColor.black
            ? _blackBlock
            : blockColor.value == BlockColor.white
                ? _whiteBlock
                : _redBlock;
      }),
    );
  }
}

const _blackBlock = Padding(
  padding: EdgeInsets.all(0.5),
  child: DecoratedBox(
    decoration: BoxDecoration(
      border: Border.fromBorderSide(
        BorderSide(color: Colors.black, width: 1.5),
      ),
    ),
    child: Padding(
      padding: EdgeInsets.all(2.5),
      child: ColoredBox(
        color: Colors.black,
        child: SizedBox(
          height: 7,
          width: 7,
        ),
      ),
    ),
  ),
);

const _whiteBlock = Padding(
  padding: EdgeInsets.all(0.5),
  child: DecoratedBox(
    decoration: BoxDecoration(
      border: Border.fromBorderSide(
        BorderSide(color: Color(0x33000000), width: 1.5),
      ),
    ),
    child: Padding(
      padding: EdgeInsets.all(2.5),
      child: ColoredBox(
        color: Color(0x33000000),
        child: SizedBox(
          height: 7,
          width: 7,
        ),
      ),
    ),
  ),
);
const _redBlock = Padding(
  padding: EdgeInsets.all(0.5),
  child: DecoratedBox(
    decoration: BoxDecoration(
      border: Border.fromBorderSide(
        BorderSide(color: Color(0xff440000), width: 1.5),
      ),
    ),
    child: Padding(
      padding: EdgeInsets.all(2.5),
      child: ColoredBox(
        color: Color(0xff440000),
        child: SizedBox(
          height: 7,
          width: 7,
        ),
      ),
    ),
  ),
);
