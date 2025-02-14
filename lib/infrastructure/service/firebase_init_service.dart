import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'package:green_heart/application/interface/init_service.dart';
import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/firebase_options.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';

class FirebaseInitService implements InitService {
  @override
  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    try {
      await initFirebase();
      await setupFirestore();
      await setupCrashlytics();
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException(e.toString());
    }
  }

  Future<void> initFirebase() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('Firebaseの初期化に失敗しました。');
    }
  }

  Future<void> setupFirestore() async {
    try {
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('Firestoreの初期化に失敗しました。');
    }
  }

  Future<void> setupCrashlytics() async {
    try {
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('Firebase Crashlyticsの初期化に失敗しました。');
    }
  }
}
