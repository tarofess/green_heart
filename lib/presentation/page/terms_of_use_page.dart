import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/state/app_info_notifier.dart';
import 'package:green_heart/presentation/widget/loading_indicator.dart';
import 'package:green_heart/presentation/widget/async_error_widget.dart';

class TermsOfUsePage extends ConsumerWidget {
  const TermsOfUsePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appInfoState = ref.watch(appInfoNotifierProvider);
    return Scaffold(
      body: appInfoState.when(
        data: (appInfo) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '利用規約',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    appInfo.termsOfUse,
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const LoadingIndicator(
          message: '読み込み中',
          backgroundColor: Colors.white10,
        ),
        error: (e, _) => AsyncErrorWidget(
          error: e,
          retry: () => ref.refresh(appInfoNotifierProvider),
        ),
      ),
    );
  }
}
