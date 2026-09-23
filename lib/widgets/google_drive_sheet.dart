import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../services/backup_zip.dart';
import '../services/google_drive_service.dart';
import '../state/fit_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'dialogs.dart';
import 'glass.dart';
import 'ui_kit.dart';

void showGoogleDriveSheet(BuildContext context) {
  showAppSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheet) => const GoogleDriveSheet(),
  );
}

class GoogleDriveSheet extends StatefulWidget {
  const GoogleDriveSheet({super.key});

  @override
  State<GoogleDriveSheet> createState() => _GoogleDriveSheetState();
}

class _GoogleDriveSheetState extends State<GoogleDriveSheet> {
  final GoogleDriveService _drive = GoogleDriveService.instance;
  bool _loadingBackups = false;
  bool _signingIn = false;
  String? _statusMessage;
  List<DriveBackupItem> _backups = [];

  @override
  void initState() {
    super.initState();
    if (_drive.isSignedIn) {
      _loadBackups();
    }
  }

  Future<void> _loadBackups() async {
    if (!mounted) return;
    setState(() => _loadingBackups = true);
    try {
      final list = await _drive.listBackups();
      if (mounted) {
        setState(() {
          _backups = list;
          _loadingBackups = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingBackups = false);
    }
  }

  Future<void> _handleSignIn() async {
    setState(() {
      _signingIn = true;
      _statusMessage = null;
    });
    try {
      final account = await _drive.signIn();
      if (account != null && mounted) {
        await _loadBackups();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _statusMessage = 'Sign in cancelled or failed: $e');
      }
    } finally {
      if (mounted) setState(() => _signingIn = false);
    }
  }

  Future<void> _handleSignOut() async {
    await _drive.signOut();
    if (mounted) {
      setState(() {
        _backups = [];
        _statusMessage = null;
      });
    }
  }

  Future<void> _handleBackupNow() async {
    setState(() => _statusMessage = null);
    final ok = await fit.backupToDriveNow();
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Backup uploaded to Google Drive!')),
      );
      await _loadBackups();
    } else {
      setState(() => _statusMessage = 'Backup failed. Please try again.');
    }
  }

  Future<void> _handleRestore(DriveBackupItem item) async {
    final ok = await askConfirm(
      context,
      title: 'Restore Backup',
      body:
          'Restoring this backup from ${item.modifiedTime != null ? DateFormat('yMMMd HH:mm').format(item.modifiedTime!) : item.name} will replace your current workout logs, exercises, and media. Continue?',
      confirmLabel: 'Restore',
      danger: true,
    );
    if (!ok || !mounted) return;

    setState(() => _loadingBackups = true);
    final bytes = await _drive.downloadBackup(item.id);
    if (!mounted) return;

    if (bytes == null || bytes.isEmpty) {
      setState(() {
        _loadingBackups = false;
        _statusMessage = 'Failed to download backup from Drive.';
      });
      return;
    }

    final success = looksLikeZip(bytes) ? await restoreBackupZip(bytes) : false;

    if (!mounted) return;
    setState(() => _loadingBackups = false);

    if (success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Backup successfully restored!')),
      );
    } else {
      setState(() => _statusMessage = 'Failed to restore backup archive.');
    }
  }

  Future<void> _handleDelete(DriveBackupItem item) async {
    final ok = await askConfirm(
      context,
      title: 'Delete Backup',
      body: 'Are you sure you want to delete this backup from Google Drive?',
      confirmLabel: 'Delete',
      danger: true,
    );
    if (!ok || !mounted) return;

    final success = await _drive.deleteBackup(item.id);
    if (mounted && success) {
      await _loadBackups();
    }
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return 'Unknown date';
    return DateFormat('MMM d, y • h:mm a').format(dt.toLocal());
  }

  String _lastBackupLabel() {
    final last = fit.driveLastBackup;
    if (last == null) return 'Never';
    final dt = DateTime.fromMillisecondsSinceEpoch(last).toLocal();
    return DateFormat('MMM d, y • h:mm a').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final gc = context.gc;
    final signedIn = _drive.isSignedIn;
    final user = _drive.currentUser;

    return AnimatedBuilder(
      animation: fit,
      builder: (context, _) {
        return Container(
          padding: sheetPad(context),
          decoration: BoxDecoration(
            color: gc.bgRaised,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SheetHandle(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(PhosphorIconsRegular.cloudArrowUp, size: 22, color: gc.accent),
                    const SizedBox(width: 8),
                    const SheetTitle('Google Drive Backup'),
                  ],
                ),
                const SizedBox(height: 16),

                // Account card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: gc.bgRaised2,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: gc.border.withValues(alpha: 0.6)),
                  ),
                  child: signedIn
                      ? Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: gc.accentSoft,
                              backgroundImage: user?.photoUrl != null ? NetworkImage(user!.photoUrl!) : null,
                              child: user?.photoUrl == null
                                  ? Icon(PhosphorIconsRegular.user, size: 20, color: gc.accent)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user?.displayName ?? 'Connected',
                                    style: AppTheme.f(14.5, weight: FontWeight.w700, color: gc.text),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    user?.email ?? '',
                                    style: AppTheme.f(12, weight: FontWeight.w500, color: gc.textSecondary),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: _handleSignOut,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: gc.bgRaised,
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: gc.border),
                                ),
                                child: Text(
                                  'Disconnect',
                                  style: AppTheme.f(12, weight: FontWeight.w600, color: gc.danger),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Back up your workout logs, history, routines, and custom exercises securely to your private Google Drive app data.',
                              style: AppTheme.f(13, weight: FontWeight.w500, color: gc.textSecondary, height: 1.4),
                            ),
                            const SizedBox(height: 14),
                            ElevatedButton.icon(
                              onPressed: _signingIn ? null : _handleSignIn,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: gc.accent,
                                foregroundColor: gc.bg,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 13),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                              ),
                              icon: _signingIn
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CupertinoActivityIndicator(),
                                    )
                                  : Icon(PhosphorIconsRegular.signIn, size: 18, color: gc.bg),
                              label: Text(
                                _signingIn ? 'Connecting...' : 'Sign In with Google',
                                style: AppTheme.f(14, weight: FontWeight.w700, color: gc.bg),
                              ),
                            ),
                          ],
                        ),
                ),

                if (_statusMessage != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    _statusMessage!,
                    style: AppTheme.f(12, weight: FontWeight.w500, color: gc.warn),
                    textAlign: TextAlign.center,
                  ),
                ],

                if (signedIn) ...[
                  const SizedBox(height: 20),
                  Text(
                    'AUTO BACKUP',
                    style: AppTheme.f(11, weight: FontWeight.w700, color: gc.textTertiary, letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 8),
                  OptionGroup([
                    OptionItem(
                      'Off',
                      icon: PhosphorIconsRegular.xCircle,
                      selected: fit.driveAutoBackup == 'off',
                      onTap: () => fit.setDriveAutoBackup('off'),
                    ),
                    OptionItem(
                      'Daily',
                      icon: PhosphorIconsRegular.calendarCheck,
                      selected: fit.driveAutoBackup == 'daily',
                      onTap: () => fit.setDriveAutoBackup('daily'),
                    ),
                    OptionItem(
                      'Weekly',
                      icon: PhosphorIconsRegular.calendar,
                      selected: fit.driveAutoBackup == 'weekly',
                      onTap: () => fit.setDriveAutoBackup('weekly'),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Last Backup:', style: AppTheme.f(12, weight: FontWeight.w500, color: gc.textTertiary)),
                        Text(_lastBackupLabel(),
                            style: AppTheme.f(12, weight: FontWeight.w600, color: gc.textSecondary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: fit.isDriveBackingUp ? null : _handleBackupNow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: gc.bgRaised2,
                      foregroundColor: gc.accent,
                      elevation: 0,
                      side: BorderSide(color: gc.accent.withValues(alpha: 0.5)),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                    ),
                    icon: fit.isDriveBackingUp
                        ? const SizedBox(width: 16, height: 16, child: CupertinoActivityIndicator())
                        : Icon(PhosphorIconsRegular.cloudArrowUp, size: 18, color: gc.accent),
                    label: Text(
                      fit.isDriveBackingUp ? 'Uploading Backup...' : 'Back Up Now',
                      style: AppTheme.f(14, weight: FontWeight.w700, color: gc.accent),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'BACKUPS ON GOOGLE DRIVE',
                        style: AppTheme.f(11, weight: FontWeight.w700, color: gc.textTertiary, letterSpacing: 1.2),
                      ),
                      if (_loadingBackups)
                        const SizedBox(width: 14, height: 14, child: CupertinoActivityIndicator())
                      else
                        GestureDetector(
                          onTap: _loadBackups,
                          child: Icon(PhosphorIconsRegular.arrowsClockwise, size: 15, color: gc.textSecondary),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_backups.isEmpty && !_loadingBackups)
                    Container(
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: gc.bgRaised2,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'No backups stored on Google Drive yet.',
                        style: AppTheme.f(13, weight: FontWeight.w500, color: gc.textSecondary),
                      ),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        color: gc.bgRaised2,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: gc.border.withValues(alpha: 0.5)),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          for (int i = 0; i < _backups.length; i++) ...[
                            _backupRow(gc, _backups[i]),
                            if (i < _backups.length - 1)
                              Divider(height: 1, indent: 16, color: gc.border.withValues(alpha: 0.5)),
                          ],
                        ],
                      ),
                    ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _backupRow(GymColors gc, DriveBackupItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(PhosphorIconsRegular.fileZip, size: 22, color: gc.accent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(item.modifiedTime),
                  style: AppTheme.f(13.5, weight: FontWeight.w600, color: gc.text),
                ),
                const SizedBox(height: 2),
                Text(
                  item.formattedSize,
                  style: AppTheme.f(11.5, weight: FontWeight.w500, color: gc.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _handleRestore(item),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: gc.accentSoft,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                'Restore',
                style: AppTheme.f(12, weight: FontWeight.w700, color: gc.accent),
              ),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () => _handleDelete(item),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(PhosphorIconsRegular.trash, size: 16, color: gc.textTertiary),
            ),
          ),
        ],
      ),
    );
  }
}
