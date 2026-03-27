import '/config/colors.dart';
import 'package:flutter/cupertino.dart';

class ScannerAnimatedWidget extends StatefulWidget {
  const ScannerAnimatedWidget({Key? key}) : super(key: key);

  @override
  State<ScannerAnimatedWidget> createState() => _ScannerAnimatedWidgetState();
}

class _ScannerAnimatedWidgetState extends State<ScannerAnimatedWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _animationController?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animateScanAnimation(true);
      } else if (status == AnimationStatus.dismissed) {
        animateScanAnimation(false);
      }
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      animateScanAnimation(false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double rt = MediaQuery.of(context).size.width / 360;
    return ScannerAnimation(false, 270 * rt, animation: _animationController!);
  }

  void animateScanAnimation(bool reverse) {
    if (reverse) {
      _animationController?.reverse(from: 1.0);
    } else {
      _animationController?.forward(from: 0.0);
    }
  }
}

class ScannerAnimation extends AnimatedWidget {
  final bool stopped;
  final double width;

  const ScannerAnimation(
    this.stopped,
    this.width, {
    Key? key,
    required Animation<double> animation,
  }) : super(
          key: key,
          listenable: animation,
        );

  @override
  Widget build(BuildContext context) {
    double rt = MediaQuery.of(context).size.width / 360;
    final Animation<double> animation = listenable as Animation<double>;
    final scorePosition = (animation.value * 228) +
        ((MediaQuery.of(context).size.height - (265)) / 2);
    Color color1 = Col.primary.withOpacity(.3);
    Color color2 = const Color.fromARGB(0, 250, 176, 115);
    if (animation.status == AnimationStatus.reverse) {
      color1 = const Color.fromARGB(0, 241, 189, 133);
      color2 = Col.primary.withOpacity(.3);
    }
    return Positioned(
      bottom: scorePosition,
      left: (MediaQuery.of(context).size.width - (260)) / 2,
      child: Opacity(
        opacity: (stopped) ? 0.0 : 1.0,
        child: Container(
          height: 30.0 * rt,
          width: 260,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.1, 0.9],
              colors: [color1, color2],
            ),
          ),
        ),
      ),
    );
  }
}
