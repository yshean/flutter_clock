import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class AnimatedBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("color1").add(
        Duration(seconds: 5),
        ColorTween(
          begin: Color(0xFF48D1CC),
          end: Color(0xFF97E0DB),
        ),
      ),
      Track("color2").add(
        Duration(seconds: 5),
        ColorTween(
          begin: Color(0xFFABE5E1),
          end: Colors.yellow[100],
        ),
      )
    ]);

    return ControlledAnimation(
      playback: Playback.MIRROR,
      tween: tween,
      duration: tween.duration,
      builder: (context, animation) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                animation["color1"],
                animation["color2"],
              ],
            ),
          ),
        );
      },
    );
  }
}
