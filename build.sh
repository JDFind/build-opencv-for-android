# Script for building OpenCV and OpenCV Contrib for Android
# Requires Cmake and MinGW/ GNU Make or Ninja (depending on parameters)
#
# Usage:
#     $ ./build.sh [-p <platform-variant>] [-j <num_parallel_build_jobs>
#
# Parameters:
# -p <platform-variant>
#		optional parameter to specify the utility used to build and install
#		can be one of "win-make" (for make.exe) and "win-ninja" for (ninja.exe)
#		by default, Unix make is used
# -j <num_parallel_build_jobs>
# 		optional parameter to specify the number of parallel buid jobs
#		default is 4

#!/bin/bash

# define variables based on parameters
CMAKE_EXTRA_PARAMS=''
NUM_JOBS=4
BUILD_COMMAND="make -j${NUM_JOBS}"
INSTALL_COMMAND="make install/strip"

# read platform-variant and job-number parameters
while getopts "p:j:" opts; do
    case ${opts} in
		j)
			NUM_JOBS="${OPTARG}";;
        p) 
			case ${OPTARG} in
				win-make)
					MAKE_LOCATION="$(where make)"
					CMAKE_EXTRA_PARAMS=("-G" "MinGW Makefiles" "-D" "CMAKE_MAKE_PROGRAM=${MAKE_LOCATION}")
					BUILD_COMMAND="make -j${NUM_JOBS}"
					INSTALL_COMMAND="make install/strip"
					;;
				win-ninja)
					NINJA_LOCATION="$(where ninja)"
					CMAKE_EXTRA_PARAMS=("-G" "Ninja" "-D" "CMAKE_MAKE_PROGRAM=${NINJA_LOCATION}")
					BUILD_COMMAND="ninja.exe -C build -j${NUM_JOBS}"
					INSTALL_COMMAND="ninja.exe install"
					;;
			esac
			;;
    esac
done

# ABIs setup
declare -a ANDROID_ABI_LIST=("armeabi" "armeabi-v7a" "arm64-v8a" "x86" "x86_64" "mips" "mips64")

# path setup
SCRIPT=$(readlink -f $0)
WD=`dirname $SCRIPT`
OPENCV_ROOT="${WD}/opencv"

INSTALL_DIR="${WD}/android_opencv"
rm -rf "${INSTALL_DIR}/opencv"
mkdir -p "${INSTALL_DIR}/opencv"

# Make each ABI target sequentially
for i in "${ANDROID_ABI_LIST[@]}"
do
    ANDROID_ABI="${i}"
    echo "Start building ${ANDROID_ABI} version"

    if [ "${ANDROID_ABI}" = "armeabi" ]; then
        API_LEVEL=19
    else
        API_LEVEL=21
    fi

    temp_build_dir="${OPENCV_ROOT}/platforms/build_android_${ANDROID_ABI}"
    ### Remove the build folder first, and create it
    rm -rf "${temp_build_dir}"
    mkdir -p "${temp_build_dir}"
    cd "${temp_build_dir}"
	
    cmake -D CMAKE_BUILD_TYPE=Release \
		  -D CMAKE_BUILD_WITH_INSTALL_RPATH=ON \
		  -D CMAKE_INSTALL_PREFIX="${INSTALL_DIR}/opencv" \
          -D CMAKE_TOOLCHAIN_FILE="${WD}/android-cmake/android.toolchain.cmake" \
          -D ANDROID_NDK="${ANDROID_NDK_ROOT}" \
          -D ANDROID_NATIVE_API_LEVEL="${API_LEVEL}" \
          -D ANDROID_ABI="${ANDROID_ABI}" \
          -D WITH_CUDA=OFF \
          -D WITH_MATLAB=OFF \
          -D BUILD_ANDROID_EXAMPLES=OFF \
          -D BUILD_DOCS=OFF \
          -D BUILD_PERF_TESTS=OFF \
          -D BUILD_TESTS=OFF \
		  -D BUILD_EXAMPLES=OFF \
		  -D BUILD_SHARED_LIBS=OFF \
          -D OPENCV_EXTRA_MODULES_PATH="${WD}/opencv_contrib/modules/" \
		  "${CMAKE_EXTRA_PARAMS[@]}" \
          ../..
		  
    # Build it
    eval "$BUILD_COMMAND"
	
    # Install it
    eval "$INSTALL_COMMAND"
	
    # Remove temp build folder
    cd "${WD}"
    rm -rf "${temp_build_dir}"
	
    echo "end building ${ANDROID_ABI} version"
done

echo "Press any key to continue..."
read answer