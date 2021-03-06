# Modifications Copyright (c) 2017 JDFind
# Original work Copyright (c) 2016 Tzutalin
# For licensing, read LICENSE
#
# Script for downloading android-ndk-downloader, opencv, opencv contrib 
# Requires git
# Usage:
#     $ ./setup.sh [-v <opencv_version>]

# Define function
function checkout_master() {
	git fetch
	git checkout -f master
	git reset --hard origin/master
}

function checkout_clean() {
	git fetch
	git -c advice.detachedHead=false checkout -f $1
	git clean -fd
}

# read Open Cv version
OPENCV_VERSION=3.3.0
while getopts "v:" opts; do
    case ${opts} in
        v) OPENCV_VERSION=${OPTARG} ;;
    esac
done
echo "Using Open CV version ${OPENCV_VERSION}"

# setup path
SCRIPT=$(readlink -f $0)
WD=`dirname $SCRIPT`

# clone android-ndk-downloader
if [ ! -d "${WD}/android-ndk-downloader" ]; then
    echo 'Cloning android-ndk-downloader'
    git clone https://github.com/JDFind/android-ndk-downloader.git
fi

# checkout latest android-ndk-downloader
cd android-ndk-downloader
checkout_master

# launch android-ndk-downloader
python download_ndk.py

# download android-cmake
cd "${WD}"
if [ ! -d "${WD}/android-cmake" ]; then
    echo 'Cloning android-cmake'
    git clone https://github.com/JDFind/android-cmake.git
fi

# checkout latest android-cmake
cd android-cmake
checkout_master

# clone OpenCV
cd "${WD}"
if [ ! -d "${WD}/opencv" ]; then
    echo 'Cloning opencv'
    git clone https://github.com/opencv/opencv.git
fi

# checkout the specified version of OpenCV
cd opencv
checkout_clean "${OPENCV_VERSION}"

# clone OpenCV Contrib
cd "${WD}"
if [ ! -d "${WD}/opencv_contrib" ]; then
    echo 'Cloning opencv_contrib'
    git clone https://github.com/opencv/opencv_contrib.git
fi

# checkout the specified version of OpenCV Contrib
cd opencv_contrib
checkout_clean "${OPENCV_VERSION}"

cd "${WD}"

echo "Press any key to continue..."
read answer
