import 'package:flutter/material.dart';
import 'package:digital_clock/digital_clock.dart';

enum ValueType { hour, minute }

class TimeBox extends StatelessWidget {
  final Map<UiElement, Color> colors;
  final ValueType valueType;
  final String value;

  TimeBox(this.colors, this.valueType, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
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
          value,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: colors[UiElement.text],
          ),
          textAlign: TextAlign.center,
          semanticsLabel: '$value $valueType',
        ),
      ),
    );
  }
}
