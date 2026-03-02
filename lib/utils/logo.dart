import 'dart:math';
import 'package:flutter/material.dart';

class Logo extends StatefulWidget {
  final double size;
  final String image;

  final double? margin;
  final bool setToAnimation;
  final double endAngle;
  final Duration duration;
  final double pivotOffset;

  const Logo({
    super.key,
    required this.size,
    required this.image,
    this.margin,
    this.setToAnimation = false,
    this.endAngle = 0.15,
    this.duration = const Duration(milliseconds: 800),
    this.pivotOffset = -1.2,
  });

  @override
  State<Logo> createState() => _LogoState();
}

class _LogoState extends State<Logo> with TickerProviderStateMixin {
  final Duration _scaleHoldTime = const Duration(milliseconds: 500);

  late AnimationController _swingController;
  late Animation<double> _swingAnimation;

  late AnimationController _sequenceController;
  late AnimationController _springController;

  late Animation<Offset> _moveToCenter;
  late Animation<double> _scaleUp;
  late Animation<double> _shakeAnim;

  final GlobalKey _logoKey = GlobalKey();

  Offset _dragOffset = Offset.zero;

  bool _isAnimating = false;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();

    _swingController = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..value = 0.5;

    _swingAnimation =
        Tween<double>(begin: -widget.endAngle, end: widget.endAngle).animate(
          CurvedAnimation(parent: _swingController, curve: Curves.easeInOut),
        );

    _sequenceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _springController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  void _resetSwingToNeutral() {
    _swingController.stop();
    _swingController.value = 0.5;
  }

  void _startSwing() {
    if (widget.setToAnimation && !_isAnimating && !_isDragging) {
      _swingController.repeat(reverse: true);
    }
  }

  void _stopSwing() {
    if (widget.setToAnimation && !_isAnimating && !_isDragging) {
      _resetSwingToNeutral();
    }
  }

  Future<void> _runSequence() async {
    if (_isAnimating || _isDragging) return;

    final RenderBox box =
        _logoKey.currentContext!.findRenderObject() as RenderBox;

    final Offset widgetPos = box.localToGlobal(Offset.zero);
    final Size widgetSize = box.size;
    final Size screenSize = MediaQuery.of(context).size;

    final Offset screenCenter = Offset(
      screenSize.width / 2 - widgetSize.width / 2,
      screenSize.height / 2 - widgetSize.height / 2,
    );

    final Offset delta = screenCenter - widgetPos;

    _moveToCenter = Tween<Offset>(begin: Offset.zero, end: delta).animate(
      CurvedAnimation(
        parent: _sequenceController,
        curve: const Interval(0.0, 0.25, curve: Curves.easeInOut),
      ),
    );

    _shakeAnim = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(
        parent: _sequenceController,
        curve: const Interval(0.25, 0.5, curve: Curves.linear),
      ),
    );

    _scaleUp = Tween<double>(begin: 1, end: 4).animate(
      CurvedAnimation(
        parent: _sequenceController,
        curve: const Interval(0.5, 0.75, curve: Curves.linear),
      ),
    );

    setState(() => _isAnimating = true);
    _resetSwingToNeutral();

    await _sequenceController.forward();
    await Future.delayed(_scaleHoldTime);
    await _sequenceController.reverse();

    _sequenceController.reset();
    _dragOffset = Offset.zero;

    _resetSwingToNeutral();

    setState(() => _isAnimating = false);
  }

  void _startDrag(DragStartDetails details) {
    if (_isAnimating) return;

    _isDragging = true;
    _resetSwingToNeutral();
  }

  void _updateDrag(DragUpdateDetails details) {
    if (_isAnimating) return;

    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _endDrag(DragEndDetails details) {
    final springAnim = Tween<Offset>(begin: _dragOffset, end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _springController, curve: Curves.elasticOut),
        );

    _springController.addListener(() {
      setState(() {
        _dragOffset = springAnim.value;
      });
    });

    _springController.forward(from: 0).whenComplete(() {
      _springController.reset();
      _dragOffset = Offset.zero;
      _isDragging = false;
      _resetSwingToNeutral();
    });
  }

  @override
  void dispose() {
    _swingController.dispose();
    _sequenceController.dispose();
    _springController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(widget.size / 2),
      child: Image.asset(widget.image, fit: BoxFit.cover),
    );

    return GestureDetector(
      onTap: _runSequence,
      onPanStart: _startDrag,
      onPanUpdate: _updateDrag,
      onPanEnd: _endDrag,
      child: MouseRegion(
        onEnter: (_) => _startSwing(),
        onExit: (_) => _stopSwing(),
        child: Container(
          key: _logoKey,
          margin: EdgeInsets.all(widget.margin ?? 0),
          width: widget.size,
          height: widget.size,
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _swingController,
              _sequenceController,
              _springController,
            ]),
            builder: (context, child) {
              double shakeAngle = 0;

              if (_isAnimating &&
                  _sequenceController.value >= 0.25 &&
                  _sequenceController.value <= 0.5) {
                shakeAngle =
                    sin(_sequenceController.value * 100) * _shakeAnim.value;
              }

              return Transform.translate(
                offset:
                    _dragOffset +
                    (_isAnimating ? _moveToCenter.value : Offset.zero),
                child: Transform.rotate(
                  angle: _isAnimating
                      ? shakeAngle
                      : (_isDragging ? 0 : _swingAnimation.value),
                  alignment: Alignment(0, widget.pivotOffset),
                  child: Transform.scale(
                    scale: _isAnimating ? _scaleUp.value : 1,
                    child: child,
                  ),
                ),
              );
            },
            child: imageWidget,
          ),
        ),
      ),
    );
  }
}
