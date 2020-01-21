// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:digital_clock/animated_background.dart';

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Color(0xFFB1DFDC),
  _Element.text: Colors.black,
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
  _Element.shadow: Color(0xFF174EA6),
};

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  var _temperature = '';
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
      _temperature = widget.model.temperatureString;
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    final colors = isLightMode ? _lightTheme : _darkTheme;
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final dayString = DateFormat('EEE, MMM d').format(_dateTime);
    final fontSize = MediaQuery.of(context).size.width / 4;
    final defaultStyle = TextStyle(
        color: colors[_Element.text],
        fontFamily: 'Poppins',
        fontSize: fontSize,
        height: 1.28);

    return Stack(
      children: <Widget>[
        isLightMode
            ? Positioned.fill(child: AnimatedBackground())
            : SizedBox.shrink(),
        Container(
          color: isLightMode ? null : colors[_Element.background],
          child: Center(
            child: DefaultTextStyle(
              style: defaultStyle,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        // TODO: Handle extra conditions
                        widget.model.weatherCondition == WeatherCondition.sunny
                            ? Icons.wb_sunny
                            : Icons.wb_cloudy,
                        size: 40,
                        color: defaultStyle.color,
                      ),
                      Text(
                        _temperature,
                        style:
                            TextStyle(fontSize: 30, color: defaultStyle.color),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height - 150,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(-3, 3))
                              ],
                              borderRadius: BorderRadius.circular(10.0),
                              border: isLightMode
                                  ? null
                                  : Border.all(color: Color(0xFFB1DFDC)),
                              color: isLightMode ? Colors.white : Colors.black),
                          child: Center(
                            child: Text(
                              hour,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: isLightMode
                                      ? Colors.black
                                      : Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height - 150,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12, offset: Offset(-3, 3))
                            ],
                            borderRadius: BorderRadius.circular(10.0),
                            border: isLightMode
                                ? null
                                : Border.all(color: Color(0xFFB1DFDC)),
                            color: isLightMode ? Colors.white : Colors.black),
                        child: Text(
                          minute,
                          style: TextStyle(
                              color: isLightMode
                                  ? Colors.black
                                  : Color(0xFFB1DFDC)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        dayString,
                        style:
                            TextStyle(color: defaultStyle.color, fontSize: 33),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
