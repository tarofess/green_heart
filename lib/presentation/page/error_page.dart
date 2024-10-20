import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorPage extends StatelessWidget {
  final Object? error;
  final VoidCallback retry;

  const ErrorPage({super.key, this.error, required this.retry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$error', style: TextStyle(fontSize: 14.sp)),
              SizedBox(height: 16.r),
              ElevatedButton(
                onPressed: retry,
                child: const Text('リトライ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
