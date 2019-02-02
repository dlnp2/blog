REPOS_DIR=~/repos/third-party
OCV_VERSION="3.4.4"
OCV_INSTALL_PREFIX=~/workspace/third-party/opencv

# sed -i.bak -e "s%http://[^ ]\+%http://ftp.riken.go.jp/Linux/ubuntu/%g" /etc/apt/sources.list
apt-get update
apt-get install -y git wget curl

# Install gRPC
apt-get install -y build-essential autoconf libtool pkg-config libgflags-dev libgtest-dev clang libc++-dev

mkdir -p $REPOS_DIR && cd $REPOS_DIR
git clone -b $(curl -L https://grpc.io/release) https://github.com/grpc/grpc
cd grpc
git submodule update --init
make -j4 && make install
# install protoc
cd third_party/protobuf
make install

# Install OpenCV3
cd $REPOS_DIR

apt-get install -y cmake libeigen3-dev libgtk-3-dev qt5-default freeglut3-dev \
libvtk6-qt-dev libtbb-dev ffmpeg libdc1394-22-dev libavcodec-dev libavformat-dev \
libswscale-dev libjpeg-dev libjasper-dev libpng++-dev libtiff5-dev \
libopenexr-dev libwebp-dev libhdf5-dev libpython3.5-dev python3-numpy \
python3-scipy python3-matplotlib python3-pip libopenblas-dev liblapacke-dev

wget https://github.com/opencv/opencv/archive/"$OCV_VERSION".tar.gz
tar xvf "$OCV_VERSION".tar.gz
rm "OCV_VERSION".tar.gz
mkdir opencv-"$OCV_VERSION"/build
cd opencv-"$OCV_VERSION"/build
cmake -G "Unix Makefiles" --build . -D BUILD_CUDA_STUBS=OFF -D BUILD_DOCS=OFF \
-D BUILD_EXAMPLES=OFF -D BUILD_JASPER=OFF -D BUILD_JPEG=OFF -D BUILD_OPENEXR=OFF \
-D BUILD_PACKAGE=ON -D BUILD_PERF_TESTS=OFF -D BUILD_PNG=OFF -D BUILD_SHARED_LIBS=ON \
-D BUILD_TBB=OFF -D BUILD_TESTS=OFF -D BUILD_TIFF=OFF -D BUILD_WITH_DEBUG_INFO=ON \
-D BUILD_ZLIB=OFF -D BUILD_WEBP=OFF -D BUILD_opencv_apps=ON -D BUILD_opencv_calib3d=OFF \
-D BUILD_opencv_core=ON -D BUILD_opencv_cudaarithm=OFF -D BUILD_opencv_cudabgsegm=OFF \
-D BUILD_opencv_cudacodec=OFF -D BUILD_opencv_cudafeatures2d=OFF -D BUILD_opencv_cudafilters=OFF \
-D BUILD_opencv_cudaimgproc=OFF -D BUILD_opencv_cudalegacy=OFF -D BUILD_opencv_cudaobjdetect=OFF \
-D BUILD_opencv_cudaoptflow=OFF -D BUILD_opencv_cudastereo=OFF -D BUILD_opencv_cudawarping=OFF \
-D BUILD_opencv_cudev=OFF -D BUILD_opencv_features2d=OFF -D BUILD_opencv_flann=OFF \
-D BUILD_opencv_highgui=ON -D BUILD_opencv_imgcodecs=ON -D BUILD_opencv_imgproc=ON \
-D BUILD_opencv_java=OFF -D BUILD_opencv_ml=OFF -D BUILD_opencv_objdetect=OFF \
-D BUILD_opencv_photo=OFF -D BUILD_opencv_python2=ON -D BUILD_opencv_python3=ON \
-D BUILD_opencv_shape=OFF -D BUILD_opencv_stitching=OFF -D BUILD_opencv_superres=OFF \
-D BUILD_opencv_ts=ON -D BUILD_opencv_video=OFF -D BUILD_opencv_videoio=ON -D BUILD_opencv_dnn=OFF \
-D BUILD_opencv_videostab=OFF -D BUILD_opencv_viz=OFF -D BUILD_opencv_world=OFF \
-D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=$OCV_INSTALL_PREFIX \
-D WITH_1394=ON -D WITH_CUBLAS=OFF -D WITH_CUDA=OFF \
-D WITH_CUFFT=OFF -D WITH_EIGEN=ON -D WITH_FFMPEG=ON -D WITH_GDAL=OFF -D WITH_GPHOTO2=OFF \
-D WITH_GIGEAPI=ON -D WITH_GSTREAMER=OFF -D WITH_GTK=ON -D WITH_INTELPERC=OFF -D WITH_IPP=ON \
-D WITH_IPP_A=OFF -D WITH_JASPER=ON -D WITH_JPEG=ON -D WITH_LIBV4L=ON -D WITH_OPENCL=ON \
-D WITH_OPENCLAMDBLAS=OFF -D WITH_OPENCLAMDFFT=OFF -D WITH_OPENCL_SVM=OFF -D WITH_OPENEXR=ON \
-D WITH_OPENGL=ON -D WITH_OPENMP=OFF -D WITH_OPENNI=OFF -D WITH_PNG=ON -D WITH_PTHREADS_PF=OFF \
-D WITH_PVAPI=OFF -D WITH_QT=ON -D WITH_TBB=ON -D WITH_TIFF=ON -D WITH_UNICAP=OFF \
-D WITH_V4L=OFF -D WITH_VTK=OFF -D WITH_WEBP=ON -D WITH_XIMEA=OFF -D WITH_XINE=OFF \
-D WITH_LAPACKE=ON -D WITH_MATLAB=OFF ..

make -j4 && make install
