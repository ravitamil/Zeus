import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:video_player/video_player.dart';

import '../models/exercise.dart';
import '../services/media_store.dart';
import '../state/fit_state.dart';
import '../theme/app_colors.dart';
import 'exercise_art.dart';
import 'shimmer.dart';

class ExerciseMedia extends StatelessWidget {
  const ExerciseMedia({
    super.key,
    required this.ex,
    this.height = 210,
    this.radius = 20,
    this.live = false,
    this.bordered = true,
  });

  final Exercise ex;
  final double height;
  final double radius;
  final bool live;
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    final media = fit.mediaFor(ex.id);
    final path = media.isEmpty ? null : MediaStore.pathFor(media);
    if (path == null) {
      if (ex.videoPath.isNotEmpty) {
        if (live) {
          return _VideoTile(
            key: ValueKey(ex.videoPath),
            path: ex.videoPath,
            height: height,
            radius: radius,
            bordered: bordered,
          );
        }
        final thumb = _videoThumbnailAsset(ex.videoPath);
        if (thumb != null) {
          return _MediaFrame(
            height: height,
            radius: radius,
            bordered: bordered,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  thumb,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                  errorBuilder: (_, _, _) => _VideoPoster(height: height),
                ),
                Positioned(
                  right: 4,
                  bottom: 4,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      PhosphorIconsFill.play,
                      size: (height * 0.16).clamp(8.0, 14.0),
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return _MediaFrame(
          height: height,
          radius: radius,
          bordered: bordered,
          child: _VideoPoster(height: height),
        );
      }
      return ExerciseArt(
          slug: ex.art, height: height, radius: radius, live: live, bordered: bordered);
    }
    final isVideo = MediaStore.isVideo(media);
    if (isVideo && live) {
      return _VideoTile(
        key: ValueKey(path),
        path: path,
        height: height,
        radius: radius,
        bordered: bordered,
      );
    }
    return _MediaFrame(
      height: height,
      radius: radius,
      bordered: bordered,
      child: isVideo
          ? _VideoPoster(height: height)
          : Center(
              child: Image.file(
                File(path),
                key: ValueKey(media),
                fit: BoxFit.contain,
                alignment: Alignment.center,
                gaplessPlayback: true,
                errorBuilder: (_, _, _) => _fallbackIcon(context, height),
              ),
            ),
    );
  }
}

String? _videoThumbnailAsset(String videoPath) {
  if (videoPath.isEmpty) return null;
  if (videoPath.startsWith('assets/videos/')) {
    final name = videoPath.substring('assets/videos/'.length);
    final dot = name.lastIndexOf('.');
    final base = dot >= 0 ? name.substring(0, dot) : name;
    return 'assets/thumbnails/$base.webp';
  }
  return null;
}

Widget _fallbackIcon(BuildContext context, double height) => Center(
      child: Icon(PhosphorIconsRegular.barbell,
          size: height * 0.32, color: context.gc.textTertiary),
    );

class _MediaFrame extends StatelessWidget {
  const _MediaFrame(
      {required this.child,
      required this.height,
      required this.radius,
      this.bordered = true});
  final Widget child;
  final double height;
  final double radius;
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    final gc = context.gc;
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: gc.bgRaised2,
        borderRadius: BorderRadius.circular(radius),
        border: bordered ? Border.all(color: gc.border) : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

class _VideoPoster extends StatelessWidget {
  const _VideoPoster({required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    final gc = context.gc;
    return Center(
      child: Icon(PhosphorIconsFill.playCircle,
          size: (height * 0.34).clamp(18.0, 54.0), color: gc.textSecondary),
    );
  }
}

class _VideoTile extends StatefulWidget {
  const _VideoTile({
    super.key,
    required this.path,
    required this.height,
    required this.radius,
    this.bordered = true,
  });
  final String path;
  final double height;
  final double radius;
  final bool bordered;

  @override
  State<_VideoTile> createState() => _VideoTileState();
}

class _VideoTileState extends State<_VideoTile> {
  VideoPlayerController? _c;
  bool _ok = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final c = widget.path.startsWith('assets/')
          ? VideoPlayerController.asset(widget.path)
          : VideoPlayerController.file(File(widget.path));
      await c.initialize();
      await c.setLooping(true);
      await c.setVolume(0);
      await c.play();
      if (!mounted) {
        c.dispose();
        return;
      }
      setState(() {
        _c = c;
        _ok = true;
      });
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  void didUpdateWidget(_VideoTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      _c?.dispose();
      _c = null;
      _ok = false;
      _failed = false;
      _load();
    }
  }

  @override
  void dispose() {
    _c?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (_ok && _c != null && _c!.value.isInitialized) {
      final size = _c!.value.size;
      final w = size.width > 0 ? size.width : 16.0;
      final h = size.height > 0 ? size.height : 9.0;
      child = FittedBox(
        fit: BoxFit.cover,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: w,
          height: h,
          child: VideoPlayer(_c!),
        ),
      );
    } else if (_failed) {
      child = _fallbackIcon(context, widget.height);
    } else {
      child = Stack(children: [
        Positioned.fill(child: Shimmer(radius: widget.radius)),
        const Center(child: CupertinoActivityIndicator()),
      ]);
    }
    return _MediaFrame(
      height: widget.height,
      radius: widget.radius,
      bordered: widget.bordered,
      child: child,
    );
  }
}
