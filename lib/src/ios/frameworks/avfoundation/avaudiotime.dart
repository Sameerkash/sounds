// Generated by @dartnative/codegen:
// https://www.npmjs.com/package/@dartnative/codegen

import 'dart:ffi';

import 'package:dart_native/dart_native.dart';
import 'package:dart_native_gen/dart_native_gen.dart';

import 'avaudioframeposition.dart';
import 'hacks.dart';
// You can uncomment this line when this package is ready.
// import 'package:avfaudio/avaudiotypes.dart';

@NativeAvailable(macos: '10.10', ios: '8.0', watchos: '2.0', tvos: '9.0')
@native
class AVAudioTime extends NSObject {
  AVAudioTime([Class isa]) : super(isa ?? Class('AVAudioTime'));
  AVAudioTime.fromPointer(Pointer<Void> ptr) : super.fromPointer(ptr);

  bool get hostTimeValid {
    return perform(SEL('hostTimeValid')) as bool;
  }

  set hostTimeValid(bool hostTimeValid) =>
      perform(SEL('setHostTimeValid:'), args: <dynamic>[hostTimeValid]);

  int get hostTime {
    return perform(SEL('hostTime')) as int;
  }

  set hostTime(int hostTime) =>
      perform(SEL('setHostTime:'), args: <dynamic>[hostTime]);

  bool get sampleTimeValid {
    return perform(SEL('sampleTimeValid')) as bool;
  }

  set sampleTimeValid(bool sampleTimeValid) =>
      perform(SEL('setSampleTimeValid:'), args: <dynamic>[sampleTimeValid]);

  AVAudioFramePosition get sampleTime {
    Pointer<Void> result =
        perform(SEL('sampleTime'), decodeRetVal: false) as Pointer<Void>;
    return AVAudioFramePosition.fromPointer(result);
  }

  set sampleTime(AVAudioFramePosition sampleTime) =>
      perform(SEL('setSampleTime:'), args: <dynamic>[sampleTime]);

  double get sampleRate {
    return perform(SEL('sampleRate')) as double;
  }

  set sampleRate(double sampleRate) =>
      perform(SEL('setSampleRate:'), args: <dynamic>[sampleRate]);

  // AudioTimeStamp get audioTimeStamp {
  //   Pointer<Void> result =
  //       perform(SEL('audioTimeStamp'), decodeRetVal: false) as Pointer<Void>;
  //   return AudioTimeStamp.fromPointer(result);
  // }

  // set audioTimeStamp(AudioTimeStamp audioTimeStamp) =>
  //     perform(SEL('setAudioTimeStamp:'), args: <dynamic>[audioTimeStamp]);
  // AVAudioTime.initWithAudioTimeStampSampleRate(
  //     AudioTimeStamp ts, double sampleRate)
  //     : super.fromPointer(_initWithAudioTimeStampSampleRate(ts, sampleRate));

  // static Pointer<Void> _initWithAudioTimeStampSampleRate(
  //     AudioTimeStamp ts, double sampleRate) {
  //   Pointer<Void> target = alloc(Class('AVAudioTime'));
  //   SEL sel = SEL('initWithAudioTimeStamp:sampleRate:');
  //   return msgSend(target, sel,
  //       args: <dynamic>[ts, sampleRate], decodeRetVal: false) as Pointer<Void>;
  // }

  AVAudioTime.initWithHostTime(int hostTime)
      : super.fromPointer(_initWithHostTime(hostTime));

  static Pointer<Void> _initWithHostTime(int hostTime) {
    Pointer<Void> target = alloc(Class('AVAudioTime'));
    SEL sel = SEL('initWithHostTime:');
    return msgSend(target, sel, args: <dynamic>[hostTime], decodeRetVal: false)
        as Pointer<Void>;
  }

  AVAudioTime.initWithSampleTimeAtRate(
      AVAudioFramePosition sampleTime, double sampleRate)
      : super.fromPointer(_initWithSampleTimeAtRate(sampleTime, sampleRate));

  static Pointer<Void> _initWithSampleTimeAtRate(
      AVAudioFramePosition sampleTime, double sampleRate) {
    Pointer<Void> target = alloc(Class('AVAudioTime'));
    SEL sel = SEL('initWithSampleTime:atRate:');
    return msgSend(target, sel,
        args: <dynamic>[sampleTime, sampleRate],
        decodeRetVal: false) as Pointer<Void>;
  }

  AVAudioTime.initWithHostTimeSampleTimeAtRate(
      int hostTime, AVAudioFramePosition sampleTime, double sampleRate)
      : super.fromPointer(_initWithHostTimeSampleTimeAtRate(
            hostTime, sampleTime, sampleRate));

  static Pointer<Void> _initWithHostTimeSampleTimeAtRate(
      int hostTime, AVAudioFramePosition sampleTime, double sampleRate) {
    Pointer<Void> target = alloc(Class('AVAudioTime'));
    SEL sel = SEL('initWithHostTime:sampleTime:atRate:');
    return msgSend(target, sel,
        args: <dynamic>[hostTime, sampleTime, sampleRate],
        decodeRetVal: false) as Pointer<Void>;
  }

  // static AVAudioTime timeWithAudioTimeStampSampleRate(
  //     AudioTimeStamp ts, double sampleRate) {
  //   Pointer<Void> result = Class('AVAudioTime').perform(
  //       SEL('timeWithAudioTimeStamp:sampleRate:'),
  //       args: <dynamic>[ts, sampleRate],
  //       decodeRetVal: false) as Pointer<Void>;
  //   return AVAudioTime.fromPointer(result);
  // }

  static AVAudioTime timeWithHostTime(int hostTime) {
    Pointer<Void> result = Class('AVAudioTime').perform(
        SEL('timeWithHostTime:'),
        args: <dynamic>[hostTime],
        decodeRetVal: false) as Pointer<Void>;
    return AVAudioTime.fromPointer(result);
  }

  static AVAudioTime timeWithSampleTimeAtRate(
      AVAudioFramePosition sampleTime, double sampleRate) {
    Pointer<Void> result = Class('AVAudioTime').perform(
        SEL('timeWithSampleTime:atRate:'),
        args: <dynamic>[sampleTime, sampleRate],
        decodeRetVal: false) as Pointer<Void>;
    return AVAudioTime.fromPointer(result);
  }

  static AVAudioTime timeWithHostTimeSampleTimeAtRate(
      int hostTime, AVAudioFramePosition sampleTime, double sampleRate) {
    Pointer<Void> result = Class('AVAudioTime').perform(
        SEL('timeWithHostTime:sampleTime:atRate:'),
        args: <dynamic>[hostTime, sampleTime, sampleRate],
        decodeRetVal: false) as Pointer<Void>;
    return AVAudioTime.fromPointer(result);
  }

  static int hostTimeForSeconds(NSTimeInterval seconds) {
    return Class('AVAudioTime')
        .perform(SEL('hostTimeForSeconds:'), args: <dynamic>[seconds]) as int;
  }

  static NSTimeInterval secondsForHostTime(int hostTime) {
    Pointer<Void> result = Class('AVAudioTime').perform(
        SEL('secondsForHostTime:'),
        args: <dynamic>[hostTime],
        decodeRetVal: false) as Pointer<Void>;
    return NSTimeInterval.fromPointer(result);
  }

  AVAudioTime.extrapolateTimeFromAnchor(AVAudioTime anchorTime)
      : super.fromPointer(_extrapolateTimeFromAnchor(anchorTime));

  static Pointer<Void> _extrapolateTimeFromAnchor(AVAudioTime anchorTime) {
    Pointer<Void> target = alloc(Class('AVAudioTime'));
    SEL sel = SEL('extrapolateTimeFromAnchor:');
    return msgSend(target, sel,
        args: <dynamic>[anchorTime], decodeRetVal: false) as Pointer<Void>;
  }
}