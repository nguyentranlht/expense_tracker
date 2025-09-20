# Flutter ScreenUtil và App Localizations Setup

Đã thêm thành công **flutter_screenutil** và **app_localizations** vào ứng dụng Expense Tracker để hỗ trợ responsive design và đa ngôn ngữ.

## 🎯 Tính năng đã thêm

### 1. Responsive Design với ScreenUtil
- **Package**: `flutter_screenutil: ^5.9.3`
- **Design Size**: 375x812 (iPhone X)
- **Tự động điều chỉnh**: Text size, icon size, padding, margin

### 2. Multi-language Support
- **Ngôn ngữ hỗ trợ**: Tiếng Việt (vi), Tiếng Anh (en)
- **Auto-generation**: Từ file ARB
- **Lưu preferences**: Ghi nhớ ngôn ngữ đã chọn

## 📁 File Structure

```
lib/
├── l10n/                          # Localization files
│   ├── app_en.arb                # English translations
│   ├── app_vi.arb                # Vietnamese translations
│   └── generated/                # Auto-generated files
│       ├── app_localizations.dart
│       ├── app_localizations_en.dart
│       └── app_localizations_vi.dart
├── core/utils/
│   └── localization_helper.dart  # Helper extension for easy access
├── providers/
│   └── locale_provider.dart      # State management for locale
├── widgets/
│   └── language_switcher.dart    # Widget để chuyển đổi ngôn ngữ
└── features/demo/
    └── responsive_example.dart   # Ví dụ sử dụng responsive design
```

## 🚀 Cách sử dụng

### 1. Responsive Design

```dart
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Font size responsive
Text(
  'Hello',
  style: TextStyle(fontSize: 16.sp), // sp = scaled pixels
)

// Width/Height responsive
Container(
  width: 200.w,    // w = responsive width
  height: 100.h,   // h = responsive height
  padding: EdgeInsets.all(16.w),
)

// Icon size responsive
Icon(
  Icons.home,
  size: 24.sp,
)
```

### 2. Localization

```dart
import 'package:your_app/core/utils/localization_helper.dart';

// Sử dụng extension
Text(context.l10n.appTitle)
Text(context.l10n.hello)
Text(context.l10n.expenses)

// Hoặc sử dụng helper class
Text(LocalizationHelper.of(context).appTitle)
```

### 3. Thay đổi ngôn ngữ

```dart
import 'package:provider/provider.dart';
import 'package:your_app/providers/locale_provider.dart';

// Trong widget
Consumer<LocaleProvider>(
  builder: (context, localeProvider, child) {
    return ElevatedButton(
      onPressed: () {
        // Chuyển sang tiếng Anh
        localeProvider.setLocale(const Locale('en'));
        
        // Chuyển sang tiếng Việt
        localeProvider.setLocale(const Locale('vi'));
      },
      child: Text('Change Language'),
    );
  },
)
```

## 📝 Thêm text mới

### Bước 1: Thêm vào file ARB

**lib/l10n/app_en.arb:**
```json
{
  "newText": "New Text",
  "@newText": {
    "description": "Description of the new text"
  }
}
```

**lib/l10n/app_vi.arb:**
```json
{
  "newText": "Text Mới"
}
```

### Bước 2: Generate lại code

```bash
flutter gen-l10n
```

### Bước 3: Sử dụng

```dart
Text(context.l10n.newText)
```

## 🎨 Language Switcher Widget

Đã tạo sẵn widget `LanguageSwitcher` có thể sử dụng ở bất kỳ đâu:

```dart
import 'package:your_app/widgets/language_switcher.dart';

AppBar(
  title: Text('Settings'),
  actions: [
    LanguageSwitcher(), // Popup menu để chọn ngôn ngữ
  ],
)
```

## 🔧 Configuration Files

### pubspec.yaml
- Đã thêm `flutter_localizations`, `flutter_screenutil`, `provider`
- Enabled `generate: true` cho auto-generation

### l10n.yaml
```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
output-dir: lib/l10n/generated
```

### main.dart
- Wrap app với `ScreenUtilInit`
- Setup `LocaleProvider` với Provider
- Configure `localizationsDelegates`

## 💡 Tips

1. **Responsive Design**:
   - Sử dụng `.sp` cho font size
   - Sử dụng `.w` và `.h` cho width/height
   - Sử dụng `.r` cho border radius

2. **Localization**:
   - Luôn thêm description cho text trong file ARB
   - Sử dụng extension `context.l10n` cho code ngắn gọn
   - Test trên cả 2 ngôn ngữ

3. **Performance**:
   - ScreenUtil chỉ init một lần trong main.dart
   - Locale được cache trong SharedPreferences

## 🧪 Testing

Để test responsive design và localization:

1. **Responsive**: Thay đổi device size trong simulator/emulator
2. **Localization**: Sử dụng LanguageSwitcher hoặc thay đổi system language

## 📱 Supported Devices

ScreenUtil sẽ tự động scale cho:
- iPhone (các size)
- Android phones
- Tablets
- Different screen densities