# Save Memory

A tiny Android app with one job: open the **Samsung Memory** app's capture screen
(`ScreenCaptureViewerActivity`) as a **real launcher app** — so it shows up in your app
drawer, can be pinned to a sidebar (Edge panel / Good Lock Home Up), and can be bound to
gestures, which a plain shortcut can't do.

It uses Samsung's own Memory icon, pulled from the installed app, with the label **Save Memory**
so you can tell it apart from the main Memory app.

## How it works

Tap the icon -> the app starts `com.samsung.android.app.memory/.feature.capture.ScreenCaptureViewerActivity` and immediately closes itself. No UI of its own.

https://github.com/incconutwo/save-memory/raw/main/media/how-it-works.mp4

> If GitHub doesn't play it inline, open [`media/how-it-works.mp4`](media/how-it-works.mp4).

## Install

1. Download `MemoryLauncher.apk` from this repo (or build it, see below).
2. Install it (`adb install -r MemoryLauncher.apk`, or open it on the phone).
3. Make sure Samsung **Memory** (One UI 9.5, `com.samsung.android.app.memory`) is installed.

## Three-finger swipe down gesture (Good Lock > Home Up)

Bind Save Memory to a three-finger swipe down on the home screen. Video walkthrough:

https://github.com/incconutwo/save-memory/raw/main/media/three-finger-swipe-setup.mp4

> Or open [`media/three-finger-swipe-setup.mp4`](media/three-finger-swipe-setup.mp4).

Note: reported by an early tester — the three-finger swipe may not trigger on every setup; the app itself works as expected.

## Build from source

No Gradle needed. Requires JDK and Android SDK (build-tools 36, platform 35):

```powershell
./build.ps1
```

The script compiles resources with `aapt2`, builds with `javac` + `d8`, then aligns and signs the APK with a locally generated debug key.

## Notes

- Package: `com.pcpicker.memorylauncher`, min SDK 26.
- Targets the Samsung Memory app only; the activity must be exported on your firmware (it is on One UI 9.5 builds tested).
- The Memory icon and name belong to Samsung; this project is unofficial and not affiliated with Samsung.
