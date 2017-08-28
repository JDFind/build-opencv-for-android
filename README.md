# Building OpenCV for Android
This project stands as an entry point for building OpenCV and OpenCV Contrib for the Android Platform.
Besides the two bash scripts from this repository, other scripts, toolchains and SDKs are necessary. I compiled a list in the tutorial below.

# Why do it yourself?
OpenCV already offers pre-build Android bundles, available on [sourceforge](https://sourceforge.net/projects/opencvlibrary/files/opencv-android/). Those bundles do not contain all the (if any) modules from [contrib](https://github.com/opencv/opencv_contrib).

This was an issue for me, as I intended to use the [Face Recognizer](http://docs.opencv.org/2.4/modules/contrib/doc/facerec/index.html) class, so I ended up building both OpenCV and OpenCV Contrib from sources.

Although the scripts are supposed to work both on Linux and Windows, I encountered more difficulties on Windows.
In order to fix and avoid future frustration, I adapted some existing tools, performed troubleshooting and compiled this tutorial.

### Requirements
 - for Windows: bash support 
 - Git
 - Python >=2.4 <sup>[1]</sup>
 - CMake >=2.8
 - JDK
 - Apache Ant
 - Android SDK Tools (version 25.2.5 or earlier <sup>[2]</sup>)
 - Android NDK (will be downloaded by the `android-ndk-downloader`)
 - [android-ndk-downloader](https://github.com/JDFind/android-ndk-downloader) (will be downloaded by `setup.sh`)
 - [android-cmake](https://github.com/JDFind/android-cmake.git) (will be downloaded by `setup.sh`)
 - for Windows: MinGW/ GNU Make <sup>[3]</sup> or Ninja <sup>[4]</sup>
 
[1] Android NDK comes with `python` in `ANDROID_NDK_ROOT/prebuilt/linux-<variant>/bin/` (for Linux), or `python.exe` in `ANDROID_NDK_ROOT/prebuilt/windows-<variant>/bin/` (for Windows)
 
[2] Starting with SDK Tools 23.5.0, Google removed Ant build support. See: https://github.com/opencv/opencv/issues/8460

[3] Android NDK comes with `make.exe`, in `ANDROID_NDK_ROOT/prebuilt/windows-<variant>/bin/` directory 

[4] In my experience, [Ninja](https://github.com/ninja-build/ninja) performs builds faster than MinGW Make and much faster than GNU Make
 

### Setup
Clone repository and run `setup.sh`

```sh
$ git clone https://github.com/JDFind/build-opencv-for-android.git
$ cd build-opencv-for-android
$ ./setup.sh [-v <opencv_version>]
```

This script will clone and checkout the specified version (default 3.3.0) of OpenCV and OpenCV Contrib and the latest versions of android-ndk-downloader and android-cmake.

The android-ndk-downloader will automatically be launched. After specifying the version, the Android NDK will be downloaded under `./android-ndk-downloader`.

### Environment Variables
For the toolchain to work correctly, the following environment variables are needed:
- `JAVA_HOME` set to the root of JDK
- `JAVA_HOME/bin` added to `PATH`
- `ANDROID_SDK_HOME` set to the root of Android SDK directory
- `ANDROID_SDK_HOME/bin` added to `PATH`
- `ANDROID_NDK_ROOT` set to the root of Android NDK directory
- `ANT_HOME` set to the root of Apache Ant directory
- `ANT_HOME/bin` added to `PATH`
- `ANT_HOME/bin` added to `PATH`
- `git` added to `PATH`
- `python` added to `PATH`
- `cmake` added to `PATH`
- `make` or `ninja` added to `PATH`

### Enabling Modules
To include extra modules in the Java Wrapper, you must follow the steps below:
- navigate to `opencv_contrib/modules/<target_module>`
- open `CMakeLists.txt`
- check the parameters of `ocv_define_module` and add `java` after `WRAP` keyword if not present
- if the `ocv_define_module` does not contain `WRAP`, add that before `java`
<pre>
ocv_define_module(face opencv_core opencv_imgproc opencv_objdetect <b>WRAP</b> python <b>java</b>)
</pre>

**Note:** re-running `setup.sh` restores the contents of *opencv*, *opencv-contrib*, *android-cmake* and *ndk-downloader* to their original state, overriding any changes

### Building
After completing the steps above, run the appropriate script for your machine (`build-linux`, `build-win-make` or `build-win-ninja`).
```sh
$ ./build-win-ninja.sh
```
The final library will be located in `android_opencv/opencv` directory.

If you have any suggestions or questions regarding this project, feel free to submit issues or create pull requests.
