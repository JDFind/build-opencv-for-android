# Modifications Copyright (c) 2017 JDFind
# Original work Copyright (c) 2016 Tzutalin
# For licensing, read LICENSE

### path setup

OPENCV_VERSION=3.1.0

if [ ! -z "$1" ]
  then
    OPENCV_VERSION="$1"
fi

echo "Opnecv version ${OPENCV_VERSION}"

SCRIPT=$(readlink -f $0)
WD=`dirname $SCRIPT`
### Download android-ndk-downloader
if [ ! -d "${WD}/android-ndk-downloader" ]; then
    echo 'Cloning android-ndk-downloader'
    git clone --recursive https://github.com/tzutalin/android-ndk-downloader.git
    cd android-ndk-downloader
    python download_ndk.py
fi

cd "${WD}"
if [ ! -d "${WD}/opencv" ]; then
    echo 'Cloning opencv'
    git clone https://github.com/opencv/opencv.git
fi
cd opencv
git checkout -b "${OPENCV_VERSION}" "${OPENCV_VERSION}"

cd "${WD}"
if [ ! -d "${WD}/opencv_contrib" ]; then
    echo 'Cloning opencv_contrib'
    git clone https://github.com/opencv/opencv_contrib.git
fi
cd opencv_contrib
git checkout -b "${OPENCV_VERSION}" "${OPENCV_VERSION}"

cd "${WD}"
