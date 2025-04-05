import 'package:flutter/material.dart';

class TimerController extends ValueNotifier<bool>{
  TimerController({bool isPlaying = false}):super(isPlaying);

  void startTimer() => value = true;
  void stopTime() => value = false;
}

class Timer extends StatefulWidget {
  final TimerController controller;
  const Timer({Key? key,required this.controller}) : super(key: key);

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> {

  Duration duration  = const Duration();

  Timer? timer;

  /*@override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      if(widget.controller.value){
        startTimer();
      }else{
        stopTime();
      }
    });
  }

  void reset() => setState(() {
    duration = const Duration();
  });

  void addTime(){
    const addSeconds =1;
    setState(() {
      final seconds = duration.inSeconds +addSeconds;
      if(seconds < 0){
        timer?.cancel();
      }else{
        duration = Duration(seconds: seconds);
      }
    });
  }

  void startTimer({bool resets = true}){
    if(!mounted) return;
    if(resets){
      reset();
    }

    timer = Timer.pe
  }

  void stopTime({bool resets = true}){
    if(!mounted) return;
    if(resets){
      reset();
    }

    setState(() {
      timer?.cancel();
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
