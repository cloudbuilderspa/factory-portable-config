# Flutter Android CLI Setup (macOS)

Minimal CLI steps for building Flutter Android apps.

## 1) Install prerequisites

- Flutter SDK: https://docs.flutter.dev/get-started/install
- Android Studio (includes SDK Manager): https://developer.android.com/studio

## 2) Install Android command-line tools

Open **Android Studio → Settings → Appearance & Behavior → System Settings → Android SDK** and install:

- **Android SDK Platform** (latest stable)
- **Android SDK Build-Tools**
- **Android SDK Command-line Tools (latest)**

## 3) Set environment variables

Add to your shell profile (`~/.zshrc` or `~/.bashrc`):

```bash
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
```

Reload your shell:

```bash
source ~/.zshrc
```

## 4) Accept licenses + verify

```bash
sdkmanager --licenses
flutter doctor --android-licenses
flutter doctor
```

If `sdkmanager` is not found, ensure **Command-line Tools (latest)** is installed and `cmdline-tools/latest/bin` is on your `PATH`.
