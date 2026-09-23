import 'dart:async';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;

class DriveBackupItem {
  final String id;
  final String name;
  final int size;
  final DateTime? modifiedTime;

  const DriveBackupItem({
    required this.id,
    required this.name,
    required this.size,
    this.modifiedTime,
  });

  String get formattedSize {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

class GoogleDriveService {
  GoogleDriveService._();
  static final GoogleDriveService instance = GoogleDriveService._();

  static const String kClientId = String.fromEnvironment(
    'GOOGLE_CLIENT_ID',
    defaultValue: '',
  );

  late final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kClientId.isNotEmpty ? kClientId : null,
    serverClientId: kClientId.isNotEmpty ? kClientId : null,
    scopes: <String>[
      drive.DriveApi.driveAppdataScope,
    ],
  );

  GoogleSignInAccount? _account;
  GoogleSignInAccount? get currentUser => _account;
  bool get isSignedIn => _account != null;

  Future<void> init() async {
    try {
      _googleSignIn.onCurrentUserChanged.listen((account) {
        _account = account;
      });
      _account = await _googleSignIn.signInSilently();
    } catch (e) {
      debugPrint('GoogleDriveService.init error: $e');
    }
  }

  Future<GoogleSignInAccount?> signIn() async {
    try {
      _account = await _googleSignIn.signIn();
      return _account;
    } catch (e) {
      debugPrint('GoogleDriveService.signIn error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      _account = null;
    } catch (e) {
      debugPrint('GoogleDriveService.signOut error: $e');
    }
  }

  Future<drive.DriveApi?> _getDriveApi() async {
    _account ??= await _googleSignIn.signInSilently();
    if (_account == null) return null;

    final authClient = await _googleSignIn.authenticatedClient();
    if (authClient == null) return null;
    return drive.DriveApi(authClient);
  }

  Future<bool> uploadBackup(Uint8List zipBytes, {String? filename}) async {
    try {
      final driveApi = await _getDriveApi();
      if (driveApi == null) return false;

      final stamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final name = filename ?? 'zeus-backup-$stamp.zip';

      final driveFile = drive.File()
        ..name = name
        ..parents = ['appDataFolder']
        ..description = 'Zeus App Backup'
        ..mimeType = 'application/zip';

      final media = drive.Media(
        Stream.value(zipBytes),
        zipBytes.length,
        contentType: 'application/zip',
      );

      await driveApi.files.create(
        driveFile,
        uploadMedia: media,
        $fields: 'id, name, size, modifiedTime',
      );

      // Prune old backups, keeping the most recent 5
      await _pruneOldBackups(driveApi, keepCount: 5);
      return true;
    } catch (e) {
      debugPrint('GoogleDriveService.uploadBackup error: $e');
      return false;
    }
  }

  Future<List<DriveBackupItem>> listBackups() async {
    try {
      final driveApi = await _getDriveApi();
      if (driveApi == null) return [];

      final fileList = await driveApi.files.list(
        spaces: 'appDataFolder',
        $fields: 'files(id, name, size, modifiedTime)',
        orderBy: 'modifiedTime desc',
        pageSize: 30,
      );

      final files = fileList.files ?? [];
      return files
          .where((f) => f.id != null && (f.name?.endsWith('.zip') ?? false))
          .map((f) => DriveBackupItem(
                id: f.id!,
                name: f.name ?? 'zeus-backup.zip',
                size: int.tryParse(f.size ?? '0') ?? 0,
                modifiedTime: f.modifiedTime,
              ))
          .toList();
    } catch (e) {
      debugPrint('GoogleDriveService.listBackups error: $e');
      return [];
    }
  }

  Future<Uint8List?> downloadBackup(String fileId) async {
    try {
      final driveApi = await _getDriveApi();
      if (driveApi == null) return null;

      final media = await driveApi.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      final bytes = <int>[];
      await for (final chunk in media.stream) {
        bytes.addAll(chunk);
      }
      return Uint8List.fromList(bytes);
    } catch (e) {
      debugPrint('GoogleDriveService.downloadBackup error: $e');
      return null;
    }
  }

  Future<bool> deleteBackup(String fileId) async {
    try {
      final driveApi = await _getDriveApi();
      if (driveApi == null) return false;

      await driveApi.files.delete(fileId);
      return true;
    } catch (e) {
      debugPrint('GoogleDriveService.deleteBackup error: $e');
      return false;
    }
  }

  Future<void> _pruneOldBackups(drive.DriveApi driveApi, {int keepCount = 5}) async {
    try {
      final fileList = await driveApi.files.list(
        spaces: 'appDataFolder',
        $fields: 'files(id, name, modifiedTime)',
        orderBy: 'modifiedTime desc',
        pageSize: 30,
      );

      final files = fileList.files ?? [];
      final backups = files
          .where((f) => f.id != null && (f.name?.endsWith('.zip') ?? false))
          .toList();

      if (backups.length > keepCount) {
        for (final extra in backups.skip(keepCount)) {
          if (extra.id != null) {
            try {
              await driveApi.files.delete(extra.id!);
            } catch (_) {}
          }
        }
      }
    } catch (e) {
      debugPrint('GoogleDriveService._pruneOldBackups error: $e');
    }
  }
}
