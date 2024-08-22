import 'package:flutter/material.dart';
import 'dart:math';

class Sunflower extends StatefulWidget {
  const Sunflower({Key? key}) : super(key: key);

  @override
  _SunflowerState createState() => _SunflowerState();
}

class _SunflowerState extends State<Sunflower> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  final int count = 10; // Number of sunflowers around the center

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      count,
      (index) => AnimationController(
        duration: const Duration(seconds: 2),
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.8, end: 1.2).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    _startAnimations();
  }

  void _startAnimations() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 500), () {
        _controllers[i].repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = 150.0; // Increased radius for more spread out effect

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Center sunflower
          Positioned(
            left: centerX - 140,
            top: centerY - 150,
            child: const Image(
              image: AssetImage("assets/sunf.png"),
              width: 300,
              height: 300,
            ),
          ),
          // Sunflowers surrounding the center, appearing one by one
          for (int i = 0; i < count; i++)
            Positioned(
              left: centerX + radius * cos(2 * pi * i / count) - 100,
              top: centerY + radius * sin(2 * pi * i / count) - 100,
              child: AnimatedBuilder(
                animation: _animations[i],
                builder: (context, child) {
                  return Transform.scale(
                    scale: _animations[i].value,
                    child: child,
                  );
                },
                child: const Image(
                  image: AssetImage("assets/sunf.png"),
                  width: 200,
                  height: 200,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
