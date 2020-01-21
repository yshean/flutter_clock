import 'package:flutter/material.dart';
import 'package:digital_clock/digital_clock.dart';

class TimeBox extends StatelessWidget {
  final Map<UiElement, Color> colors;
  final String hourOrMin;

  TimeBox(this.colors, this.hourOrMin);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 150,
      width: MediaQuery.of(context).size.width / 2.8,
      decoration: BoxDecoration(
        boxShadow: colors[UiElement.shadow] == null
            ? []
            : [
                BoxShadow(
                    color: colors[UiElement.shadow], offset: Offset(-3, 3))
              ],
        borderRadius: BorderRadius.circular(10.0),
        border: colors[UiElement.border] == null
            ? null
            : Border.all(color: colors[UiElement.border]),
        color: colors[UiElement.boxColor],
      ),
      child: Center(
        child: Text(
          hourOrMin,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: colors[UiElement.text],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
