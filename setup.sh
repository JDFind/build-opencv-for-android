# Modifications Copyright (c) 2017 JDFind
# Original work Copyright (c) 2016 Tzutalin
# For licensing, read LICENSE
#
# Script for downloading android-ndk-downloader, opencv, opencv contrib 
# Requires git
# Usage:
#     $ ./setup.sh [-v <opencv_version>]

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
    git clone --recursive https://github.com/tzutalin/android-ndk-downloader.git
    cd android-ndk-downloader
    python download_ndk.py
fi

# clone Open CV
cd "${WD}"
if [ ! -d "${WD}/opencv" ]; then
    echo 'Cloning opencv'
    git clone https://github.com/opencv/opencv.git
fi
cd opencv
git checkout -b "${OPENCV_VERSION}" "${OPENCV_VERSION}"

# clone Open CV Contrib
cd "${WD}"
if [ ! -d "${WD}/opencv_contrib" ]; then
    echo 'Cloning opencv_contrib'
    git clone https://github.com/opencv/opencv_contrib.git
fi
cd opencv_contrib
git checkout -b "${OPENCV_VERSION}" "${OPENCV_VERSION}"

cd "${WD}"

echo "Press any key to continue..."
read answer
