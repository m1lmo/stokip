import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:stokip/main.dart';
import 'package:stokip/product/constants/enums/notify_type_enum.dart';
import 'package:stokip/product/helper/ticker_provider_service.dart';

class CNotify {
  CNotify({
    this.duration,
    this.title,
    this.type = NotifyType.error,
    this.message = '',
  }) {
    _animationController = AnimationController(
      vsync: tickerProviderService,
      duration: const Duration(milliseconds: 400),
    );
  }
  final String? title;
  final int? duration;
  final NotifyType? type;
  String? message;
  bool isOpen = false;
  late OverlayEntry overlayEntry;
  late AnimationController _animationController;

  /// call this method to show the notification
  void show() {
    _animationController.forward();
    isOpen = true;
    final overlayState = navigator.currentState!.overlay!;
    overlayEntry = OverlayEntry(
      builder: (context) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(_animationController),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Wrap(
              children: [
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: type == NotifyType.error
                      ? Colors.red
                      : type == NotifyType.success
                          ? Colors.white
                          : Colors.green,
                  elevation: 12,
                  margin: EdgeInsets.all(4.w).copyWith(bottom: 50),
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Row(
                      children: [
                        _getIcon(type ?? NotifyType.error),
                        SizedBox(
                          width: 2.w,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (title != null)
                                Text(
                                  title ?? '',
                                  maxLines: 14,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontFamily: 'Bold',
                                    color: type == NotifyType.error
                                        ? Colors.white
                                        : type == NotifyType.success
                                            ? Colors.black
                                            : Colors.black,
                                  ),
                                ),
                              Text(
                                message ?? '',
                                maxLines: 14,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontSize: 10.sp,
                                      color: type == NotifyType.error
                                          ? Colors.white
                                          : type == NotifyType.success
                                              ? Colors.black
                                              : Colors.black,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        InkWell(
                          onTap: () {
                            _animationController.reverse();
                          },
                          child: Icon(
                            Icons.cancel,
                            color: type == NotifyType.error
                                ? Colors.white
                                : type == NotifyType.success
                                    ? Colors.black
                                    : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    overlayState.insert(overlayEntry);
    Future.delayed(Duration(milliseconds: duration ?? 3000), () {
      _animationController.reverse().then((_) {
        if (overlayEntry.mounted) {
          overlayEntry.remove();
        }
      });
      isOpen = false;
    });
  }

  Widget _getIcon(NotifyType type) {
    switch (type) {
      case NotifyType.success:
        return const Icon(Icons.check_circle_outline_outlined, color: Colors.green);
      case NotifyType.warning:
        return const Icon(Icons.warning_amber_outlined, color: Colors.yellow);
      case NotifyType.error:
        return const Icon(Icons.error_outline_outlined, color: Colors.red);
    }
  }
}
