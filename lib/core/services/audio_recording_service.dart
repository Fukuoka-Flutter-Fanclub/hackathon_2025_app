import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

/// 録音状態
enum RecordingState {
  idle,
  recording,
  paused,
}

/// 録音サービスのProvider
final audioRecordingServiceProvider = Provider<AudioRecordingService>((ref) {
  return AudioRecordingService();
});

/// 音声録音サービス
class AudioRecordingService {
  AudioRecorder? _recorder;
  StreamSubscription<Amplitude>? _amplitudeSub;
  Timer? _durationTimer;

  final _stateController = StreamController<RecordingState>.broadcast();
  final _amplitudeController = StreamController<double>.broadcast();
  final _durationController = StreamController<int>.broadcast();

  RecordingState _currentState = RecordingState.idle;
  int _recordDuration = 0;
  String? _currentPath;

  /// 録音状態のストリーム
  Stream<RecordingState> get stateStream => _stateController.stream;

  /// 振幅のストリーム（波形表示用）-160〜0 dB
  Stream<double> get amplitudeStream => _amplitudeController.stream;

  /// 録音時間のストリーム（秒）
  Stream<int> get durationStream => _durationController.stream;

  /// 現在の録音状態
  RecordingState get currentState => _currentState;

  /// 現在の録音時間（秒）
  int get recordDuration => _recordDuration;

  /// 録音の初期化
  Future<void> _initRecorder() async {
    _recorder ??= AudioRecorder();
  }

  /// マイクの権限を確認
  Future<bool> hasPermission() async {
    await _initRecorder();
    return await _recorder!.hasPermission();
  }

  /// エンコーダーがサポートされているか確認
  Future<bool> isEncoderSupported(AudioEncoder encoder) async {
    await _initRecorder();
    return await _recorder!.isEncoderSupported(encoder);
  }

  /// 録音を開始
  Future<bool> startRecording() async {
    try {
      await _initRecorder();

      if (!await hasPermission()) {
        debugPrint('Recording permission not granted');
        return false;
      }

      // AAC エンコーダーを使用
      const encoder = AudioEncoder.aacLc;
      if (!await isEncoderSupported(encoder)) {
        debugPrint('AAC encoder not supported');
        return false;
      }

      // 録音ファイルパスを生成
      final dir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      _currentPath = '${dir.path}/voice_$timestamp.m4a';

      // 録音設定
      const config = RecordConfig(
        encoder: encoder,
        numChannels: 1,
        sampleRate: 44100,
        bitRate: 128000,
      );

      // 録音開始
      await _recorder!.start(config, path: _currentPath!);

      // 振幅の監視を開始
      _amplitudeSub = _recorder!
          .onAmplitudeChanged(const Duration(milliseconds: 100))
          .listen((amp) {
        // dBFS値を0〜1の範囲に正規化（-60dB以下は0、0dBは1）
        final normalized = ((amp.current + 60) / 60).clamp(0.0, 1.0);
        _amplitudeController.add(normalized);
      });

      // 録音時間のカウントを開始
      _recordDuration = 0;
      _durationController.add(_recordDuration);
      _startDurationTimer();

      _updateState(RecordingState.recording);
      return true;
    } catch (e) {
      debugPrint('Failed to start recording: $e');
      return false;
    }
  }

  /// 録音を停止
  Future<String?> stopRecording() async {
    try {
      _stopDurationTimer();
      _amplitudeSub?.cancel();
      _amplitudeSub = null;

      final path = await _recorder?.stop();
      _updateState(RecordingState.idle);
      return path;
    } catch (e) {
      debugPrint('Failed to stop recording: $e');
      _updateState(RecordingState.idle);
      return null;
    }
  }

  /// 録音を一時停止
  Future<void> pauseRecording() async {
    try {
      await _recorder?.pause();
      _stopDurationTimer();
      _updateState(RecordingState.paused);
    } catch (e) {
      debugPrint('Failed to pause recording: $e');
    }
  }

  /// 録音を再開
  Future<void> resumeRecording() async {
    try {
      await _recorder?.resume();
      _startDurationTimer();
      _updateState(RecordingState.recording);
    } catch (e) {
      debugPrint('Failed to resume recording: $e');
    }
  }

  /// 録音をキャンセル（ファイルを削除）
  Future<void> cancelRecording() async {
    try {
      _stopDurationTimer();
      _amplitudeSub?.cancel();
      _amplitudeSub = null;
      await _recorder?.cancel();
      _currentPath = null;
      _recordDuration = 0;
      _updateState(RecordingState.idle);
    } catch (e) {
      debugPrint('Failed to cancel recording: $e');
    }
  }

  void _startDurationTimer() {
    _durationTimer?.cancel();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _recordDuration++;
      _durationController.add(_recordDuration);
    });
  }

  void _stopDurationTimer() {
    _durationTimer?.cancel();
    _durationTimer = null;
  }

  void _updateState(RecordingState state) {
    _currentState = state;
    _stateController.add(state);
  }

  /// 録音時間をフォーマット（MM:SS）
  static String formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  /// リソースの解放
  Future<void> dispose() async {
    _stopDurationTimer();
    _amplitudeSub?.cancel();
    await _stateController.close();
    await _amplitudeController.close();
    await _durationController.close();
    _recorder?.dispose();
    _recorder = null;
  }
}
