import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class VideoController extends StatefulWidget {
  final controller;

  VideoController({this.controller});

  @override
  _VideoControllerState createState() => _VideoControllerState();
}

class _VideoControllerState extends State<VideoController> {
  var _duration;
  double? _loading = 0.0;
  late bool _pause;

  void setPause(bool value) {
    setState(() {
      _pause = value;
    });
    value ? widget.controller.pause() : widget.controller.play();
  }

  @override
  void initState() {
    //widget.controller.addListener(_listener);
    Timer.periodic(const Duration(seconds: 1), (callback) {
      if (widget.controller.position != null &&
          widget.controller.sValue.duration != null) {
        _listener();
      }
    });
    _pause = !widget.controller.sValue.isPlaying;
    super.initState();
  }

  void _listener() {
    setState(() {
      _duration = widget.controller.sValue.duration;
      _loading = widget.controller.sValue.position.inSeconds /
          widget.controller.sValue.duration.inSeconds;
      _pause = !widget.controller.sValue.isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _position = widget.controller.sValue.position;
    var _durationString = _position != null && _duration != null
        ? '${_position.inMinutes % 60}:${_position.inSeconds % 60} / ${_duration.inMinutes % 60}:${_duration.inSeconds % 60}'
        : '';

    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.black87,
      child: Column(
        children: <Widget>[
          FittedBox(
            fit: BoxFit.fill,
            child: GestureDetector(
              onTapUp: (detail) {
                var size = MediaQuery.of(context).size.width - 10;
                var position = detail.globalPosition.dx - 10;
                int time = _duration.inMilliseconds;
                time = (time * (position / size)).toInt();
                widget.controller.seekTo(Duration(milliseconds: time));
              },
              child: LinearPercentIndicator(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(0),
                lineHeight: 2.0,
                linearStrokeCap: LinearStrokeCap.butt,
                percent: _loading!,
                progressColor: Colors.red,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () => setPause(!_pause),
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0, top: 2, bottom: 2),
                  child: Icon(
                    _pause ? Icons.play_arrow : Icons.pause,
                    color: Theme.of(context).backgroundColor.withOpacity(0.8),
                    size: 18.0,
                  ),
                ),
              ),
              const SizedBox(
                width: 6,
              ),
              Expanded(
                child: Text(
                  _durationString,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    height: 1.2,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: GestureDetector(
                  onTap: () {
                    widget.controller.seekTo(
                      const Duration(seconds: 0),
                    );
                  },
                  child: Icon(
                    Icons.replay,
                    color: Theme.of(context).backgroundColor,
                    size: 16,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
