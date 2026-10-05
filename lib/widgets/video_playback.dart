import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

final _players = <_VideoPlaybackState>{};

VoidCallback suspendExerciseVideos() {
  final players = _players.toList();
  for (final player in players) {
    player._covered++;
    player._update();
  }
  return () {
    for (final player in players) {
      if (!player.mounted) continue;
      player._covered--;
      player._update();
    }
  };
}

class VideoPlayback extends StatefulWidget {
  const VideoPlayback({super.key, required this.controller, required this.child, this.enabled = true});
  final VideoPlayerController controller;
  final Widget child;
  final bool enabled;

  @override
  State<VideoPlayback> createState() => _VideoPlaybackState();
}

class _VideoPlaybackState extends State<VideoPlayback> with WidgetsBindingObserver {
  ScrollPosition? _scroll;
  int _covered = 0;
  bool _visible = false;
  bool _queued = false;
  bool? _playing;

  @override
  void initState() {
    super.initState();
    _players.add(this);
    WidgetsBinding.instance.addObserver(this);
    widget.controller.addListener(_update);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scroll = Scrollable.maybeOf(context)?.position;
    if (scroll != _scroll) {
      _scroll?.removeListener(_checkVisibility);
      _scroll = scroll;
      _scroll?.addListener(_checkVisibility);
    }
    _checkVisibility();
  }

  @override
  void didUpdateWidget(VideoPlayback oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_update);
      widget.controller.addListener(_update);
      _playing = null;
    }
    _checkVisibility();
  }

  void _checkVisibility() {
    if (_queued) return;
    _queued = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _queued = false;
      if (!mounted) return;
      final box = context.findRenderObject();
      if (box is! RenderBox || !box.hasSize || !box.attached) return;
      final rect = box.localToGlobal(Offset.zero) & box.size;
      var viewport = Offset.zero & MediaQuery.sizeOf(context);
      final scrollable = Scrollable.maybeOf(context)?.context.findRenderObject();
      if (scrollable is RenderBox && scrollable.hasSize) {
        viewport = viewport.intersect(scrollable.localToGlobal(Offset.zero) & scrollable.size);
      }
      _visible = !viewport.isEmpty && rect.overlaps(viewport);
      _update();
    });
  }

  void _update() {
    final controller = widget.controller;
    if (!mounted || !controller.value.isInitialized || controller.value.hasError) return;
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    final play =
        widget.enabled &&
        _visible &&
        _covered == 0 &&
        (lifecycle == null || lifecycle == AppLifecycleState.resumed);
    if (_playing == play) return;
    _playing = play;
    unawaited(_setPlayback(controller, play));
  }

  Future<void> _setPlayback(VideoPlayerController controller, bool play) async {
    try {
      if (play) {
        await controller.play();
      } else {
        await controller.pause();
      }
    } catch (_) {}
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _playing = null;
    _update();
  }

  @override
  void dispose() {
    _players.remove(this);
    _scroll?.removeListener(_checkVisibility);
    widget.controller.removeListener(_update);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
