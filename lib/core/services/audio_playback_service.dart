import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 再生状態
enum PlaybackState {
  idle,
  playing,
  paused,
  completed,
}

/// 再生サービスのProvider
final audioPlaybackServiceProvider = Provider<AudioPlaybackService>((ref) {
  return AudioPlaybackService();
});

/// 音声再生サービス
class AudioPlaybackService {
  AudioPlayer? _player;
  StreamSubscription<PlayerState>? _playerStateSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration>? _durationSub;

  final _stateController = StreamController<PlaybackState>.broadcast();
  final _positionController = StreamController<Duration>.broadcast();
  final _durationController = StreamController<Duration>.broadcast();

  PlaybackState _currentState = PlaybackState.idle;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  String? _currentPath;

  /// 再生状態のストリーム
  Stream<PlaybackState> get stateStream => _stateController.stream;

  /// 再生位置のストリーム
  Stream<Duration> get positionStream => _positionController.stream;

  /// 総再生時間のストリーム
  Stream<Duration> get durationStream => _durationController.stream;

  /// 現在の再生状態
  PlaybackState get currentState => _currentState;

  /// 現在の再生位置
  Duration get currentPosition => _currentPosition;

  /// 総再生時間
  Duration get totalDuration => _totalDuration;

  /// 再生プレイヤーの初期化
  Future<void> _initPlayer() async {
    if (_player != null) return;

    _player = AudioPlayer();

    // 再生状態の監視
    _playerStateSub = _player!.onPlayerStateChanged.listen((state) {
      switch (state) {
        case PlayerState.playing:
          _updateState(PlaybackState.playing);
          break;
        case PlayerState.paused:
          _updateState(PlaybackState.paused);
          break;
        case PlayerState.stopped:
          _updateState(PlaybackState.idle);
          break;
        case PlayerState.completed:
          _updateState(PlaybackState.completed);
          _currentPosition = Duration.zero;
          _positionController.add(_currentPosition);
          break;
        case PlayerState.disposed:
          _updateState(PlaybackState.idle);
          break;
      }
    });

    // 再生位置の監視
    _positionSub = _player!.onPositionChanged.listen((position) {
      _currentPosition = position;
      _positionController.add(position);
    });

    // 総再生時間の監視
    _durationSub = _player!.onDurationChanged.listen((duration) {
      _totalDuration = duration;
      _durationController.add(duration);
    });
  }

  /// 音声ファイルを読み込む
  Future<bool> loadAudio(String path) async {
    try {
      await _initPlayer();
      _currentPath = path;

      // ソースを設定（URLかローカルファイルかを判定）
      final Source source;
      if (path.startsWith('http://') || path.startsWith('https://')) {
        // Web版やリモートファイルの場合はUrlSourceを使用
        source = UrlSource(path);
      } else {
        // ローカルファイルの場合はDeviceFileSourceを使用
        source = DeviceFileSource(path);
      }
      await _player!.setSource(source);

      // 再生時間を取得
      final duration = await _player!.getDuration();
      if (duration != null) {
        _totalDuration = duration;
        _durationController.add(_totalDuration);
      }

      _currentPosition = Duration.zero;
      _positionController.add(_currentPosition);
      _updateState(PlaybackState.idle);

      return true;
    } catch (e) {
      debugPrint('Failed to load audio: $e');
      return false;
    }
  }

  /// 再生を開始
  Future<bool> play() async {
    try {
      if (_currentPath == null) {
        debugPrint('No audio file loaded');
        return false;
      }

      await _initPlayer();

      if (_currentState == PlaybackState.completed) {
        await _player!.seek(Duration.zero);
      }

      await _player!.resume();
      return true;
    } catch (e) {
      debugPrint('Failed to play audio: $e');
      return false;
    }
  }

  /// 再生を一時停止
  Future<void> pause() async {
    try {
      await _player?.pause();
    } catch (e) {
      debugPrint('Failed to pause audio: $e');
    }
  }

  /// 再生を停止
  Future<void> stop() async {
    try {
      await _player?.stop();
      _currentPosition = Duration.zero;
      _positionController.add(_currentPosition);
    } catch (e) {
      debugPrint('Failed to stop audio: $e');
    }
  }

  /// 指定位置にシーク
  Future<void> seek(Duration position) async {
    try {
      await _player?.seek(position);
      _currentPosition = position;
      _positionController.add(_currentPosition);
    } catch (e) {
      debugPrint('Failed to seek audio: $e');
    }
  }

  void _updateState(PlaybackState state) {
    _currentState = state;
    _stateController.add(state);
  }

  /// 再生時間をフォーマット（MM:SS）
  static String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// 進捗率を取得（0.0〜1.0）
  double get progress {
    if (_totalDuration.inMilliseconds == 0) return 0.0;
    return _currentPosition.inMilliseconds / _totalDuration.inMilliseconds;
  }

  /// リソースの解放
  Future<void> dispose() async {
    _playerStateSub?.cancel();
    _positionSub?.cancel();
    _durationSub?.cancel();
    await _stateController.close();
    await _positionController.close();
    await _durationController.close();
    await _player?.dispose();
    _player = null;
  }
}
