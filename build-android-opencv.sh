#!/bin/bash

# ABIs setup
declare -a ANDROID_ABI_LIST=("armeabi" "armeabi-v7a" "arm64-v8a" "x86" "x86_64" "mips" "mips64")

# path setup
SCRIPT=$(readlink -f $0)
WD=`dirname $SCRIPT`
OPENCV_ROOT="${WD}/opencv"
N_JOBS=${N_JOBS:-4}

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
          -D ANDROID_NATIVE_API_LEVEL=${API_LEVEL} \
          -D ANDROID_ABI="${ANDROID_ABI}" \
          -D WITH_CUDA=OFF \
          -D WITH_MATLAB=OFF \
          -D BUILD_ANDROID_EXAMPLES=OFF \
          -D BUILD_DOCS=OFF \
          -D BUILD_PERF_TESTS=OFF \
          -D BUILD_TESTS=OFF \
		  -D BUILD_EXAMPLES=OFF \
		  -D BUILD_SHARED_LIBS=OFF \
          -D OPENCV_EXTRA_MODULES_PATH="${WD}/opencv_contrib/modules/"  \
          ../..
		  
    # Build it
    make -j${N_JOBS}
	
    # Install it
    make install/strip
	
    # Remove temp build folder
    cd "${WD}"
    rm -rf "${temp_build_dir}"
	
    echo "end building ${ANDROID_ABI} version"
done

echo "Press any key to continue..."
read answer