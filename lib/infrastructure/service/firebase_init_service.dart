import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:green_heart/application/interface/init_service.dart';
import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/firebase_options.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';
import 'package:green_heart/infrastructure/service/messaging_handlers_service.dart';

class FirebaseInitService implements InitService {
  final MessagingHandlersService _messagingHandlersService;

  FirebaseInitService(this._messagingHandlersService);

  @override
  Future<void> initialize() async {
    try {
      await initFirebase();
      await setupCrashlytics();
      await setupMessaging();
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException(e.toString());
    }
  }

  Future<void> initFirebase() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('Firebaseの初期化に失敗しました。');
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

  Future<void> setupMessaging() async {
    try {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      _messagingHandlersService.setupNotificationHandlers();
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('Firebase Messagingの初期化に失敗しました。');
    }
  }
}
