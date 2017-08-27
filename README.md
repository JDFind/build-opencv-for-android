# Build-opencv-for-android (Depreciated)

An interactive script to download and build opencv and opencv_contrib for Android

### Requirements
 - Python >=2.4
 - CMake >=2.8

### Installation
```sh
$ git clone https://github.com/tzutalin/build-opencv-for-android.git
$ cd build-opencv-for-android
$ ./setup.sh 3.1.0
```
By default, it will download opencv and opencv_contrib with 3.1.0 version. You can specify the version when executing ./setup.sh

Extract and export your android path which is downloaded under ./android-ndk-downloader

`$ export [ANDROID_NDK_PATH]`

Build it

```sh
$ ./build-android-opencv.sh
```

The final library will be located in android_lib folder
