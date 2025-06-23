import 'dart:math';
import 'package:flutter/material.dart';

class LadderGamePage extends StatefulWidget {
  @override
  State<LadderGamePage> createState() => _LadderGamePageState();
}

class _LadderGamePageState extends State<LadderGamePage> with SingleTickerProviderStateMixin {
  int pillars = 3;
  int winners = 2;
  final int steps = 16;
  late List<List<bool>> ladder;
  late List<int> results;
  late List<String> resultLabels;
  late AnimationController _controller;
  bool showLadder = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });
    _resetGame();
  }

  void _resetGame() {
    showLadder = false;
    ladder = List.generate(steps, (i) =>
      i == 0 || i == steps - 1
        ? List.generate(pillars - 1, (_) => false)
        : List.generate(pillars - 1, (_) => false)
    );
    _generateLadder();
    _generateResults();
    _controller.reset();
  }

  void _startLadder() async {
    setState(() {
      showLadder = true;
      _controller.reset();
    });
    await Future.delayed(const Duration(milliseconds: 500));
    _controller.forward(from: 0);
  }

  void _generateLadder() {
    final random = Random();
    for (int i = 1; i < steps - 1; i++) {
      for (int j = 0; j < pillars - 1; j++) {
        if (j > 0 && ladder[i][j - 1]) continue;
        ladder[i][j] = random.nextBool();
      }
    }
  }

  void _generateResults() {
    List<String> labels = List.generate(pillars - winners, (_) => '꽝');
    labels.addAll(List.generate(winners, (i) => '당첨'));
    labels.shuffle();

    List<int> pos = List.generate(pillars, (i) => i);
    for (int i = 0; i < steps; i++) {
      for (int j = 0; j < pillars - 1; j++) {
        if (ladder[i][j]) {
          int temp = pos[j];
          pos[j] = pos[j + 1];
          pos[j + 1] = temp;
        }
      }
    }
    results = pos;
    resultLabels = labels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('사다리 타기 게임')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Text('인원 수:'),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: pillars,
                  items: List.generate(10, (i) => i + 2)
                      .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                      .toList(),
                  onChanged: (v) {
                    if (v != null && v > 1) {
                      setState(() {
                        pillars = v;
                        if (winners > pillars) winners = pillars;
                        _resetGame();
                      });
                    }
                  },
                ),
                const SizedBox(width: 24),
                const Text('당첨자 수:'),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: winners,
                  items: List.generate(pillars, (i) => i + 1)
                      .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                      .toList(),
                  onChanged: (v) {
                    if (v != null && v <= pillars) {
                      setState(() {
                        winners = v;
                        _resetGame();
                      });
                    }
                  },
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _resetGame,
                  child: const Text('초기화'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: showLadder ? null : _startLadder,
                  child: const Text('시작'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const double verticalMargin = 40;
                  const double horizontalMargin = 24;
                  final width = constraints.maxWidth - horizontalMargin * 2;
                  final height = constraints.maxHeight - verticalMargin * 2;

                  return Stack(
                    children: [
                      Positioned(
                        left: horizontalMargin,
                        top: verticalMargin,
                        right: horizontalMargin,
                        bottom: verticalMargin,
                        child: showLadder
                            ? CustomPaint(
                                painter: LadderPainter(
                                  ladder,
                                  _controller.value,
                                  pillars,
                                  resultLabels: resultLabels,
                                  results: results,
                                ),
                                child: Container(),
                              )
                            : Center(
                                child: Text(
                                  '시작 버튼을 누르면 사다리가 그려집니다!',
                                  style: TextStyle(fontSize: 18, color: Colors.grey),
                                ),
                              ),
                      ),
                      // 인원 라벨 (맨 위)
                      Positioned(
                        left: horizontalMargin,
                        right: horizontalMargin,
                        top: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            pillars,
                            (i) => Container(
                              width: 60,
                              alignment: Alignment.center,
                              child: Text(
                                '인원 ${i + 1}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // 결과 라벨 (맨 아래)
                      Positioned(
                        left: horizontalMargin,
                        right: horizontalMargin,
                        bottom: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            pillars,
                            (i) => Container(
                              width: 60,
                              alignment: Alignment.center,
                              child: Text(
                                showLadder
                                    ? resultLabels[results[i]]
                                    : '?',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: showLadder && resultLabels[results[i]] == '당첨'
                                      ? Colors.red
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class LadderPainter extends CustomPainter {
  final List<List<bool>> ladder;
  final double progress;
  final int pillars;
  final List<String> resultLabels;
  final List<int> results;

  LadderPainter(
    this.ladder,
    this.progress,
    this.pillars, {
    required this.resultLabels,
    required this.results,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    final double width = size.width;
    final double height = size.height;
    final double stepHeight = height / (ladder.length - 1);
    final double pillarGap = width / (pillars - 1);

    // 세로줄
    for (int i = 0; i < pillars; i++) {
      final x = pillarGap * i;
      canvas.drawLine(Offset(x, 0), Offset(x, height), paint);
    }

    // 가로줄을 하나씩 그리기 위한 계산
    int totalLines = 0;
    for (int i = 1; i < ladder.length - 1; i++) {
      for (int j = 0; j < ladder[i].length; j++) {
        if (ladder[i][j]) totalLines++;
      }
    }
    int linesToDraw = (totalLines * progress).floor();
    int drawn = 0;

    // 가로줄 (애니메이션: 한 줄씩)
    for (int i = 1; i < ladder.length - 1; i++) {
      for (int j = 0; j < ladder[i].length; j++) {
        if (ladder[i][j]) {
          if (drawn >= linesToDraw) return;
          final x1 = pillarGap * j;
          final x2 = pillarGap * (j + 1);
          final y = stepHeight * i;
          canvas.drawLine(Offset(x1, y), Offset(x2, y), paint);
          drawn++;
        }
      }
    }

    // 모든 '당첨' 인원의 경로를 빨간색으로 표시 (모든 가로줄이 다 그려졌을 때만)
    if (drawn == totalLines) {
      for (int i = 0; i < pillars; i++) {
        int resultIdx = results[i];
        if (resultLabels[resultIdx] == '당첨') {
          int x = i;
          int currX = x;
          List<Offset> personPath = [Offset(pillarGap * currX, 0)];
          for (int step = 0; step < ladder.length; step++) {
            double y = stepHeight * step;
            personPath.add(Offset(pillarGap * currX, y));
            if (step < ladder.length - 1) {
              if (currX < pillars - 1 && ladder[step][currX]) {
                currX++;
                personPath.add(Offset(pillarGap * currX, y));
              } else if (currX > 0 && ladder[step][currX - 1]) {
                currX--;
                personPath.add(Offset(pillarGap * currX, y));
              }
            }
          }
          final pathPaint = Paint()
            ..color = Colors.red
            ..strokeWidth = 4
            ..style = PaintingStyle.stroke;
          final pathObj = Path();
          if (personPath.isNotEmpty) {
            pathObj.moveTo(personPath[0].dx, personPath[0].dy);
            for (var p in personPath.skip(1)) {
              pathObj.lineTo(p.dx, p.dy);
            }
            canvas.drawPath(pathObj, pathPaint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant LadderPainter oldDelegate) {
    return oldDelegate.ladder != ladder ||
        oldDelegate.progress != progress ||
        oldDelegate.pillars != pillars ||
        oldDelegate.resultLabels != resultLabels ||
        oldDelegate.results != results;
  }
}