import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/services/audio_playback_service.dart';
import '../../../../../core/services/audio_recording_service.dart';
import '../../../../../core/theme/my_colors.dart';
import 'animated_waveform.dart';

/// ボイスレコーダーの状態
enum VoiceRecorderState {
  idle, // 初期状態（録音ボタンのみ表示）
  recording, // 録音中
  recorded, // 録音完了（再生可能）
  playing, // 再生中
}

/// ボイスレコーダーウィジェット
/// Instagramのボイスメッセージ風のUIを提供
class VoiceRecorderWidget extends StatefulWidget {
  const VoiceRecorderWidget({
    super.key,
    this.onRecordingComplete,
    this.onDelete,
    this.primaryColor,
    this.backgroundColor,
    this.initialPath,
    this.initialAmplitudes,
  });

  /// 録音完了時のコールバック（ファイルパスと振幅データを返す）
  final void Function(String path, List<double> amplitudes)? onRecordingComplete;

  /// 録音削除時のコールバック
  final VoidCallback? onDelete;

  /// プライマリカラー（デフォルト: primaryMain）
  final Color? primaryColor;

  /// 背景色（デフォルト: gray100）
  final Color? backgroundColor;

  /// 既存の録音ファイルパス（編集時に使用）
  final String? initialPath;

  /// 既存の振幅データ（編集時に使用）
  final List<double>? initialAmplitudes;

  @override
  State<VoiceRecorderWidget> createState() => _VoiceRecorderWidgetState();
}

class _VoiceRecorderWidgetState extends State<VoiceRecorderWidget>
    with TickerProviderStateMixin {
  late final AudioRecordingService _recordingService;
  late final AudioPlaybackService _playbackService;

  late final AnimationController _recordButtonController;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  VoiceRecorderState _state = VoiceRecorderState.idle;
  String? _recordedPath;
  int _recordDuration = 0;
  final List<double> _amplitudes = [];

  StreamSubscription<RecordingState>? _recordingStateSub;
  StreamSubscription<double>? _amplitudeSub;
  StreamSubscription<int>? _durationSub;
  StreamSubscription<PlaybackState>? _playbackStateSub;
  StreamSubscription<Duration>? _positionSub;

  Color get _primaryColor => widget.primaryColor ?? MyColors.primaryMain.color;
  Color get _backgroundColor =>
      widget.backgroundColor ?? MyColors.gray100.color;

  @override
  void initState() {
    super.initState();
    _recordingService = AudioRecordingService();
    _playbackService = AudioPlaybackService();

    // 録音ボタンのアニメーションコントローラー
    _recordButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // パルスアニメーション（録音中のエフェクト）
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _setupListeners();

    // 既存の録音ファイルがある場合は読み込む
    if (widget.initialPath != null) {
      _loadInitialAudio();
    }
  }

  Future<void> _loadInitialAudio() async {
    _recordedPath = widget.initialPath;
    if (widget.initialAmplitudes != null) {
      _amplitudes.addAll(widget.initialAmplitudes!);
    }
    await _playbackService.loadAudio(widget.initialPath!);
    if (mounted) {
      setState(() => _state = VoiceRecorderState.recorded);
    }
  }

  void _setupListeners() {
    // 録音状態の監視
    _recordingStateSub = _recordingService.stateStream.listen((state) {
      if (state == RecordingState.recording) {
        setState(() => _state = VoiceRecorderState.recording);
      } else if (state == RecordingState.idle &&
          _state == VoiceRecorderState.recording) {
        // 録音が完了した
      }
    });

    // 振幅の監視
    _amplitudeSub = _recordingService.amplitudeStream.listen((amplitude) {
      setState(() {
        _amplitudes.add(amplitude);
        // 最大60個（約6秒分）を保持
        if (_amplitudes.length > 60) {
          _amplitudes.removeAt(0);
        }
      });
    });

    // 録音時間の監視
    _durationSub = _recordingService.durationStream.listen((duration) {
      setState(() => _recordDuration = duration);
    });

    // 再生状態の監視
    _playbackStateSub = _playbackService.stateStream.listen((state) {
      setState(() {
        if (state == PlaybackState.playing) {
          _state = VoiceRecorderState.playing;
        } else if (state == PlaybackState.paused ||
            state == PlaybackState.completed ||
            state == PlaybackState.idle) {
          if (_recordedPath != null) {
            _state = VoiceRecorderState.recorded;
          }
        }
      });
    });

    // 再生位置の監視
    _positionSub = _playbackService.positionStream.listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _recordingStateSub?.cancel();
    _amplitudeSub?.cancel();
    _durationSub?.cancel();
    _playbackStateSub?.cancel();
    _positionSub?.cancel();
    _recordButtonController.dispose();
    _pulseController.dispose();
    _recordingService.dispose();
    _playbackService.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    _amplitudes.clear();
    final success = await _recordingService.startRecording();
    if (success) {
      _recordButtonController.forward();
      _pulseController.repeat(reverse: true);
    }
  }

  Future<void> _stopRecording() async {
    _recordButtonController.reverse();
    _pulseController.stop();
    _pulseController.reset();

    final path = await _recordingService.stopRecording();
    if (path != null) {
      _recordedPath = path;
      await _playbackService.loadAudio(path);
      setState(() => _state = VoiceRecorderState.recorded);
      widget.onRecordingComplete?.call(path, List.from(_amplitudes));
    } else {
      setState(() => _state = VoiceRecorderState.idle);
    }
  }

  Future<void> _playRecording() async {
    await _playbackService.play();
  }

  Future<void> _pausePlayback() async {
    await _playbackService.pause();
  }

  void _deleteRecording() {
    _playbackService.stop();
    _recordedPath = null;
    _amplitudes.clear();
    _recordDuration = 0;
    setState(() => _state = VoiceRecorderState.idle);
    widget.onDelete?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(28.r),
      ),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    switch (_state) {
      case VoiceRecorderState.idle:
        return _buildRecordButton();
      case VoiceRecorderState.recording:
        return _buildRecordingState();
      case VoiceRecorderState.recorded:
      case VoiceRecorderState.playing:
        return _buildPlaybackState();
    }
  }

  /// 初期状態：録音ボタンのみ

  /// 録音中：波形 + 停止ボタン
  Widget _buildRecordingState() {
    return Row(
      children: [
        // 録音時間
        SizedBox(
          width: 50.w,
          child: Text(
            AudioRecordingService.formatDuration(_recordDuration),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: _primaryColor,
            ),
          ),
        ),
        // 波形（アニメーション付き）
        Expanded(
          child: RepaintBoundary(
            child: SizedBox(
              height: 40.h,
              child: AnimatedWaveform(
                amplitudes: _amplitudes,
                color: _primaryColor,
                barWidth: 3.w,
                barSpacing: 2.w,
                animationDuration: const Duration(milliseconds: 120),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        // 停止ボタン
        _buildStopButton(),
      ],
    );
  }

  /// 再生状態：波形 + 再生/一時停止ボタン + 削除ボタン
  Widget _buildPlaybackState() {
    final isPlaying = _state == VoiceRecorderState.playing;
    final progress = _playbackService.progress;

    return Row(
      children: [
        // 再生/一時停止ボタン
        _buildPlayPauseButton(isPlaying),
        SizedBox(width: 12.w),
        // 波形 + 再生位置
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RepaintBoundary(
                child: SizedBox(
                  height: 40.h,
                  child: AnimatedPlaybackWaveform(
                    amplitudes: _amplitudes.isNotEmpty
                        ? _amplitudes
                        : List.generate(30, (i) => 0.3 + (i % 5) * 0.1),
                    progress: progress,
                    activeColor: _primaryColor,
                    inactiveColor: _primaryColor.withValues(alpha: 0.3),
                    barWidth: 3.w,
                    barSpacing: 2.w,
                    animationDuration: const Duration(milliseconds: 80),
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AudioPlaybackService.formatDuration(
                      _playbackService.currentPosition,
                    ),
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey[600]),
                  ),
                  Text(
                    AudioPlaybackService.formatDuration(
                      _playbackService.totalDuration,
                    ),
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        // 削除ボタン
        _buildDeleteButton(),
      ],
    );
  }

  /// 録音ボタン（丸）
  Widget _buildRecordButton() {
    return GestureDetector(
      onTap: _startRecording,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _state == VoiceRecorderState.recording
                ? _pulseAnimation.value
                : 1.0,
            child: Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: _primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _primaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.mic, color: Colors.white, size: 24.w),
            ),
          );
        },
      ),
    );
  }

  /// 停止ボタン（丸）
  Widget _buildStopButton() {
    return GestureDetector(
      onTap: _stopRecording,
      child: Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.red.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(Icons.stop, color: Colors.white, size: 24.w),
      ),
    );
  }

  /// 再生/一時停止ボタン
  Widget _buildPlayPauseButton(bool isPlaying) {
    return GestureDetector(
      onTap: isPlaying ? _pausePlayback : _playRecording,
      child: Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          color: _primaryColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: _primaryColor.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
          size: 24.w,
        ),
      ),
    );
  }

  /// 削除ボタン
  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: _deleteRecording,
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.delete_outline, color: Colors.grey[700], size: 20.w),
      ),
    );
  }
}
