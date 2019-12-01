---
layout: guide
title:  "Building Caffe with Matlab, Opencv3, and python2/3 with virtualenvs"
updated:   2017-05-03
categories: guides
tags:
- learning
- code
- programming
published: false
---

I am leaving this up for the sake of posterity. It should absolutely not be followed. I think it is probably best to just not use matcaffe for anything...






Installing Caffe is a huge pain. Here is how I am doing it. I don't have a GPU, I want to be able to run in python2 and python3 as well as Matlab. I haven't tested this enough to know if it works how I want it to, I am in the process of learning caffe. This is mostly just for my notes.

There is a really good [reference](https://github.com/BVLC/caffe/wiki/Ubuntu-16.04-or-15.10-Installation-Guide) and the official (not so good) [Install Instructions](caffe.berkeleyvision.org/installation.html)

## Some dependencies:
### Matlab
Matlab installation kind of varies based on where you get it from, butmake sure it is installed

#### Setting up MEX compilation
Matlab needs an older compiler, 4.9
{% highlight bash %}
sudo apt-get install gcc-4.9 g++-4.9
# you may need to update alternatives
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 20
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.9 20
sudo update-alternatives --config gcc
sudo update-alternatives --config g++
{% endhighlight %}

This may or may not be necessary:
`sudo gedit /usr/local/MATLAB/R2017a/bin/mexopts.sh`
edit line 54 from `CC='gcc'` to `CC='gcc-4.9'` and edit line 69 from `CXX='g++'` to `CXX='g++-4.9'`

### General stuff
First get all the easy stuff out of the way (copied from the [guide](https://github.com/BVLC/caffe/wiki/Ubuntu-16.04-or-15.10-Installation-Guide))

{% highlight bash %}
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y build-essential cmake git pkg-config
sudo apt-get install -y libprotobuf-dev libleveldb-dev libsnappy-dev libhdf5-serial-dev protobuf-compiler
sudo apt-get install -y libatlas-base-dev
sudo apt-get install -y --no-install-recommends libboost-all-dev
sudo apt-get install -y libgflags-dev libgoogle-glog-dev liblmdb-dev

# (Python general)
sudo apt-get install -y python-pip

# (Python 2.7 development files)
sudo apt-get install -y python-dev
# sudo apt-get install -y python-numpy python-scipy # honestly not sure that this is needed

# (or, Python 3.5 development files)
sudo apt-get install -y python3-dev
# sudo apt-get install -y python3-numpy python3-scipy
# sudo apt-get install -y python-numpy python-scipy

# (OpenCV 2.4)
# sudo apt-get install -y libopencv-dev # I prefer to use 3.2
{% endhighlight %}

### OpenCV
I follow this [guide](http://www.pyimagesearch.com/2016/10/24/ubuntu-16-04-how-to-install-opencv/) except that I use OpenCV 3.2.

### Python
I chose to try to install for both python 2 and 3 in virtual environments. So:

{% highlight bash %}
mkvirtualenv caffe2 -p python2
mkvirtualenv caffe3 -p python3
{% endhighlight %}

Then I went into the python folder in the caffe repo and executed: `for req in $(cat requirements.txt); do pip install $req; done` for each of the virtual env (`workon caffe2`, `workon caffe3`)

### Weird naming
I then followed the instructions from the guide and did some sym linking:

{% highlight bash %}
cd /usr/lib/x86_64-linux-gnu
sudo ln -s libhdf5_serial.so.10.1.0 libhdf5.so
sudo ln -s libhdf5_serial_hl.so.10.0.2 libhdf5_hl.so
{% endhighlight %}


## Make File
I then edited the makefile (first copy the example to make your working copy):

{% highlight make %}
## Refer to http://caffe.berkeleyvision.org/installation.html
# Contributions simplifying and improving our build system are welcome!

# cuDNN acceleration switch (uncomment to build with cuDNN).
# USE_CUDNN := 1

# CPU-only switch (uncomment to build without GPU support).
CPU_ONLY := 1

# uncomment to disable IO dependencies and corresponding data layers
# USE_OPENCV := 0
# USE_LEVELDB := 0
# USE_LMDB := 0

# uncomment to allow MDB_NOLOCK when reading LMDB files (only if necessary)
#	You should not set this flag if you will be reading LMDBs with any
#	possibility of simultaneous read and write
# ALLOW_LMDB_NOLOCK := 1

# Uncomment if you're using OpenCV 3
 OPENCV_VERSION := 3

# To customize your choice of compiler, uncomment and set the following.
# N.B. the default for Linux is g++ and the default for OSX is clang++
# CUSTOM_CXX := g++

# CUDA directory contains bin/ and lib/ directories that we need.
CUDA_DIR := /usr/local/cuda
# On Ubuntu 14.04, if cuda tools are installed via
# "sudo apt-get install nvidia-cuda-toolkit" then use this instead:
# CUDA_DIR := /usr

# CUDA architecture setting: going with all of them.
# For CUDA < 6.0, comment the *_50 through *_61 lines for compatibility.
# For CUDA < 8.0, comment the *_60 and *_61 lines for compatibility.
CUDA_ARCH := -gencode arch=compute_20,code=sm_20 \
		-gencode arch=compute_20,code=sm_21 \
		-gencode arch=compute_30,code=sm_30 \
		-gencode arch=compute_35,code=sm_35 \
		-gencode arch=compute_50,code=sm_50 \
		-gencode arch=compute_52,code=sm_52 \
		-gencode arch=compute_60,code=sm_60 \
		-gencode arch=compute_61,code=sm_61 \
		-gencode arch=compute_61,code=compute_61

# BLAS choice:
# atlas for ATLAS (default)
# mkl for MKL
# open for OpenBlas
BLAS := atlas
# Custom (MKL/ATLAS/OpenBLAS) include and lib directories.
# Leave commented to accept the defaults for your choice of BLAS
# (which should work)!
# BLAS_INCLUDE := /path/to/your/blas
# BLAS_LIB := /path/to/your/blas

# Homebrew puts openblas in a directory that is not on the standard search path
# BLAS_INCLUDE := $(shell brew --prefix openblas)/include
# BLAS_LIB := $(shell brew --prefix openblas)/lib

# This is required only if you will compile the matlab interface.
# MATLAB directory should contain the mex binary in /bin.
MATLAB_DIR := /usr/local/MATLAB/R2017a
# MATLAB_DIR := /Applications/MATLAB_R2012b.app

# NOTE: this is required only if you will compile the python interface.
# We need to be able to find Python.h and numpy/arrayobject.h.
 PYTHON_INCLUDE := ~/.virtualenvs/caffe2/include/python2.7 \
		~/.virtualenvs/caffe2/lib/python2.7/site-packages/numpy/core/include/
# Anaconda Python distribution is quite popular. Include path:
# Verify anaconda location, sometimes it's in root.
# ANACONDA_HOME := $(HOME)/anaconda
# PYTHON_INCLUDE := $(ANACONDA_HOME)/include \
		# $(ANACONDA_HOME)/include/python2.7 \
		# $(ANACONDA_HOME)/lib/python2.7/site-packages/numpy/core/include

# Uncomment to use Python 3 (default is Python 2)
PYTHON_LIBRARIES := boost_python3 python3.5m
PYTHON_INCLUDE := ~/.virtualenvs/caffe3/include/python3.5m \
                ~/.virtualenvs/caffe3/lib/python3.5/site-packages/numpy/core/include/

# We need to be able to find libpythonX.X.so or .dylib.
PYTHON_LIB := /usr/lib
# PYTHON_LIB := $(ANACONDA_HOME)/lib

# Homebrew installs numpy in a non standard path (keg only)
# PYTHON_INCLUDE += $(dir $(shell python -c 'import numpy.core; print(numpy.core.__file__)'))/include
# PYTHON_LIB += $(shell brew --prefix numpy)/lib

# Uncomment to support layers written in Python (will link against Python libs)
# WITH_PYTHON_LAYER := 1

# Whatever else you find you need goes here.
INCLUDE_DIRS := $(PYTHON_INCLUDE) /usr/local/include \
		/usr/include/hdf5/serial/
LIBRARY_DIRS := $(PYTHON_LIB) /usr/local/lib /usr/lib /usr/lib/x86_64-linux-gnu/hdf5/serial #/usr/local/share/OpenCV/3rdparty/lib/

 LIBRARIES += glog gflags protobuf leveldb snappy \
  lmdb boost_system boost_filesystem hdf5_hl hdf5 m \
  opencv_core opencv_highgui opencv_imgproc opencv_imgcodecs opencv_videoio

# If Homebrew is installed at a non standard location (for example your home directory) and you use it for general dependencies
# INCLUDE_DIRS += $(shell brew --prefix)/include
# LIBRARY_DIRS += $(shell brew --prefix)/lib

# NCCL acceleration switch (uncomment to build with NCCL)
# https://github.com/NVIDIA/nccl (last tested version: v1.2.3-1+cuda8.0)
# USE_NCCL := 1

# Uncomment to use `pkg-config` to specify OpenCV library paths.
# (Usually not necessary -- OpenCV libraries are normally installed in one of the above $LIBRARY_DIRS.)
# USE_PKG_CONFIG := 1

# N.B. both build and distribute dirs are cleared on `make clean`
BUILD_DIR := build
DISTRIBUTE_DIR := distribute

# Uncomment for debugging. Does not work on OSX due to https://github.com/BVLC/caffe/issues/171
# DEBUG := 1

# The ID of the GPU that 'make runtest' will use to run unit tests.
TEST_GPUID := 0

# enable pretty build (comment to see full commands)
	Q ?= @

  {% endhighlight %}

## build
Finally, I build and test:

{% highlight bash %}
make all
make test
make runtest
make pycaffe
make matcaffe
make mattest
make distribute
{% endhighlight %}

## Final touch up to help python find caffe
