// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// Use of weather_icons is governed by the MIT license that can be
// found in the weather_icons.LICENSE file.

import 'dart:async';

import 'package:digital_clock/time_box.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:digital_clock/animated_background.dart';
import 'package:weather_icons/weather_icons.dart';

enum UiElement { background, text, shadow, border, boxColor }

final _lightTheme = {
  UiElement.background: null,
  UiElement.text: Colors.black,
  UiElement.shadow: Colors.black12,
  UiElement.border: null,
  UiElement.boxColor: Colors.white
};

final _darkTheme = {
  UiElement.background: Colors.black,
  UiElement.text: Colors.white,
  UiElement.shadow: null,
  UiElement.border: Color(0xFFB1DFDC),
  UiElement.boxColor: Colors.black
};

class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  String _temperature = '';
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

  IconData _getWeatherIcon() {
    switch (widget.model.weatherCondition) {
      case WeatherCondition.cloudy:
        return WeatherIcons.cloudy;
        break;
      case WeatherCondition.foggy:
        return WeatherIcons.fog;
        break;
      case WeatherCondition.rainy:
        return WeatherIcons.rain;
        break;
      case WeatherCondition.snowy:
        return WeatherIcons.snow;
        break;
      case WeatherCondition.sunny:
        // not sure how to get the sunset time
        // so it will always show the sun when it is sunny
        return WeatherIcons.day_sunny;
        break;
      case WeatherCondition.thunderstorm:
        return WeatherIcons.thunderstorm;
        break;
      case WeatherCondition.windy:
        return WeatherIcons.wind;
        break;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final String minute = DateFormat('mm').format(_dateTime);
    final String dayString = DateFormat('EEE, MMM d yyyy').format(_dateTime);

    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    final Map<UiElement, Color> colors = isLightMode ? _lightTheme : _darkTheme;

    final double defaultFontSize = MediaQuery.of(context).size.width / 4;
    final double weatherIconSize = defaultFontSize / 5;
    final TextStyle defaultStyle = TextStyle(
        color: colors[UiElement.text],
        fontFamily: 'Poppins',
        fontSize: defaultFontSize,
        height: 1.28);
    final TextStyle temperatureStyle =
        defaultStyle.copyWith(fontSize: defaultFontSize / 5);
    final TextStyle dayStringStyle =
        defaultStyle.copyWith(fontSize: defaultFontSize / 4.5);

    return Stack(
      children: <Widget>[
        isLightMode
            ? Positioned.fill(child: AnimatedBackground())
            : SizedBox.shrink(),
        Container(
          color: colors[UiElement.background],
          child: Center(
            child: DefaultTextStyle(
              style: defaultStyle,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      BoxedIcon(
                        _getWeatherIcon(),
                        size: weatherIconSize,
                      ),
                      Text(
                        _temperature,
                        style: temperatureStyle,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: TimeBox(colors, hour),
                      ),
                      TimeBox(colors, minute)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        dayString,
                        style: dayStringStyle,
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
