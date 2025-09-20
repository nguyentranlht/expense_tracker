import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return PopupMenuButton<Locale>(
          icon: Icon(
            Icons.language,
            size: 24.sp,
          ),
          initialValue: localeProvider.locale,
          onSelected: (Locale locale) {
            localeProvider.setLocale(locale);
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<Locale>(
              value: const Locale('en'),
              child: Row(
                children: [
                  Text('🇺🇸', style: TextStyle(fontSize: 20.sp)),
                  SizedBox(width: 8.w),
                  Text(
                    'English',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  if (localeProvider.locale.languageCode == 'en')
                    Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: Icon(
                        Icons.check,
                        size: 16.sp,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                ],
              ),
            ),
            PopupMenuItem<Locale>(
              value: const Locale('vi'),
              child: Row(
                children: [
                  Text('🇻🇳', style: TextStyle(fontSize: 20.sp)),
                  SizedBox(width: 8.w),
                  Text(
                    'Tiếng Việt',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  if (localeProvider.locale.languageCode == 'vi')
                    Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: Icon(
                        Icons.check,
                        size: 16.sp,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}